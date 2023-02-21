cmake_minimum_required(VERSION 3.5 FATAL_ERROR)

project(recipe-09 LANGUAGES C)

set(CMAKE_C_STANDARD 99)
set(CMAKE_C_EXTENSIONS OFF)
set(CMAKE_C_STANDARD_REQUIRED ON)

# 检测外部依赖的方法
#   1. 使用cmake自带的find-module, find_package(name REQUIRED)
#   2. 使用config, find_package(name REQUIRED CONFIG), <package>Config.cmake, <package>ConfigVersion.cmake和<package>Targets.cmake，这些文件由软件包供应商提供，并与软件包一起安装在标准位置的cmake文件夹下。
#   3. 以上两种都不行，使用pkg-config程序
#   4. 编写自己的find-package模块
# 这里讨论第三种pkg-config
# QUIET没找到目标才打印状态消息，否则不打印
find_package(PkgConfig REQUIRED QUIET)

# 使用pkg_search_module函数，以搜索任何附带包配置.pc文件的库或程序
# pkg_search_module, pkg_check_modules是cmake对pkg-config程序功能的封装
# ZeroMQ用于存储搜索结果，PkgConfig::ZeroMQ, 供后续使用
# libzeromq, libzmq, lib0mq为不同操作系统和管理器的名称，都要传递
pkg_search_module(
  ZeroMQ
  REQUIRED
    libzeromq libzmq lib0mq
  )

# 在cmake3.6上可以使用IMPORTED_TARGET选项直接设置include dir 和lib dir, 即省略了后面的设置:
# target_link_libraries和target_include_directories

if(ZeroMQ_FOUND)
  message(STATUS "Found ZeroMQ")
endif()

add_executable(hwserver hwserver.c)

target_include_directories(hwserver
  PRIVATE
    ${ZeroMQ_INCLUDE_DIRS}
  )
target_link_libraries(hwserver
  PRIVATE
    ${ZeroMQ_LIBRARIES}
  )

add_executable(hwclient hwclient.c)

target_include_directories(hwclient
  PRIVATE
    ${ZeroMQ_INCLUDE_DIRS}
  )
target_link_libraries(hwclient
  PRIVATE
    ${ZeroMQ_LIBRARIES}
  )
