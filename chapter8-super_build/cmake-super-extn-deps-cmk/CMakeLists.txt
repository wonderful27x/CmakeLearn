cmake_minimum_required(VERSION 3.5 FATAL_ERROR)

project(recipe-03 LANGUAGES C)

set(CMAKE_C_STANDARD 99)
set(CMAKE_C_EXTENSIONS OFF)
set(CMAKE_C_STANDARD_REQUIRED ON)

# 将跳过对FFTW库的检测，并始终执行超级构建
set(CMAKE_DISABLE_FIND_PACKAGE_FFTW3 ON)

# 设置构建目录和安装目录变量
set_property(DIRECTORY PROPERTY EP_BASE ${CMAKE_BINARY_DIR}/subprojects)

set(STAGED_INSTALL_PREFIX ${CMAKE_BINARY_DIR}/stage)
message(STATUS "${PROJECT_NAME} staged install: ${STAGED_INSTALL_PREFIX}")

# 添加子项目-超级构建外部项目fftw3_external
# 这个外部项目使用cmake进行构建
add_subdirectory(external/upstream)

include(ExternalProject)

ExternalProject_Add(${PROJECT_NAME}_core
  DEPENDS
    fftw3_external
  # 超级构建我们自己的代码，代码将调用fftw3库
  SOURCE_DIR
    ${CMAKE_CURRENT_LIST_DIR}/src
  CMAKE_ARGS
    # FFTW3_DIR 将在fftw3_external超级构建最后设置
    # 以告诉CMake FFTW3Config.cmake文件的位置,因为我们自己的代码中使用了find_package(xxx CONFIG )选项
    -DFFTW3_DIR=${FFTW3_DIR}
    -DCMAKE_C_STANDARD=${CMAKE_C_STANDARD}
    -DCMAKE_C_EXTENSIONS=${CMAKE_C_EXTENSIONS}
    -DCMAKE_C_STANDARD_REQUIRED=${CMAKE_C_STANDARD_REQUIRED}
  CMAKE_CACHE_ARGS
    -DCMAKE_C_FLAGS:STRING=${CMAKE_C_FLAGS}
    -DCMAKE_PREFIX_PATH:PATH=${CMAKE_PREFIX_PATH}
  BUILD_ALWAYS
    1
  INSTALL_COMMAND
    ""
  )
