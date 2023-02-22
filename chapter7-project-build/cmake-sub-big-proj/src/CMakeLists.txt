message("current binary dir is ${CMAKE_CURRENT_BINARY_DIR}")

# 保护我们的构建树
if(${PROJECT_SOURCE_DIR} STREQUAL ${PROJECT_BINARY_DIR})
    message(STATUS "PROJECT_SOURCE_DIR: ${PROJECT_SOURCE_DIR} PROJECT_BINARY_DIR: ${PROJECT_BINARY_DIR}")
	message(FATAL_ERROR "In-source builds not allowed. Please make a new directory (called a build directory) and run CMake from there.")
endif()

add_executable(automata main.cpp)

add_subdirectory(evolution)
add_subdirectory(initial)
add_subdirectory(io)
add_subdirectory(parser)

target_link_libraries(automata
  PRIVATE
    conversion
    evolution
    initial
    io
    parser
  )
