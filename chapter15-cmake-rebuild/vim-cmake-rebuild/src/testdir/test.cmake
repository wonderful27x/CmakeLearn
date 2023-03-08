# 测试脚本
# 测试函数
# src/testdir/Makefile的目标表明，Vim代码运行测试多步测试：
# Vim脚本可执行测试流程，产生一个输出文件
# 输出文件是与参考文件进行比，,如果这些文件相同，测试成功
# 删除临时文件
function(execute_test _vim_executable _working_dir _test_script)
  # generates test.out
  execute_process(
    COMMAND ${_vim_executable} -f -u unix.vim -U NONE --noplugin --not-a-term -s dotest.in ${_test_script}.in
    WORKING_DIRECTORY ${_working_dir}
    )

  # compares test*.ok and test.out
  execute_process(
    COMMAND ${CMAKE_COMMAND} -E compare_files ${_test_script}.ok test.out
    WORKING_DIRECTORY ${_working_dir}
    RESULT_VARIABLE files_differ
    OUTPUT_QUIET
    ERROR_QUIET
    )

  # removes leftovers
  file(REMOVE ${_working_dir}/Xdotest)

  # we let the test fail if the files differ
  if(files_differ)
    message(SEND_ERROR "test ${_test_script} failed")
  endif()
endfunction()

# 调用测试函数
# 在.cmake中调用函数不太好吧，但是外界并不会include，所以好像也没问题
# 我们必须确保${VIM_EXECUTABLE}、${WORKING_DIR}和${TEST_SCRIPT}是在外部定
execute_test(${VIM_EXECUTABLE} ${WORKING_DIR} ${TEST_SCRIPT})

