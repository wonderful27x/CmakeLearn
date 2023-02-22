# 命名参数函数即可以指定NAME test, COST 1.5这样的的参数
function(add_catch_test)
  # 选项，将解析为true或false当前没有使用
  set(options)
  # 单值参数
  set(oneValueArgs NAME COST)
  # 多值参数
  set(multiValueArgs LABELS DEPENDS REFERENCE_FILES)
  # 使用cmake_parse_arguments进行解析
  # 解析后参数值保存在
  # add_catch_test_NAME
  # add_catch_test_COST
  # add_catch_test_LABELS
  # add_catch_test_DEPENDS
  # add_catch_test_REFERENCE_FILES
  cmake_parse_arguments(add_catch_test
    "${options}"
    "${oneValueArgs}"
    "${multiValueArgs}"
    ${ARGN}
    )

  # 打印这些参数
  message(STATUS "defining a test ...")
  message(STATUS "    NAME: ${add_catch_test_NAME}")
  message(STATUS "    LABELS: ${add_catch_test_LABELS}")
  message(STATUS "    COST: ${add_catch_test_COST}")
  message(STATUS "    REFERENCE_FILES: ${add_catch_test_REFERENCE_FILES}")

  # 添加test
  add_test(
    NAME
      ${add_catch_test_NAME}
    COMMAND
      $<TARGET_FILE:cpp_test>
      [${add_catch_test_NAME}] --success --out
      ${PROJECT_BINARY_DIR}/tests/${add_catch_test_NAME}.log --durations yes
    WORKING_DIRECTORY
      ${CMAKE_CURRENT_BINARY_DIR}
    )

  # 将解析的参数设置到属性中
  set_tests_properties(${add_catch_test_NAME}
    PROPERTIES
      LABELS "${add_catch_test_LABELS}"
    )

  if(add_catch_test_COST)
    set_tests_properties(${add_catch_test_NAME}
      PROPERTIES
        COST ${add_catch_test_COST}
      )
  endif()

  if(add_catch_test_DEPENDS)
    set_tests_properties(${add_catch_test_NAME}
      PROPERTIES
        DEPENDS ${add_catch_test_DEPENDS}
      )
  endif()

  if(add_catch_test_REFERENCE_FILES)
    file(
      COPY
        ${add_catch_test_REFERENCE_FILES}
      DESTINATION
        ${CMAKE_CURRENT_BINARY_DIR}
      )
  endif()
endfunction()
