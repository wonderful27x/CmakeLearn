cmake_minimum_required(VERSION 3.5 FATAL_ERROR)

project(recipe-02 LANGUAGES CXX)

set(CMAKE_CXX_STANDARD 11)
set(CMAKE_CXX_EXTENSIONS OFF)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

# 使用超级构建管理外部项目boost，boost本身不使用cmake编译

# 设置超级构建的目录，项目将被构建于subprojects/Build中
# CMAKE_BINARY_DIR是cmake -H. -Bbuild 指定的构建目录的跟目录，即build
set_property(DIRECTORY PROPERTY EP_BASE ${CMAKE_BINARY_DIR}/subprojects)

# 设置变量保存构建树中依赖的安装目录
set(STAGED_INSTALL_PREFIX ${CMAKE_BINARY_DIR}/stage)
message(STATUS "${PROJECT_NAME} staged install: ${STAGED_INSTALL_PREFIX}")

# 跳过对Boost库的检测，并始终执行超级构建
set(CMAKE_DISABLE_FIND_PACKAGE_Boost ON)

# 设置变量保存需要构建的库和版本
list(APPEND BOOST_COMPONENTS_REQUIRED filesystem system)
set(Boost_MINIMUM_REQUIRED 1.61)

message(STATUS "boost include path: ${BOOST_INCLUDEDIR}")
message(STATUS "boost library path: ${BOOST_LIBRARYDIR}")

# 添加子项目,其中又添加了external/upstream/boost, 这是一个超级构建
# 注意先构建add_subdirectory添加的子项目，内部会构建一个名叫boost_external的项目
add_subdirectory(external/upstream)

message(STATUS "boost include path: ${BOOST_INCLUDEDIR}")
message(STATUS "boost library path: ${BOOST_LIBRARYDIR}")

# 超级构建我们自己的源码, 将它作为一个外部项目,
# 它依赖于add_subdirectory添加的子项目boost_external
include(ExternalProject)
ExternalProject_Add(${PROJECT_NAME}_core
  DEPENDS
    boost_external
  SOURCE_DIR
    ${CMAKE_CURRENT_LIST_DIR}/src
  CMAKE_ARGS
    -DCMAKE_CXX_COMPILER=${CMAKE_CXX_COMPILER}
    -DCMAKE_CXX_STANDARD=${CMAKE_CXX_STANDARD}
    -DCMAKE_CXX_EXTENSIONS=${CMAKE_CXX_EXTENSIONS}
    -DCMAKE_CXX_STANDARD_REQUIRED=${CMAKE_CXX_STANDARD_REQUIRED}
  CMAKE_CACHE_ARGS
    -DCMAKE_CXX_FLAGS:STRING=${CMAKE_CXX_FLAGS}
    # 将boost的库和头文件位置传递给这个项目，因为它依赖于boost
    # BOOST_INCLUDEDIR和BOOST_LIBRARYDIR变量会在boost_external中设置为其安装路径
    -DCMAKE_INCLUDE_PATH:PATH=${BOOST_INCLUDEDIR}
    -DCMAKE_LIBRARY_PATH:PATH=${BOOST_LIBRARYDIR}
  BUILD_ALWAYS
    1
  INSTALL_COMMAND
    ""
  )

message(STATUS "boost include path: ${BOOST_INCLUDEDIR}")
message(STATUS "boost library path: ${BOOST_LIBRARYDIR}")
