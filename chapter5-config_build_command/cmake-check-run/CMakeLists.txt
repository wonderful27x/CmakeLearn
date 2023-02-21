cmake_minimum_required(VERSION 3.6 FATAL_ERROR)

project(recipe-08 LANGUAGES CXX C)

# 检测代码片段是否可用运行

set(CMAKE_CXX_STANDARD 11)
set(CMAKE_CXX_EXTENSIONS OFF)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

# 使用PkgConfig查找uuid库
find_package(PkgConfig REQUIRED QUIET)
pkg_search_module(UUID REQUIRED uuid IMPORTED_TARGET)
if(TARGET PkgConfig::UUID)
  message(STATUS "Found libuuid")
endif()

include(CheckCSourceRuns)

set(_test_uuid
  "
#include <uuid/uuid.h>

int main(int argc, char * argv[]) {
  uuid_t uuid;

  uuid_generate(uuid);

  return 0;
}
  ")

# pkg_search_module已经生成了imported库UUID,其中设置了很多标志
# check_c_source_runs 是 try_run的封装，就像check_<lang>_source_compiles是try_compile的包装器一样
# 对于check_<lang>_source_compiles, check_<lang>_source_runs的执行可以通过以下变量来进行:
# CMAKE_REQUIRED_FLAGS：设置编译器标示。
# CMAKE_REQUIRED_DEFINITIONS：设置预编译宏。
# CMAKE_REQUIRED_INCLUDES：设置包含目录列表。
# CMAKE_REQUIRED_LIBRARIES：设置可执行目标需要连接的库列表。
# NOTE:pkg_search_module只能定义导入目标(CMake 3.6),但目前的示例可以使工作，3.6之前版本的CMake可以通过手动设置所需的包括目录和库check_c_source_runs如下:set(CMAKE_REQUIRED_INCLUDES $ {UUID_INCLUDE_DIRS})和set(CMAKE_REQUIRED_LIBRARIES $ {UUID_LIBRARIES})。
set(CMAKE_REQUIRED_LIBRARIES PkgConfig::UUID)
check_c_source_runs("${_test_uuid}" _runs)
unset(CMAKE_REQUIRED_LIBRARIES)

if(NOT _runs)
  message(FATAL_ERROR "Cannot run a simple C executable using libuuid!")
endif()

# 测试通过后进行后续任务

add_executable(use-uuid use-uuid.cpp)

target_link_libraries(use-uuid
  PUBLIC
    PkgConfig::UUID
  )
