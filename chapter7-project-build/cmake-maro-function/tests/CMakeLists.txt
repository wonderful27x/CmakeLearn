add_executable(cpp_test test.cpp)
target_link_libraries(cpp_test sum_integers)

# 宏，宏类似于函数但是区别于函数
# 宏可用直接修改调用者的变量，如这里让num_macro_calls加1，
# 但是函数若要修改需要显示指定PARENT_SCOPE属性，否则不生效:
# set(variable_visible_outside "some value" PARENT_SCOPE)
# 将CMake宏想象成类似函数是很有用的，这些函数被直接替换到它们被调用的地方(在C语言中内联)。将CMake函数想象成黑盒函数很有必要。黑盒中，除非显式地将其定义为PARENT_SCOPE，否则不会返回任何内容。CMake中的函数没有返回值。

# add_catch_test 是名字
# _name _cost 是参数列表，使用下划线表明只在宏中使用
# ${ARGC} 是参数数量, ${ARGV}是参数列表，也可以用${ARGV0},${ARGV1}来处理参数
# 注意，这里只有两个参数，但是如果调用时传递多个参数也是可用的，用${ARGN}可以捕获额外参数
macro(add_catch_test _name _cost)
  math(EXPR num_macro_calls "${num_macro_calls} + 1")
  message(STATUS "add_catch_test called with ${ARGC} arguments: ${ARGV}")

  set(_argn "${ARGN}")
  if(_argn)
    message(STATUS "oops - macro received argument(s) we did not expect: ${ARGN}")
  endif()

  add_test(
    NAME
      ${_name}
    COMMAND
      $<TARGET_FILE:cpp_test>
      [${_name}] --success --out
      ${PROJECT_BINARY_DIR}/tests/${_name}.log --durations yes
    WORKING_DIRECTORY
      ${CMAKE_CURRENT_BINARY_DIR}
    )

  # 设置cost属性指定时长提高测试效率
  set_tests_properties(
    ${_name}
    PROPERTIES
      COST ${_cost}
    )
endmacro()

set(num_macro_calls 0)

add_catch_test(short 1.5)
add_catch_test(long 2.5 extra_argument)

message(STATUS "in total there were ${num_macro_calls} calls to add_catch_test")
