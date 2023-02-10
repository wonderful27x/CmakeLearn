# 一个比较好的.cmake规范介绍
# see https://www.jianshu.com/p/f983a90bcf91

# FindZeroMQ.cmake

#[==========[.rst:
FindZeroMQ
----------

对这个文件的描述：查找ZeroMQ库

Imported Targets
^^^^^^^^^^^^^^^^

如果提供导出可执行目标，可以在下面进行定义：
``ZeroMQ::ZeroMQ``
    导出ZeroMQ::ZeroMQ可执行目标，这是未提供只是一个示意

Result Variables
^^^^^^^^^^^^^^^^

可以在下面定义一些普通变量：

``ZeroMQ_ROOT``
    库查找根目录
``ZeroMQ_FOUND``
    如果找到ZeroMQ库，该变量值为True
``ZeroMQ_VERSION``
    ZeroMQ库版本号
``ZeroMQ_INCLUDE_DIRS``
    使用ZeroMQ库需要包含的头文件
``ZeroMQ_LIBRARIES``
    使用ZeroMQ库需要用到的库文件

Cache Variables
^^^^^^^^^^^^^^^
    
可以在下面定义一些缓存变量：

``ZeroMQ_INCLUDE_DIR``
    包含ZeroMQ.h头文件的目录
``ZeroMQ_LIBRARY``
    ZeroMQ库所在的目录 
]==========]

# 如果没有设置ZeroMQ_ROOT就从环境变量中或改值
# $ENV{<name>}可以获取名叫name的环境变量的值
if(NOT ZeroMQ_ROOT)
    set(ZeroMQ_ROOT "$ENV{ZeroMQ_ROOT}")
    message(STATUS "ZeroMQ_ROOT not set, use env ZeroMQ_ROOT: ${ZeroMQ_ROOT}")
endif()

# 如都没有则在系统上查找include/zmq.h头文件的位置，然后设置为_ZeroMQ_ROOT,注意有下划线
# 否则如果ZeroMQ_ROOT是有值的就直接保存到_ZeroMQ_ROOT
# find_是cmake中的家族命令用于搜索所需包的必要组件，即头文件、库、可执行程序等等
# 用find_path查找头文件的完整路径，find_library查找库, CMake还提供find_file、find_program和find_package。这些命令的签名如下:
# find_path(<VAR> NAMES name PATHS paths)
# 如果搜索成功，<VAR>将保存搜索结果；如果搜索失败，则会设置为<VAR>-NOTFOUND 。NAMES和PATHS分别是CMake应该查找的文件的名称和搜索应该指向的路径。
if(NOT ZeroMQ_ROOT)
    find_path(_ZeroMQ_ROOT NAMES include/zmq.h)
    message(STATUS "ZeroMQ_ROOT not set and env ZeroMQ_ROOT not set, find include/zmq.h -> ${_ZeroMQ_ROOT}")
else()
    set(_ZeroMQ_ROOT "${ZeroMQ_ROOT}")
endif()

message(STATUS "The final ZeroMQ_ROOT is: ${_ZeroMQ_ROOT}")

# 通过_ZeroMQ_ROOT查找头文件位置, 并设置头文件位置变量
find_path(ZeroMQ_INCLUDE_DIRS NAMES zmq.h HINTS ${_ZeroMQ_ROOT}/include)

if(ZeroMQ_INCLUDE_DIRS)
    # 如果找到了，利用正则表达式从头文件中获取版本信息，并设置相应变量
    set(_ZeroMQ_H ${ZeroMQ_INCLUDE_DIRS}/zmq.h)

    function(_zmqver_EXTRACT _ZeroMQ_VER_COMPONENT _ZeroMQ_VER_OUTPUT)
    set(CMAKE_MATCH_1 "0")
    set(_ZeroMQ_expr "^[ \\t]*#define[ \\t]+${_ZeroMQ_VER_COMPONENT}[ \\t]+([0-9]+)$")
    file(STRINGS "${_ZeroMQ_H}" _ZeroMQ_ver REGEX "${_ZeroMQ_expr}")
    string(REGEX MATCH "${_ZeroMQ_expr}" ZeroMQ_ver "${_ZeroMQ_ver}")
    set(${_ZeroMQ_VER_OUTPUT} "${CMAKE_MATCH_1}" PARENT_SCOPE)
    endfunction()

    _zmqver_EXTRACT("ZMQ_VERSION_MAJOR" ZeroMQ_VERSION_MAJOR)
    _zmqver_EXTRACT("ZMQ_VERSION_MINOR" ZeroMQ_VERSION_MINOR)
    _zmqver_EXTRACT("ZMQ_VERSION_PATCH" ZeroMQ_VERSION_PATCH)

    # We should provide version to find_package_handle_standard_args in the same format as it was requested,
    # otherwise it can't check whether version matches exactly.
    if(ZeroMQ_FIND_VERSION_COUNT GREATER 2)
        set(ZeroMQ_VERSION "${ZeroMQ_VERSION_MAJOR}.${ZeroMQ_VERSION_MINOR}.${ZeroMQ_VERSION_PATCH}")
    else()
    # User has requested ZeroMQ version without patch part => user is not interested in specific patch =>
    # any patch should be an exact match.
        set(ZeroMQ_VERSION "${ZeroMQ_VERSION_MAJOR}.${ZeroMQ_VERSION_MINOR}")
    endif()

    # 通过find_library查找库
    if(NOT ${CMAKE_C_PLATFORM_ID} STREQUAL "Windows")
        find_library(ZeroMQ_LIBRARIES
            NAMES
                zmq
            HINTS
                ${_ZeroMQ_ROOT}/lib
                ${_ZeroMQ_ROOT}/lib/x86_64-linux-gnu
            )
    else()
        find_library(ZeroMQ_LIBRARIES
            NAMES
              libzmq
              "libzmq-mt-${ZeroMQ_VERSION_MAJOR}_${ZeroMQ_VERSION_MINOR}_${ZeroMQ_VERSION_PATCH}"
              "libzmq-${CMAKE_VS_PLATFORM_TOOLSET}-mt-${ZeroMQ_VERSION_MAJOR}_${ZeroMQ_VERSION_MINOR}_${ZeroMQ_VERSION_PATCH}"
              libzmq_d
              "libzmq-mt-gd-${ZeroMQ_VERSION_MAJOR}_${ZeroMQ_VERSION_MINOR}_${ZeroMQ_VERSION_PATCH}"
              "libzmq-${CMAKE_VS_PLATFORM_TOOLSET}-mt-gd-${ZeroMQ_VERSION_MAJOR}_${ZeroMQ_VERSION_MINOR}_${ZeroMQ_VERSION_PATCH}"
            HINTS
              ${_ZeroMQ_ROOT}/lib
            )
    endif()
endif()

include(FindPackageHandleStandardArgs)

# 调用此函数处理find_package命令的REQUIRED、QUIET和版本参数，并设置ZeroMQ_FOUND变量
# 如果所有变量都设置了ZeroMQ_FOUND置为True
find_package_handle_standard_args(ZeroMQ
    FOUND_VAR
        ZeroMQ_FOUND
    REQUIRED_VARS
        ZeroMQ_INCLUDE_DIRS
        ZeroMQ_LIBRARIES
        # ZeroMQ_INCLUDE_DIR
        # ZeroMQ_LIBRARY
    VERSION_VAR
       ZeroMQ_VERSION 
    )
