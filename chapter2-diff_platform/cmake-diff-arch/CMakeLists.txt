# set minimum cmake version
cmake_minimum_required(VERSION 3.5 FATAL_ERROR)

# project name and language
project(recipe-04 LANGUAGES CXX)

# define executable and its source file
add_executable(arch-dependent arch-dependent.cpp)

# let the preprocessor know about the size of void *
# CMAKE_SIZEOF_VOID_P 为void的指针大小，是检测当前cpu是32/64位的唯一真正可移植的方法
if(CMAKE_SIZEOF_VOID_P EQUAL 8)
  target_compile_definitions(arch-dependent PUBLIC "IS_64_BIT_ARCH")
  message(STATUS "Target is 64 bits")
else()
  target_compile_definitions(arch-dependent PUBLIC "IS_32_BIT_ARCH")
  message(STATUS "Target is 32 bits")
endif()

# let the preprocessor know about the host processor architecture
# 区分架构
# 一. CMAKE_HOST_SYSTEM_PROCESSOR包含当前运行的cpu在cmake中的名称
# CMAKE_SYSTEM_PROCESSOR包含当前正在为其构建的cpu的名称，如交叉编译
if(CMAKE_HOST_SYSTEM_PROCESSOR MATCHES "i386")
  message(STATUS "i386 architecture detected")
elseif(CMAKE_HOST_SYSTEM_PROCESSOR MATCHES "i686")
  message(STATUS "i686 architecture detected")
elseif(CMAKE_HOST_SYSTEM_PROCESSOR MATCHES "x86_64")
  message(STATUS "x86_64 architecture detected")
else()
  message(STATUS "host processor architecture is unknown")
endif()

# 设置执行、静态和动态库目标构建的输出位置，让用户在不安装时也能找到
# 使用GNUInstallDirs.cmake模块,这将确保的项目布局的合理性和可移植性
# CMAKE_INSTALL_BINDIR：这将用于定义用户可执行文件所在的子目录，即所选安装目录下的bin目录。
# CMAKE_INSTALL_LIBDIR：这将扩展到目标代码库(即静态库和动态库)所在的子目录。在64位系统上，它是lib64，而在32位系统上，它只是lib。
# CMAKE_INSTALL_INCLUDEDIR：最后，我们使用这个变量为C头文件获取正确的子目录，该变量为include。
include(GNUInstallDirs)
set(CMAKE_ARCHIVE_OUTPUT_DIRECTORY ${PROJECT_BINARY_DIR}/${CMAKE_INSTALL_LIBDIR})
set(CMAKE_LIBRARY_OUTPUT_DIRECTORY ${PROJECT_BINARY_DIR}/${CMAKE_INSTALL_LIBDIR})
set(CMAKE_RUNTIME_OUTPUT_DIRECTORY ${PROJECT_BINARY_DIR}/${CMAKE_INSTALL_BINDIR})
message(STATUS "静态库构建输出目录: ${CMAKE_ARCHIVE_OUTPUT_DIRECTORY} \n
PROJECT_BINARY_DIR: ${PROJECT_BINARY_DIR} CMAKE_INSTALL_LIBDIR: ${CMAKE_INSTALL_LIBDIR}")
message(STATUS "动态库构建输出目录: ${CMAKE_LIBRARY_OUTPUT_DIRECTORY} \n
PROJECT_BINARY_DIR: ${PROJECT_BINARY_DIR} CMAKE_INSTALL_LIBDIR: ${CMAKE_INSTALL_LIBDIR}")
message(STATUS "可执行文件构建输出目录: ${CMAKE_RUNTIME_OUTPUT_DIRECTORY} \n
PROJECT_BINARY_DIR: ${PROJECT_BINARY_DIR} CMAKE_INSTALL_BINDIR: ${CMAKE_INSTALL_BINDIR}")

# 二. 另一种获取架构的方法，利用cmake的错误返回码，先运行try_run进行测试
# see https://github.com/axr/cmake/blob/master/targetarch.cmake
#if defined(__i386) || defined(__i386__) || defined(_M_IX86)
	#error cmake_arch i386
#elif defined(__x86_64) || defined(__x86_64__) || defined(__amd64) || defined(_M_X64)
	#error cmake_arch x86_64
#endif

target_compile_definitions(arch-dependent
  PUBLIC "ARCHITECTURE=${CMAKE_HOST_SYSTEM_PROCESSOR}"
  )

# 三. 还有一种不太推荐的是，不同架构对应不同的cpp文件 target_source
# add_executable(arch-dependent "")
# if(CMAKE_HOST_SYSTEM_PROCESSOR MATCHES "i386")
#     message(STATUS "i386 architecture detected")
#     target_sources(arch-dependent
#         PRIVATE
#             arch-dependent-i386.cp
#     )
# elseif(CMAKE_HOST_SYSTEM_PROCESSOR MATCHES "i686")
# 	message(STATUS "i686 architecture detected")
# 	target_sources(arch-dependent
# 		PRIVATE
# 			arch-dependent-i686.cpp
# 	)
# elseif(CMAKE_HOST_SYSTEM_PROCESSOR MATCHES "x86_64")
# 	message(STATUS "x86_64 architecture detected")
# 	target_sources(arch-dependent
# 		PRIVATE
# 			arch-dependent-x86_64.cpp
# 	)
# else()
# 	message(STATUS "host processor architecture is unknown")
# endif()
