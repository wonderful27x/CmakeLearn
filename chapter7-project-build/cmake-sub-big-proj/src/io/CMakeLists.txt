add_library(io "")

target_sources(io
  PRIVATE
    io.cpp
  PUBLIC
    ${CMAKE_CURRENT_LIST_DIR}/io.hpp
  )

target_include_directories(io
  PUBLIC
    ${CMAKE_CURRENT_LIST_DIR}
  )

# 在CMake的3.12版本中，OBJECT库是组织大型项目的另一种可行方法。对我们的示例的惟一修改是在库的CMakeLists.txt中。源文件将被编译成目标文件：既不存档到静态库中，也不链接到动态库中。例如：
# add_library(io OBJECT "")

# target_sources(io
#   PRIVATE
#   	io.cpp
#   PUBLIC
#   	${CMAKE_CURRENT_LIST_DIR}/io.hpp
#   )

# target_include_directories(io
#   PUBLIC
#   	${CMAKE_CURRENT_LIST_DIR}
#   )
