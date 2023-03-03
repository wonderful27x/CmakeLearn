# CMake generated Testfile for 
# Source directory: /mnt/e/wonderful/LEARN/cmake/cmake-code/chapter14-test-board/cmake-test-dash-asan/tests
# Build directory: /mnt/e/wonderful/LEARN/cmake/cmake-code/chapter14-test-board/cmake-test-dash-asan/build_ctest/tests
# 
# This file includes the relevant testing commands required for 
# testing this directory and lists subdirectories to be tested as well.
add_test(leaky "/mnt/e/wonderful/LEARN/cmake/cmake-code/chapter14-test-board/cmake-test-dash-asan/build_ctest/tests/leaky")
set_tests_properties(leaky PROPERTIES  _BACKTRACE_TRIPLES "/mnt/e/wonderful/LEARN/cmake/cmake-code/chapter14-test-board/cmake-test-dash-asan/tests/CMakeLists.txt;6;add_test;/mnt/e/wonderful/LEARN/cmake/cmake-code/chapter14-test-board/cmake-test-dash-asan/tests/CMakeLists.txt;0;")
add_test(use_after_free "/mnt/e/wonderful/LEARN/cmake/cmake-code/chapter14-test-board/cmake-test-dash-asan/build_ctest/tests/use_after_free")
set_tests_properties(use_after_free PROPERTIES  _BACKTRACE_TRIPLES "/mnt/e/wonderful/LEARN/cmake/cmake-code/chapter14-test-board/cmake-test-dash-asan/tests/CMakeLists.txt;6;add_test;/mnt/e/wonderful/LEARN/cmake/cmake-code/chapter14-test-board/cmake-test-dash-asan/tests/CMakeLists.txt;0;")
