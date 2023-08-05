message(STATUS "deps bin dir: ${CMAKE_CURRENT_BINARY_DIR}")

# find_package(BLAS REQUIRED)
# find_package(LAPACK REQUIRED)

set(MATH_SRCS
  ${CMAKE_CURRENT_BINARY_DIR}/wrap_BLAS_LAPACK/CxxBLAS.cpp
  ${CMAKE_CURRENT_BINARY_DIR}/wrap_BLAS_LAPACK/CxxLAPACK.cpp
  ${CMAKE_CURRENT_BINARY_DIR}/wrap_BLAS_LAPACK/CxxBLAS.hpp
  ${CMAKE_CURRENT_BINARY_DIR}/wrap_BLAS_LAPACK/CxxLAPACK.hpp
  )

# 这里不是很理解，为什么需要这个target目标，注释也可以运行
# 网上解释： https://zhuanlan.zhihu.com/p/397394950（还是有点问题）
# 重点就是依赖关系： ${MATH_SRCS} 什么时候会被生成，什么时候会重新生成
# https://blog.csdn.net/sinat_31608641/article/details/121737020
#
# 最终得到自己的理解：
# add_custom_target添加了一个没有输出的目标(ALL参数)，无论如何都会执行
# add_custom_target依赖${MATH_SRCS}, 所以他的目的就是告诉控制链你需要先给我生成这些文件，
# 然后我才做我的工作，但是怎么生成，以及谁来生成我不管
# add_custom_command才是真正用于生成这些文件的工作者，它的输出就是${MATH_SRCS},
# 它的command命令则是生成这些文件的具体方法，而它自己的依赖DEPENDS则代表需要生成这些文件的原材料和条件
# 如果它们存在我就用这些原材料生成（也不一定非要用这些原材料，其实这只是一种依赖关系），或者它们被更新了，我就重新生成
# 无论add_custom_target还是add_custom_command都是在build时才执行，所以网上说有ALL参数不需要cmake --build也能生成文件是错误的
# ALL目标的含义是，不需要其他任何目标的存在（如add_library等添加的目标），也可以生成，即我们把所有目标都注释掉，只剩add_custom_target和add_custom_command
add_custom_target(BLAS_LAPACK_wrappers ALL
  WORKING_DIRECTORY
    ${CMAKE_CURRENT_BINARY_DIR}
  DEPENDS
    ${MATH_SRCS}
  COMMENT
    "Intermediate BLAS_LAPACK_wrappers target"
  VERBATIM
  )

add_custom_command(
  OUTPUT
    ${MATH_SRCS}
  COMMAND
    ${CMAKE_COMMAND} -E tar xzf ${CMAKE_CURRENT_SOURCE_DIR}/wrap_BLAS_LAPACK.tar.gz
  WORKING_DIRECTORY
    ${CMAKE_CURRENT_BINARY_DIR}
  DEPENDS
    ${CMAKE_CURRENT_SOURCE_DIR}/wrap_BLAS_LAPACK.tar.gz
  COMMENT
    "Unpacking C++ wrappers for BLAS/LAPACK"
  )

add_library(math "")

target_sources(math
  PRIVATE
    ${MATH_SRCS}
  )

target_include_directories(math
  INTERFACE
    ${CMAKE_CURRENT_BINARY_DIR}/wrap_BLAS_LAPACK
  )

# BLAS_LIBRARIES are included in LAPACK_LIBRARIES
target_link_libraries(math
  PUBLIC
    ${LAPACK_LIBRARIES}
  )
