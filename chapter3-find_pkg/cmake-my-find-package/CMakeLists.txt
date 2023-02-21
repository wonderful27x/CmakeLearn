cmake_minimum_required(VERSION 3.5 FATAL_ERROR)

project(cmake-my-find-package LANGUAGES C)

set(CMAKE_C_STANDARD 99)
set(CMAKE_C_EXTENSIONS OFF)
set(CMAKE_C_STANDARD_REQUIRED ON)

# 设置cmake查找模块的路径列表，当前例子将.cmake放在CMakeLists.txt同级目录，所有这样设置
list(APPEND CMAKE_MODULE_PATH ${CMAKE_CURRENT_SOURCE_DIR})

# find就是为了查找模块的位置，如头文件，库文件，可执行文件等
# 然后将这些文件的位置信息、版本信息、编译选项、链接库的名称等信息保存到变量中供后面使用
# 注意这个FindZeroMQ.cmake是我们自己写的
find_package(ZeroMQ REQUIRED)

add_executable(hwserver hwserver.c)

# 下面这些变量信息就是通过find_package查找后赋值的
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
