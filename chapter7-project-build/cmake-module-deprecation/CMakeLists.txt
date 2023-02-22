cmake_minimum_required(VERSION 3.5 FATAL_ERROR)

project(recipe-06 LANGUAGES NONE)

# 废弃宏或函数，通常因为版本升级

# 旧的将要废弃的宏
macro(custom_include_guard)
  if(NOT DEFINED included_modules)
    set(included_modules)
  endif()

  if ("${CMAKE_CURRENT_LIST_FILE}" IN_LIST included_modules)
    message(WARNING "module ${CMAKE_CURRENT_LIST_FILE} processed more than once")
  endif()

  list(APPEND included_modules ${CMAKE_CURRENT_LIST_FILE})
endmacro()

# 声明一个函数用于弃用变量，如果这个变量是READ_ACCESS,就打印DEPRECATION信息
function(deprecate_variable _variable _access)
  if(_access STREQUAL "READ_ACCESS")
    message(DEPRECATION "variable ${_variable} is deprecated")
  endif()
endfunction()

if (CMAKE_VERSION VERSION_GREATER "3.9")
  # 弃用函数或宏，相当于重新定义他并打印DEPRECATION信息
  # deprecate custom_include_guard
  macro(custom_include_guard)
    message(DEPRECATION "custom_include_guard is deprecated - use built-in include_guard instead")
    _custom_include_guard(${ARGV})
  endmacro()

  # 将函数添加到要废弃的变量
  # deprecate variable included_modules
  variable_watch(included_modules deprecate_variable)
endif()

include(cmake/custom.cmake)

message(STATUS "list of all included modules: ${included_modules}")
