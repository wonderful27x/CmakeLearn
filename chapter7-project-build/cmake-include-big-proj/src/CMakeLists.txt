# 添加了两个库，这两个库的源文件target_sources在evolution,initial,io,parser中都有
# 也就是说这两个库的源文件分布在不同的目录里，使用target_sources添加到了对应的目标
# 在这里直接include进来就ok了
add_library(automaton "")
add_library(evolution "")

include(${CMAKE_CURRENT_LIST_DIR}/evolution/CMakeLists.txt)
include(${CMAKE_CURRENT_LIST_DIR}/initial/CMakeLists.txt)
include(${CMAKE_CURRENT_LIST_DIR}/io/CMakeLists.txt)
include(${CMAKE_CURRENT_LIST_DIR}/parser/CMakeLists.txt)

add_executable(automata "")

target_sources(automata
  PRIVATE
    ${CMAKE_CURRENT_LIST_DIR}/main.cpp
  )

target_link_libraries(automata
  PRIVATE
    automaton
    conversion
  )
