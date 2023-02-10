# set minimum cmake version
cmake_minimum_required(VERSION 3.5 FATAL_ERROR)

# project name and language
project(recipe-03 LANGUAGES CXX)

include(CMakePrintHelpers)

set(CMAKE_CXX_STANDARD 11)
set(CMAKE_CXX_EXTENSIONS OFF)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

find_package(PythonInterp REQUIRED)
find_package(PythonLibs ${PYTHON_VERSION_MAJOR}.${PYTHON_VERSION_MINOR} EXACT REQUIRED)

# Find NumPy location
# 调用python查找NumPy库，并把路径保存
# execute_process通过子进程执行一个或多个命令，返回值保存到RESULT_VARIABLE, 标准输出和标准错误
# 保存到OUTPUT_VARIABLE和ERROR_VARIABLE
# 此例通过该命令确保NumPy可用
execute_process(
  COMMAND
    ${PYTHON_EXECUTABLE} "-c" "import re, numpy; print(re.compile('/__init__.py.*').sub('',numpy.__file__))"
  RESULT_VARIABLE _numpy_status
  OUTPUT_VARIABLE _numpy_location
  ERROR_QUIET
  OUTPUT_STRIP_TRAILING_WHITESPACE
  )
cmake_print_variables(_numpy_status _numpy_location)
# 使用cache是变量在后面可以使用
if(NOT _numpy_status)
  set(NumPy ${_numpy_location} CACHE STRING "Location of NumPy")
  message(STATUS "numpy location: ${_numpy_version}")
endif()

# Find NumPy version
# 查找NumPy的版本号，并保存
execute_process(
  COMMAND
    ${PYTHON_EXECUTABLE} "-c" "import numpy; print(numpy.__version__)"
  OUTPUT_VARIABLE _numpy_version
  ERROR_QUIET
  OUTPUT_STRIP_TRAILING_WHITESPACE
  )
cmake_print_variables(_numpy_version)

# find_package_handle_standard_args提供用于处理与查找相关程序和库的标准工具，
# 可以正确处理与版本相关的REQUIRED和EXACT选项
# 这和find_package(PythonLibs ${PYTHON_VERSION_MAJOR}.${PYTHON_VERSION_MINOR} EXACT REQUIRED)
# 应该是一样的功能
# 所有必需的变量都设置为有效的文件路径(NumPy)后，发送到模块(NumPy_FOUND)。它还将版本保存在可传递的版本变量(_numpy_version)中并打印:
# -- Found NumPy: /usr/lib/python3.6/site-packages/numpy (found version "1.14.3")
# 如果返回NumPy_FOUND为FALSE，则停止配置
include(FindPackageHandleStandardArgs)
find_package_handle_standard_args(NumPy
  FOUND_VAR NumPy_FOUND
  REQUIRED_VARS NumPy
  VERSION_VAR _numpy_version
  )

include(CMakePrintHelpers)
cmake_print_variables(FOUND_VAR NumPy_FOUND REQUIRED_VAR NumPy VERSION_VAR _numpy_version)

add_executable(pure-embedding "")

target_sources(pure-embedding
  PRIVATE
    Py${PYTHON_VERSION_MAJOR}-pure-embedding.cpp
  )

target_include_directories(pure-embedding
  PRIVATE
    ${PYTHON_INCLUDE_DIRS}
  )

target_link_libraries(pure-embedding
  PRIVATE
    ${PYTHON_LIBRARIES}
  )

# 将use_numpy.py复制到build目录?
add_custom_command(
  OUTPUT
    ${CMAKE_CURRENT_BINARY_DIR}/use_numpy.py
  COMMAND
    ${CMAKE_COMMAND} -E copy_if_different ${CMAKE_CURRENT_SOURCE_DIR}/use_numpy.py
                                          ${CMAKE_CURRENT_BINARY_DIR}/use_numpy.py
  DEPENDS
    ${CMAKE_CURRENT_SOURCE_DIR}/use_numpy.py
  )

# make sure building pure-embedding triggers the above
# custom command
target_sources(pure-embedding
  PRIVATE
    ${CMAKE_CURRENT_BINARY_DIR}/use_numpy.py
  )
