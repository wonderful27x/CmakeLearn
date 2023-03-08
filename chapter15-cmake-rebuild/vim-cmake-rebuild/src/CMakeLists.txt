# 设置编译器标志, 这些标志我们可以从原始的项目构建日志中获取
# 在生成源文件之前，我们将把这段代码放在src/CMakeLists.txt的顶部(因为pathdef.c有使用到${CMAKE_C_FLAGS}):
if(CMAKE_C_COMPILER_ID MATCHES GNU)
    set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -g -U_FORTIFY_SOURCE -D_FORTIFY_SOURCE=1")
    set(CMAKE_C_FLAGS_RELEASE "-O2")
    set(CMAKE_C_FLAGS_DEBUG "-O0")
endif()

# 这些文件是自动生成的，我们分别使用不同的函数生成他们
# 自动生成的文件最好放在build目录下，这样就不会破坏原代码目录树，保证一份源码支持多份构建
# pathdef.c：记录安装路径、编译/链接标志、当前用户和主机名
# config.h：编译系统的环境
# osdef.h：由src/osdef.sh生成的文件
include(autogenerate.cmake)
generate_config_h()
generate_pathdef_c()
generate_osdef_h()

# 通过src/Makefile和src/configure.ac了解源码文件进行分组
# 以及那些是必须的，那些是可选的
# 我们将CMake结构重组，构成如下的树结构：
# .
# ├── CMakeLists.txt
# └── src
#       ├── CMakeLists.txt
#       └── libvterm
#       └── CMakeLists.txt

# 添加可执行目标
add_executable(vim main.c)

target_compile_definitions(vim
    PRIVATE
        "HAVE_CONFIG_H"
    )

# target_include_directories(vim
#     PRIVATE
#         ${CMAKE_CURRENT_LIST_DIR}/proto
#         ${CMAKE_CURRENT_BINARY_DIR}
#     )

# 添加基础代码为一个库目标
add_library(basic_sources "")
target_sources(basic_sources
    PRIVATE
        arabic.c beval.c blowfish.c buffer.c charset.c
        crypt.c crypt_zip.c dict.c diff.c digraph.c
        edit.c eval.c evalfunc.c ex_cmds.c ex_cmds2.c
        ex_docmd.c ex_eval.c ex_getln.c farsi.c fileio.c
        fold.c getchar.c hardcopy.c hashtab.c if_cscope.c
        if_xcmdsrv.c json.c list.c main.c mark.c
        memfile.c memline.c menu.c message.c misc1.c
        misc2.c move.c mbyte.c normal.c ops.c
        option.c os_unix.c auto/pathdef.c popupmnu.c pty.c
        quickfix.c regexp.c screen.c search.c sha256.c
        spell.c spellfile.c syntax.c tag.c term.c
        terminal.c ui.c undo.c userfunc.c version.c
        window.c
    )

# 添加头文件目录，因为自动生成的文件在构建目录
# 所以设置了CMAKE_CURRENT_BINARY_DIR
target_include_directories(basic_sources
    PUBLIC
        ${CMAKE_CURRENT_LIST_DIR}/proto
        ${CMAKE_CURRENT_LIST_DIR}
        ${CMAKE_CURRENT_BINARY_DIR}
    )

message(STATUS "src - CMAKE_CURRENT_BINARY_DIR: ${CMAKE_CURRENT_LIST_DIR}")

target_compile_definitions(basic_sources
    PRIVATE
        "HAVE_CONFIG_H"
    )

target_link_libraries(vim
    PUBLIC
        basic_sources
    )

# 添加可选代码为一个目标
add_library(extra_sources "")

if(ENABLE_NETBEANS)
    target_sources(extra_sources
        PRIVATE
            netbeans.c
        )
endif()

if(ENABLE_CHANNEL)
    target_sources(extra_sources
        PRIVATE
            channel.c
        )
endif()

target_include_directories(extra_sources
    PRIVATE
        ${CMAKE_CURRENT_LIST_DIR}/proto
        ${CMAKE_CURRENT_BINARY_DIR}
    )

target_compile_definitions(extra_sources
    PRIVATE
        "HAVE_CONFIG_H"
    )

target_link_libraries(vim
    PUBLIC
        extra_sources
    )

# 添加libvterm，这是一个子项目
if(ENABLE_TERMINAL)
    add_subdirectory(libvterm)
    target_link_libraries(vim
        PUBLIC
            libvterm
        )
endif()

# x11的支持
find_package(X11 REQUIRED)
if(X11_FOUND)
    target_link_libraries(vim
        PUBLIC
            ${X11_LIBRARIES}
        )
endif()

# 添加更多的库依赖，这些库都是通过原始项目构建日志获取的
foreach(_library IN ITEMS Xt SM m tinfo acl gpm dl)
    find_library(_${_library}_found ${_library} REQUIRED)
    if(_${_library}_found)
        target_link_libraries(vim
            PUBLIC
                ${_library}
            )
    endif()
endforeach()

# 安装
install(
    TARGETS
        vim
    RUNTIME DESTINATION
        ${INSTALL_BINDIR}
    )

# 添加测试子项目
# 如果移植的项目包含测试目标，或任何形式的自动化测试，以及测试脚本。第一步，运行传统的测试步骤，并记录所使用的命令。对于Vim项目，可以从src/testdir/Makefile开始。在src/testdir/Makefile和测试脚本中的一些对于测试的定义
add_subdirectory(testdir)
