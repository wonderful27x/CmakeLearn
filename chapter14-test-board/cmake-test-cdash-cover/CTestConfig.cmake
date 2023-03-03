# 设置cdash的服务器信息
# CTest运行测试并在XML文件中记录结果。然后，将这些XML文件发送到CDash服务器，在那里可以浏览和分析它们。
# 很奇怪，这个文件是在哪里调用的，难道因为他和主CMakeLists.txt在同一目录？
message(STATUS "run CTestConfig.cmake...")
set(CTEST_DROP_METHOD "http")
set(CTEST_DROP_SITE "my.cdash.org")
set(CTEST_DROP_LOCATION "/submit.php?project=cmake-cookbook")
set(CTEST_DROP_SITE_CDASH TRUE)
