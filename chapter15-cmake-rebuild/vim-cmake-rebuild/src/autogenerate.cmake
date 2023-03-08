# 此脚本用于定义自动生成文件的函数

# include一些需要用到的函数
include(CheckTypeSize)
include(CheckFunctionExists)
include(CheckIncludeFiles)
include(CheckLibraryExists)
include(CheckCSourceCompiles)

# 用于生成config.h头文件
# 根据系统配置预处理宏定义
# 模板为config.h.cmake.in
# 这个页面是一个很好的平台检查示例: https://gitlab.kitware.com/cmake/community/wikis/doc/tutorials/How-To-Write-Platform-Checks
function(generate_config_h)
    set(TERMINFO 1)
    set(UNIX 1)

    set(TIME_WITH_SYS_TIME 1)
    set(RETSIGTYPE void)
    set(SIGRETURN return)

    find_package(X11)
    set(HAVE_X11 ${X11_FOUND})

    check_type_size("int" VIM_SIZEOF_INT)
    check_type_size("long" VIM_SIZEOF_LONG)
    check_type_size("time_t" SIZEOF_TIME_T)
    check_type_size("off_t" SIZEOF_OFF_T)

    # function check
    foreach(
        _function IN ITEMS
        fchdir fchown fchmod fsync getcwd getpseudotty
        getpwent getpwnam getpwuid getrlimit gettimeofday getwd lstat
        memset mkdtemp nanosleep opendir putenv qsort readlink select setenv
        getpgid setpgid setsid sigaltstack sigstack sigset sigsetjmp sigaction
        sigprocmask sigvec strcasecmp strerror strftime stricmp strncasecmp
        strnicmp strpbrk strtol towlower towupper iswupper
        usleep utime utimes mblen ftruncate
        )
        
        string(TOUPPER "${_function}" _function_uppercase)
        check_function_exists(${_function} HAVE_${_function_uppercase})
    endforeach()

    # library check
    check_library_exists(tinfo tgetent "" HAVE_TGETENT)
    if(NOT HAVE_TGETENT)
        message(FATAL_ERROR "Could not find the tgetent() function. You need to install a terminal library; for example ncurses.")
    endif()

    # include check
    foreach(
        _header IN ITEMS
        setjmp.h dirent.h
        stdint.h stdlib.h string.h
        sys/select.h sys/utsname.h termcap.h fcntl.h
        sgtty.h sys/ioctl.h sys/time.h sys/types.h
        termio.h iconv.h inttypes.h langinfo.h math.h
        unistd.h stropts.h errno.h sys/resource.h
        sys/systeminfo.h locale.h sys/stream.h termios.h
        libc.h sys/statfs.h poll.h sys/poll.h pwd.h
        utime.h sys/param.h libintl.h libgen.h
        util/debug.h util/msg18n.h frame.h sys/acl.h
        sys/access.h sys/sysinfo.h wchar.h wctype.h
        X11/Intrinsic.h
        )

        string(TOUPPER "${_header}" _header_uppercase)
        string(REPLACE "/" "_" _header_normalized "${_header_uppercase}")
        string(REPLACE "." "_" _header_normalized "${_header_normalized}")
        check_include_files(${_header} HAVE_${_header_normalized})
    endforeach()

    string(TOUPPER "${FEATURES}" _features_upper)
    set(FEAT_${_features_upper} 1) 

    set(FEAT_NETBEANS_INTG ${ENABLE_NETBEANS})
    set(FEAT_JOB_CHANNEL ${ENABLE_CHANNEL})
    set(FEAT_TERMINAL ${ENABLE_TERMINAL})

    # 将编译源文件，并将其链接到可执行文件中。如果这些操作成功, 变量HAVE_ST_BLKSIZE 设置为true
    check_c_source_compiles(
        "
        #include <sys/types.h>
        #include <sys/stat.h>
        int
        main ()
        {
                struct stat st;
                int n;

                stat(\"/\", &st);
                n = (int)st.st_blksize;
          ;
          return 0;
        }
        "
        HAVE_ST_BLKSIZE
        )

    # 生成config文件
    configure_file(
        ${CMAKE_CURRENT_LIST_DIR}/config.h.cmake.in
        ${CMAKE_CURRENT_BINARY_DIR}/auto/config.h
        @ONLY
        )
    message(STATUS "generate config.h -> ${CMAKE_CURRENT_BINARY_DIR}/auto/config.h")
endfunction()

# 根据编译器标志和路径配置文件
# 为简单省略链接标志
function(generate_pathdef_c)
    set(_default_vim_dir ${CMAKE_INSTALL_PREFIX})
    set(_default_vimruntime_dir ${_default_vim_dir})

    set(_all_cflags "${CMAKE_C_COMPILER} ${CMAKE_C_FLAGS}")
    if(CMAKE_BUILD_TYPE STREQUAL "Release")
        set(_all_cflags "${_all_cflags} ${CMAKE_C_FLAGS_RELEASE}")
    else()
        set(_all_cflags "${_all_cflags} ${CMAKE_C_FLAGS_RELEASE}")
    endif()

    # it would require a bit more work and execute commands at build time
    # to get the link line into the binary
    set(_all_lflags "undefined")

    # 通过环境变量获取用户名
    if(WIN32)
        set(_compiled_user $ENV{USERNAME})
    else()
        set(_compiled_user $ENV{USER})
    endif()

    # 查询运行cmake系统的系统信息HOSTNAME
    cmake_host_system_information(RESULT _compiled_sys QUERY HOSTNAME)

    configure_file(
        ${CMAKE_CURRENT_LIST_DIR}/pathdef.c.in
        ${CMAKE_CURRENT_BINARY_DIR}/auto/pathdef.c
        @ONLY
        )
endfunction()

# 配置时执行shell脚本
function(generate_osdef_h)
    find_program(BASH_EXECUTABLE bash)
    execute_process(
        COMMAND
            ${BASH_EXECUTABLE} osdef.sh ${CMAKE_CURRENT_BINARY_DIR}
        WORKING_DIRECTORY
            ${CMAKE_CURRENT_LIST_DIR}
        )
endfunction()
