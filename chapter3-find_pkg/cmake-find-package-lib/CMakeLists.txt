# set minimum cmake version
cmake_minimum_required(VERSION 3.5 FATAL_ERROR)

# project name and language
project(recipe-02 LANGUAGES C)

set(CMAKE_C_STANDARD 99)
set(CMAKE_C_EXTENSIONS OFF)
set(CMAKE_C_STANDARD_REQUIRED ON)

# 查找python解释器
find_package(PythonInterp REQUIRED)
# 通过上面查找设置的变量（版本号）查找对应的头文件和库文件
find_package(PythonLibs ${PYTHON_VERSION_MAJOR}.${PYTHON_VERSION_MINOR} EXACT REQUIRED)
# EXACT限制cmake检测特定版本
# 可以使用PYTHON_VERSION_STRING设置接近的版本
# find_package(PythonLibs ${PYTHON_VERSION_STRING} EXACT REQUIRED)

# 当不在系统标准位置查找是使用-D PYTHON_EXECUTABLE、-D PYTHON_LIBRARY和-D PYTHON_INCLUDE_DIR传递给CMake CLI
# also see find_package(Python COMPONENTS Interpreter Development REQUIRED) in cmake 3.12 解决不完全匹配版本的问题

add_executable(hello-embedded-python hello-embedded-python.c)

target_include_directories(hello-embedded-python
  PRIVATE
    ${PYTHON_INCLUDE_DIRS}
  )

target_link_libraries(hello-embedded-python
  PRIVATE
    ${PYTHON_LIBRARIES}
  )
