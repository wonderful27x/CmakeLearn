# set minimum cmake version
cmake_minimum_required(VERSION 3.9 FATAL_ERROR)

# project name and language
project(recipe-09 LANGUAGES CXX)

# 使用生成器表达是微调参数
# 生成器表达式用于引用仅在生成时已知，但在配置时未知或难于知晓的信息；对于文件名、文件位置和库文件后缀尤其如此。
# CMake分两个阶段生成项目的构建系统：配置阶段(解析CMakeLists.txt)和生成阶段(实际生成构建环境)。生成器表达式在第二阶段进行计算，可以使用仅在生成时才能知道的信息来调整构建系统。生成器表达式在交叉编译时特别有用，一些可用的信息只有解析CMakeLists.txt之后，或在多配置项目后获取，构建系统生成的所有项目可以有不同的配置，比如Debug和Release。

set(CMAKE_CXX_STANDARD 11)
set(CMAKE_CXX_EXTENSIONS OFF)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

option(USE_MPI "Use MPI parallelization" ON)

if(USE_MPI)
  find_package(MPI REQUIRED)
endif()

add_executable(example example.cpp)

# CMake提供了三种类型的生成器表达式:
# 逻辑表达式，基本模式为$<condition:outcome>。基本条件为0表示false, 1表示true，但是只要使用了正确的关键字，任何布尔值都可以作为条件变量。
# 信息表达式，基本模式为$<information>或$<information:input>。这些表达式对一些构建系统信息求值，例如：包含目录、目标属性等等。这些表达式的输入参数可能是目标的名称，比如表达式 $<TARGET_PROPERTY:tgt,prop>，将获得的信息是tgt目标上的prop属性。
# 输出表达式，基本模式为$<operation>或$<operation:input>。这些表达式可能基于一些输入参数，生成一个输出。它们的输出可以直接在CMake命令中使用，也可以与其他生成器表达式组合使用。例如, - I$<JOIN:$<TARGET_PROPERTY:INCLUDE_DIRECTORIES>, -I>将生成一个字符串，其中包含正在处理的目标的包含目录，每个目录的前缀由-I表示。

target_link_libraries(example
  PUBLIC
    $<$<BOOL:${MPI_FOUND}>:MPI::MPI_CXX>
  )

target_compile_definitions(example
  PRIVATE
    $<$<BOOL:${MPI_FOUND}>:HAVE_MPI>
  )

# 我们可以通过if来达到同样的效果:
# if(MPI_FOUND)
#   target_link_libraries(example
#     PUBLIC
#     	MPI::MPI_CXX
#     )

#   target_compile_definitions(example
#     PRIVATE
#     	HAVE_MPI
#     )
# endif()

if(MPI_FOUND)
  include(CMakePrintHelpers)
  cmake_print_properties(
    TARGETS MPI::MPI_CXX
    PROPERTIES INTERFACE_LINK_LIBRARIES
    )
endif()
