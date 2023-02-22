cmake_minimum_required(VERSION 3.5 FATAL_ERROR)

project(recipe-05 LANGUAGES NONE)

# (re)defines include_guard
# 重新定义了include_guard, cmake有内置的include_guard
include(cmake/include_guard.cmake)

# cmake模块中不应该调用函数或宏，因为多次include导致多次调用
# custom.cmake中调用了include_guard宏，作为例子，我们对include_guard
# 做了保护来解决这种问题
# this is some custom module
include(cmake/custom.cmake)

# we simulate that we accidentally include the module a second time
include(cmake/custom.cmake)
