# set minimum cmake version
cmake_minimum_required(VERSION 3.5 FATAL_ERROR)

# project name and language
project(cmake-find-package LANGUAGES NONE)

# detect python
# find_package(<name>)将会运行模块文件Find<name>.cmake
# 此模块包含cmake命令，用于设置一些有用的变量，可以在CMakeLists.txt中使用, 如
# 由此可知每个软件在Find<name>.cmake中实现了cmake统一的检测接口
# PYTHONINTERP_FOUND：是否找到解释器
# PYTHON_EXECUTABLE：Python解释器到可执行文件的路径
# PYTHON_VERSION_STRING：Python解释器的完整版本信息
# PYTHON_VERSION_MAJOR：Python解释器的主要版本号
# PYTHON_VERSION_MINOR ：Python解释器的次要版本号
# PYTHON_VERSION_PATCH：Python解释器的补丁版本号
# 如果软件包没有安装在系统标准位置，需要使用-D参数传递，如python: cmake -D PYTHON_EXECUTABLE=/custom/...
# 如果find找不到库可以运行如cmake --help-module FindPythonInterp查看文档
find_package(PythonInterp REQUIRED)
# 还可以强制版本大于或等于
# find_package(PythonInterp 2.7)

# Execute a tiny Python script
# 运行可执行文件
execute_process(
  COMMAND
    ${PYTHON_EXECUTABLE} "-c" "print('Hello, world!')"
  RESULT_VARIABLE _status
  OUTPUT_VARIABLE _hello_world
  ERROR_QUIET
  OUTPUT_STRIP_TRAILING_WHITESPACE
  )

message(STATUS "RESULT_VARIABLE is: ${_status}")
message(STATUS "OUTPUT_VARIABLE is: ${_hello_world}")

# compare the "manual" messages with the following handy helper
# 使用helper工具打印
include(CMakePrintHelpers)
cmake_print_variables(_status _hello_world)
