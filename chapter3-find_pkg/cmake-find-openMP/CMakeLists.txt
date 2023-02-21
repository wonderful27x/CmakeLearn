# set minimum cmake version
cmake_minimum_required(VERSION 3.9 FATAL_ERROR)

# project name and language
project(cmake-find-openMP LANGUAGES CXX)

set(CMAKE_CXX_STANDARD 11)
set(CMAKE_CXX_EXTENSIONS OFF)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

# 有些情况也可使用find_package(name REQUIRED CONFIG)
# 告诉cmake使用nameConfig.cmake nameConfigVersion.cmake和nameTargets.cmake而不是Findname.cmake模块
find_package(OpenMP REQUIRED)

add_executable(example example.cpp)

# 这里链接了一个IMPORTED类型的库，
# 其中已经设置了编译标志和包含目录
# IMPORTED使用项目外部的程序或库，
# see https://runebook.dev/zh/docs/cmake/guide/importing-exporting/index
# see https://cmake.org/cmake/help/latest/manual/cmake-buildsystem.7.html#imported-targets
target_link_libraries(example
  PUBLIC
    OpenMP::OpenMP_CXX
  )

include(CMakePrintHelpers)
cmake_print_variables(
    TARGETS
		OpenMP::OpenMP_CXX
	PROPERTIES
		INTERFACE_COMPILE_OPTIONS
		INTERFACE_INCLUDE_DIRECTORIES
		INTERFACE_LINK_LIBRARIES
	)

# 如果cmake低于3.9需要做更多工作
# target_compile_options(example
#     PUBLIC
#         ${OpenMP_CXX_FLAGS}
#     )

# set_target_properties(example
#     PROPERTIES
#         LINK_FLAGS ${OpenMP_CXX_FLAGS}
#     )

# CMake将在预定义的位置层次结构中查找配置模块。首先是CMAKE_PREFIX_PATH， <package>_DIR是接下来的搜索路径, 如：
# 通过将Eigen3的安装前缀传递给CMAKE_PREFIX_PATH:
# cmake -D CMAKE_PREFIX_PATH=<installation-prefix> ..
# 通过传递配置文件的位置作为Eigen3_DIR:
# cmake -D Eigen3_DIR=<installation-prefix>/share/eigen3/cmake/
