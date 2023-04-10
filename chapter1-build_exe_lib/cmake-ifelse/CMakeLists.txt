# cmake_minimum_required(VERSION 3.5 FATAL_ERROR)

# project(cmake-ifelse LANGUAGES CXX)

# set(USE_LIBRARY OFF)

# message(STATUS "Compile sources into a library? ${USE_LIBRARY}")

# set(BUILD_SHARED_LIBS OFF)

# list(APPEND _sources message.h message.cpp)

# if(USE_LIBRARY)
#     add_library(message ${_sources})
#     add_executable(hello-cmake hello-cmake.cpp)
#     target_link_libraries(hello-cmake message)
# else()
#     add_executable(hello-cmake hello-cmake.cpp ${_sources})
# endif()

cmake_minimum_required(VERSION 3.5 FATAL_ERROR)

project(cmake-ifelse LANGUAGES CXX)

# 打印编译器标志
message(STATUS "Is the C++ compiler loaded? ${CMAKE_CXX_COMPILER_LOADED}")
if(CMAKE_CXX_COMPILER_LOADED)
    message(STATUS "The C++ compiler ID is: ${CMAKE_CXX_COMPILER_ID}")
    message(STATUS "Is the C++ from GUN? ${CMAKE_COMPILER_IS_GUNCXX}")
    message(STATUS "The C++ compiler version is: ${CMAKE_CXX_COMPILER_VERSION}")
endif()

message(STATUS "Is the C compiler loaded? ${CMAKE_C_COMPILER_LOADED}")
if(CMAKE_C_COMPILER_LOADED)
    message(STATUS "The C compiler ID is: ${CMAKE_C_COMPILER_ID}")
    message(STATUS "Is the C from GUN? ${CMAKE_COMPILER_IS_GUNC}")
    message(STATUS "The C compiler version is: ${CMAKE_C_COMPILER_VERSION}")
endif()

# 设置构建类型
if(NOT CMAKE_BUILD_TYPE)
    set(CMAKE_BUILD_TYPE Release CACHE STRING "Build type" FORCE)
endif()
message(STATUS "Build type: ${CMAKE_BUILD_TYPE}")
message(STATUS "C flags, Debug configuration: ${CMAKE_C_FLAGS_DEBUG}")
message(STATUS "C flags, Release configuration: ${CMAKE_C_FLAGS_RELEASE}")
message(STATUS "C flags, Release configuration with Debug info: ${CMAKE_C_FLAGS_RELWITHDEBINFO}")
message(STATUS "C flags, minimal Release configuration: ${CMAKE_C_FLAGS_MINSIZEREL}")
message(STATUS "C++ flags, Debug configuration: ${CMAKE_CXX_FLAGS_DEBUG}")
message(STATUS "C++ flags, Release configuration: ${CMAKE_CXX_FLAGS_RELEASE}")
message(STATUS "C++ flags, Release configuration with Debug info: ${CMAKE_CXX_FLAGS_RELWITHDEBINFO}")
message(STATUS "C++ flags, minimal Release configuration: ${CMAKE_CXX_FLAGS_MINSIZEREL}")
 
# 通过外部定义宏控制库类型
option(USE_LIBRARY "Compile sources into a library" OFF)

# test
set(MAKE_STATIC "MAKE_${upper_module_name}_STATIC")
set(MAKE_SHARED "MAKE_${upper_module_name}_SHARED")
option("U_${MAKE_STATIC}" "Compile source into a static library" OFF)
option("U_${MAKE_SHARED}" "Compile source into a shared library" ON)
message(STATUS "make static: ${U_${MAKE_STATIC}}")
message(STATUS "make shared: ${U_${MAKE_SHARED}}")

message(STATUS "Compile sources into a library? ${USE_LIBRARY}")

include(CMakeDependentOption)

cmake_dependent_option(
    MAKE_STATIC_LIBRARY "Compile sources into a static library" OFF
    "USE_LIBRARY" ON
    )

cmake_dependent_option(
    MAKE_SHARED_LIBRARY "Compile sources into a shared library" ON
    "USE_LIBRARY" ON
    )

set(CMAKE_WINDOWS_EXPORT_ALL_SYMBOLS ON)

list(APPEND _sources message.h message.cpp)

if(USE_LIBRARY)
    message(STATUS "Compile sources into a STATIC library? ${MAKE_STATIC_LIBRARY}")
    message(STATUS "Compile sources into a SHARED library? ${MAKE_SHARED_LIBRARY}")

    if(MAKE_SHARED_LIBRARY)
        add_library(message-shared SHARED ${_sources})
        add_executable(hello-cmake-shared hello-cmake.cpp)
        target_link_libraries(hello-cmake-shared message-shared)
    endif()

    if(MAKE_STATIC_LIBRARY)
        add_library(message-static STATIC ${_sources})
        add_executable(hello-cmake-static hello-cmake.cpp)
        target_link_libraries(hello-cmake-static message-static)
    endif()
else()
    add_executable(hello-cmake hello-cmake.cpp ${_sources})
endif()

