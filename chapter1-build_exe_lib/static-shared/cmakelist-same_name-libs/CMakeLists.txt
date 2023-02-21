# cmake 最低版本号
cmake_minimum_required(VERSION 3.5 FATAL_ERROR)

# 项目名称,使用语言
project(cmake-libs-object LANGUAGES CXX)

# 使用OBJECT可以同时编译静态库和动态库
add_library(message-objs
    OBJECT
        ../message.cpp
        ../message.h
    )

# 设置编译的目标文件与生成位置无关
set_target_properties(message-objs
    PROPERTIES
        POSITION_INDEPENDENT_CODE 1
    )

# 动态库
add_library(message-shared
    SHARED
        $<TARGET_OBJECTS:message-objs>
    )

# 设置动态库名字,这样可以编译的动态库和静态库同名
set_target_properties(message-shared
    PROPERTIES
        OUTPUT_NAME "message"
    )

add_library(message-static
    STATIC
        $<TARGET_OBJECTS:message-objs>
    )

set_target_properties(message-static
    PROPERTIES
        OUTPUT_NAME "message"
    )

add_executable(hello-cmake ../hello-cmake.cpp)

target_link_libraries(hello-cmake message-shared)



