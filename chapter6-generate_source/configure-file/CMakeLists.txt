cmake_minimum_required(VERSION 3.10 FATAL_ERROR)

project(recipe-01 LANGUAGES Fortran C)

# 代码生成在配置时发生

# Get username
# 通过命令查询用户名
execute_process(
  COMMAND
    whoami
  TIMEOUT
    1
  OUTPUT_VARIABLE
    _user_name
  OUTPUT_STRIP_TRAILING_WHITESPACE
  )

# host name information
# 通过cmake_host_system_information查询系统信息
cmake_host_system_information(RESULT _host_name QUERY HOSTNAME)
cmake_host_system_information(RESULT _fqdn QUERY FQDN)

# processor information
cmake_host_system_information(RESULT _processor_name QUERY PROCESSOR_NAME)
cmake_host_system_information(RESULT _processor_description QUERY PROCESSOR_DESCRIPTION)

# os information
cmake_host_system_information(RESULT _os_name QUERY OS_NAME)
cmake_host_system_information(RESULT _os_release QUERY OS_RELEASE)
cmake_host_system_information(RESULT _os_version QUERY OS_VERSION)
cmake_host_system_information(RESULT _os_platform QUERY OS_PLATFORM)

string(TIMESTAMP _configuration_time "%Y-%m-%d %H:%M:%S [UTC]" UTC)

# 调用configure_file生成源码
# print_info.c.in是模板，print_info.c 是输出文件
# @ONLY 只有@xxx@之间的内容将被替换
# 默认输入目录是CMAKE_CURRENT_SOURCE_DIR, 输出目录是CMAKE_CURRENT_BINARY_DIR
# 注意，用值替换占位符时，CMake中的变量名应该与将要配置的文件中使用的变量名完全相同，并放在@之间
configure_file(print_info.c.in print_info.c @ONLY)

add_executable(example "")

target_sources(example
  PRIVATE
    example.f90
    ${CMAKE_CURRENT_BINARY_DIR}/print_info.c
  )
