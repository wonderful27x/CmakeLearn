cmake_minimum_required(VERSION 3.16 FATAL_ERROR)

project(recipe-04
  LANGUAGES CXX
  VERSION 1.0.0
  )

# <<< General set up >>>

set(CMAKE_CXX_STANDARD 11)
set(CMAKE_CXX_EXTENSIONS OFF)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

message(STATUS "Project will be installed to ${CMAKE_INSTALL_PREFIX}")

if(NOT CMAKE_BUILD_TYPE)
  set(CMAKE_BUILD_TYPE Release CACHE STRING "Build type" FORCE)
endif()

message(STATUS "Build type set to ${CMAKE_BUILD_TYPE}")

include(GNUInstallDirs)

set(CMAKE_ARCHIVE_OUTPUT_DIRECTORY ${PROJECT_BINARY_DIR}/${CMAKE_INSTALL_LIBDIR})
set(CMAKE_LIBRARY_OUTPUT_DIRECTORY ${PROJECT_BINARY_DIR}/${CMAKE_INSTALL_LIBDIR})
set(CMAKE_RUNTIME_OUTPUT_DIRECTORY ${PROJECT_BINARY_DIR}/${CMAKE_INSTALL_BINDIR})

# Offer the user the choice of overriding the installation directories
set(INSTALL_LIBDIR ${CMAKE_INSTALL_LIBDIR} CACHE PATH "Installation directory for libraries")
set(INSTALL_BINDIR ${CMAKE_INSTALL_BINDIR} CACHE PATH "Installation directory for executables")
set(INSTALL_INCLUDEDIR ${CMAKE_INSTALL_INCLUDEDIR} CACHE PATH "Installation directory for header files")
# 这里设置了cmake文件的安装目录, 所以我们是知道的
if(WIN32 AND NOT CYGWIN)
  set(DEF_INSTALL_CMAKEDIR CMake)
else()
  set(DEF_INSTALL_CMAKEDIR share/cmake/${PROJECT_NAME})
endif()
set(INSTALL_CMAKEDIR ${DEF_INSTALL_CMAKEDIR} CACHE PATH "Installation directory for CMake files")

# Report to user
foreach(p LIB BIN INCLUDE CMAKE)
  file(TO_NATIVE_PATH ${CMAKE_INSTALL_PREFIX}/${INSTALL_${p}DIR} _path )
  message(STATUS "Installing ${p} components to ${_path}")
  unset(_path)
endforeach()

# 设置超级构建目录
set_property(DIRECTORY PROPERTY EP_BASE ${CMAKE_BINARY_DIR}/subprojects)

# 超级构建安装目录
set(STAGED_INSTALL_PREFIX ${CMAKE_BINARY_DIR}/stage)
message(STATUS "${PROJECT_NAME} staged install: ${STAGED_INSTALL_PREFIX}")

# 添加子项目message_external
# add_subdirectory(external/upstream)

# # 将我们自己的代码作为外部项目执行超级构建
# # 依赖于message_external
# # 注意我们的代码会依赖消息库message,而message_external子项目就是为了处理message依赖的
# # 它首先会查找系统上是否安装，没有则下载然后执行超级构建，并安装且提供Find<name>.cmake查找模块
# # 所以我们的代码里无论如何都可以直接使用find_package命令
# include(ExternalProject)
# ExternalProject_Add(${PROJECT_NAME}_core
#   DEPENDS
#     message_external
#   SOURCE_DIR
#     ${CMAKE_CURRENT_SOURCE_DIR}/src
#   CMAKE_ARGS
#     -DCMAKE_INSTALL_PREFIX=${STAGED_INSTALL_PREFIX}
#     -DCMAKE_BUILD_TYPE=${CMAKE_BUILD_TYPE}
#     -DCMAKE_CXX_COMPILER=${CMAKE_CXX_COMPILER}
#     -DCMAKE_CXX_STANDARD=${CMAKE_CXX_STANDARD}
#     -DCMAKE_CXX_EXTENSIONS=${CMAKE_CXX_EXTENSIONS}
#     -DCMAKE_CXX_STANDARD_REQUIRED=${CMAKE_CXX_STANDARD_REQUIRED}
#     # 传递message_DIR用于查找message库
#     # 这个值是在message_external中设置的  
#     -Dmessage_DIR=${message_DIR}
#   CMAKE_CACHE_ARGS
#     -DCMAKE_CXX_FLAGS:STRING=${CMAKE_CXX_FLAGS}
#     -DCMAKE_PREFIX_PATH:PATH=${CMAKE_PREFIX_PATH}
#   BUILD_ALWAYS
#     1
#   )

# 换一种写法，不使用超级构建, 使用execute_process下载/编译/安装，然后使用find_package
# 最好的方案是每个比较独立的工程，包括第三方工程，我们都使用超级构建，但是超级构建现在有这样一个问题，
# 需要我们将-D参数传递，但是cmake命令中-D参数可能是变化的，那这些参数就难以全部传递，当然也可以通过配置到文件中进行读取来实现, 但会麻烦
# 所以我们希望自己的工程不使用超级构建，而第三方工程使用超级构建，然而这又会出现依赖问题，一个超级构建可以依赖另一个超级构建，
# 但是一个超级构建似乎无法与非超级构建中的库形成依赖，因为超级构建发生在buid时,于是我们做了下面的工作，都不使用超级构建，但这并不是最优解
# 超级构建还是很好的，如果解决了那些参数传递的问题

# 这种方式没有使用超级构建，而是直接cmake --build了原工程
# find_package(Git REQUIRED)
# execute_process(
#     COMMAND ${GIT_EXECUTABLE} clone https://github.com/dev-cafe/message.git
#     RESULT_VARIABLE _cmd_result
#     OUTPUT_VARIABLE _git_msg
#     WORKING_DIRECTORY
#         ${CMAKE_BINARY_DIR}
#    ) 
# message(STATUS "Git result: ${_cmd_result}")
# message(STATUS "Git message: ${_git_msg}")
#
# execute_process(
#     COMMAND
#         ${CMAKE_COMMAND} -H${CMAKE_BINARY_DIR}/message
#                          -B${CMAKE_BINARY_DIR}/cmake_ign_msg_build
#                          -G${CMAKE_GENERATOR}
#                          -DCMAKE_BUILD_TYPE=${CMAKE_BUILD_TYPE}
#                          -DCMAKE_INSTALL_PREFIX=${CMAKE_INSTALL_PREFIX}
#    ) 
# execute_process(
#     COMMAND
#         ${CMAKE_COMMAND} --build ${CMAKE_BINARY_DIR}/cmake_ign_msg_build
#                          --config $<CONFIGURATION>
#    ) 
# execute_process(
#     COMMAND
#         ${CMAKE_COMMAND} --build ${CMAKE_BINARY_DIR}/cmake_ign_msg_build
#                          --target install
#    ) 

# 这种方式间接使用了超级构建，虽然超级构建是在build时生效，但是我们execute_process却可以在配置时执行，
# 我们在超级构建的外层套了一个壳-cmake工程（有projefct语句），并在配置时构建编译这个壳，使得超级构建在配置时就开始执行
# 虽然很妙，但是还是不太完美
execute_process(
    COMMAND
        ${CMAKE_COMMAND} -H${CMAKE_SOURCE_DIR}/external/upstream
                         -B${CMAKE_BINARY_DIR}
                         -G${CMAKE_GENERATOR}
                         -DCMAKE_BUILD_TYPE=${CMAKE_BUILD_TYPE}
                         -DSTAGED_INSTALL_PREFIX=${STAGED_INSTALL_PREFIX}
   ) 
execute_process(
    COMMAND
        ${CMAKE_COMMAND} --build ${CMAKE_BINARY_DIR}
                         --config $<CONFIGURATION>
   ) 
execute_process(
    COMMAND
        ${CMAKE_COMMAND} --build ${CMAKE_BINARY_DIR}
                         --target install
   ) 

message(STATUS "message_DIR: ${message_DIR}")
set(message_DIR "${STAGED_INSTALL_PREFIX}/share/cmake/message")
add_subdirectory(src)

enable_testing()

# 添加测试, 运行build的文件
add_test(
  NAME
    check_use_message
  COMMAND
    ${CMAKE_BINARY_DIR}/${INSTALL_BINDIR}/use_message --success
  )

# this one mimicks using DESTDIR
# 声明安装规则。因为所需要的东西都已经安装在暂存区域中，我们只要将暂存区域的内容复制到安装目录即可
# 将超级构建安装在STAGED_INSTALL_PREFIX中的文件复制一份安装在
# 用户通过cmake指定: cmake -DCMAKE_INSTALL_PREFIX的目录中

# # 下面是书中的解释，上面是自己的理解，有点小错误
# # 注意使用.而不是绝对路径${CMAKE_INSTALL_PREFIX}，这样CPack工具就可以正确理解该规则。CPack的用法将在第11章中介绍。
install(
  DIRECTORY
    ${STAGED_INSTALL_PREFIX}/
  DESTINATION
    .
  USE_SOURCE_PERMISSIONS
  )

# 添加测试, 用户指定的安装目录
add_test(
  NAME
    check_use_message_2
  COMMAND
    ${CMAKE_INSTALL_PREFIX}/${INSTALL_BINDIR}/use_message
  )

# # Print RPATH of installed executable and run it
# # 使用SCRIPT参数声明一个附加的安装规则。CMake脚本的install_hook.cmake将被执行，这个脚本将打印已安装的可执行文件的RPATH，并运行它。
# if(UNIX)
#   # 这里很有意思，模板中@PRINT_SCRIPT@被替换成这里的python路径，
#   # 即在生成的install_hook.cmake中通过execute_process运行了python脚本
#   # 然后又从最后安装的目录中运行了use_message
#   set(PRINT_SCRIPT "${CMAKE_CURRENT_LIST_DIR}/cmake/print_rpath.py")
#   configure_file(cmake/install_hook.cmake.in install_hook.cmake @ONLY)
#   install(
#     SCRIPT
#       ${CMAKE_CURRENT_BINARY_DIR}/install_hook.cmake
#     )
# endif()

include(CMakeCPack.cmake)
