cmake_minimum_required(VERSION 3.5 FATAL_ERROR)

# Fortran needed to discover LAPACK with some compilers
project(recipe-03 LANGUAGES CXX Fortran)

set(CMAKE_CXX_STANDARD 11)
set(CMAKE_CXX_EXTENSIONS OFF)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

find_package(BLAS REQUIRED)
find_package(LAPACK REQUIRED)

set(wrap_BLAS_LAPACK_sources
  ${CMAKE_CURRENT_BINARY_DIR}/wrap_BLAS_LAPACK/CxxBLAS.hpp
  ${CMAKE_CURRENT_BINARY_DIR}/wrap_BLAS_LAPACK/CxxBLAS.cpp
  ${CMAKE_CURRENT_BINARY_DIR}/wrap_BLAS_LAPACK/CxxLAPACK.hpp
  ${CMAKE_CURRENT_BINARY_DIR}/wrap_BLAS_LAPACK/CxxLAPACK.cpp
  )
set(wrap_BLAS_LAPACK_sourcess
  ${CMAKE_CURRENT_BINARY_DIR}/wrap_BLAS_LAPACK/CxxBLAS.hpp
  ${CMAKE_CURRENT_BINARY_DIR}/wrap_BLAS_LAPACK/CxxBLAS.cpp
  ${CMAKE_CURRENT_BINARY_DIR}/wrap_BLAS_LAPACK/CxxLAPACK.hpp
  ${CMAKE_CURRENT_BINARY_DIR}/wrap_BLAS_LAPACK/CxxLAPACK.cpp
  # for test no this file
  ${CMAKE_CURRENT_BINARY_DIR}/wrap_BLAS_LAPACK/test.cpp
  )
message(STATUS "before unpack sources: ${wrap_BLAS_LAPACK_sources}")

# 此命令在build时执行

# 项目的构建目标取决于命令的结果，这些命令只能在构建系统生成完成后的构建执行(build时才执行？)。CMake提供了三个选项来在构建时执行自定义命令:
# 1. 使用add_custom_command编译目标，生成输出文件。
# 2. add_custom_target的执行没有输出。
# 3. 构建目标前后，add_custom_command的执行可以没有输出。

# 解压文件并更新文件的时间戳
# -E 参数使用CMake内部命令，确保跨平台
# touch 在文件存在时只会更新时间并不会更新内容
# WORKING_DIRECTORY指定命令执行的目录
# COMMAND 构建时打印状态消息
# DEPENDS 列出自定义命令的依赖项
# VERBATIM 诉CMake为生成器和平台生成正确的命令，从而确保完全独立
# TODO 这里的输出OUTPUT 还未理解!!! 一下是书籍原话: (应该结合此命令的执行时机来理解) OUTPUT是一个预期输出
# add_custom_command向目标添加规则，并通过执行命令生成输出。add_custom_command中声明的任何目标，即在相同的CMakeLists.txt中声明的任何目标，使用输出的任何文件作为源文件的目标，在构建时会有规则生成这些文件。因此，源文件生成在构建时，目标和自定义命令在构建系统生成时，将自动处理依赖关系。
# add_custom_command有两个限制:
# 只有在相同的CMakeLists.txt中，指定了所有依赖于其输出的目标时才有效。
# 对于不同的独立目标，使用add_custom_command的输出可以重新执行定制命令。这可能会导致冲突，应该避免这种情况的发生。

# 官方文档
# A target created in the same directory (CMakeLists.txt file) that specifies any output of the custom command as a source file is given a rule to generate the file using the command at build time
# 在将自定义命令的任何输出指定为源文件的同一目录（CMakeLists.txt 文件）中创建的目标被赋予规则以在构建时使用命令生成文件
# for test
set(wrap_BLAS_LAPACK_source
    ${CMAKE_CURRENT_BINARY_DIR}/wrap_BLAS_LAPACK/CxxBLAS.cpp
    ${CMAKE_CURRENT_BINARY_DIR}/wrap_BLAS_LAPACK/CxxLAPACK.hpp
    ${CMAKE_CURRENT_BINARY_DIR}/wrap_BLAS_LAPACK/CxxLAPACK.cpp
)

# 经测试发现OUTPUT预期输出必须包含后面的target目标所依赖的所有源文件，
# 注意是包含关系，可以多于但不能少于,可以能这就是“预期输出”的含义吧
add_custom_command(
  OUTPUT
    ${wrap_BLAS_LAPACK_sources}
  COMMAND
    ${CMAKE_COMMAND} -E tar xzf ${CMAKE_CURRENT_SOURCE_DIR}/wrap_BLAS_LAPACK.tar.gz
  COMMAND
    ${CMAKE_COMMAND} -E touch ${wrap_BLAS_LAPACK_sourcess}
  WORKING_DIRECTORY
    ${CMAKE_CURRENT_BINARY_DIR}
  DEPENDS
    ${CMAKE_CURRENT_SOURCE_DIR}/wrap_BLAS_LAPACK.tar.gz
  COMMENT
    "Unpacking C++ wrappers for BLAS/LAPACK"
  VERBATIM
  )

# 利用上面生成的源文件生成一个库
add_library(math "")

target_sources(math
  PRIVATE
    ${CMAKE_CURRENT_BINARY_DIR}/wrap_BLAS_LAPACK/CxxBLAS.cpp
    ${CMAKE_CURRENT_BINARY_DIR}/wrap_BLAS_LAPACK/CxxLAPACK.cpp
  PUBLIC
    ${CMAKE_CURRENT_BINARY_DIR}/wrap_BLAS_LAPACK/CxxBLAS.hpp
    ${CMAKE_CURRENT_BINARY_DIR}/wrap_BLAS_LAPACK/CxxLAPACK.hpp
  )

# 依赖math的库才使用这些头文件，math自身不适用它们
target_include_directories(math
  INTERFACE
    ${CMAKE_CURRENT_BINARY_DIR}/wrap_BLAS_LAPACK
  )

target_link_libraries(math
  PUBLIC
    ${LAPACK_LIBRARIES}
  )

add_executable(linear-algebra linear-algebra.cpp)

target_link_libraries(linear-algebra
  PRIVATE
    math
  )
