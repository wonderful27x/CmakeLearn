cmake_minimum_required(VERSION 3.6 FATAL_ERROR)

project(recipe-04_core
  LANGUAGES CXX
  )

# 我们自己的代码，这是一个完全独立的项目
# 它依赖于message, 而message在message_external中处理
# 如果系统没有则执行超级构建并安装，所以这里使用find_package总能找到

set(CMAKE_CXX_STANDARD 11)
set(CMAKE_CXX_EXTENSIONS OFF)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

include(GNUInstallDirs)

set(CMAKE_ARCHIVE_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/${CMAKE_INSTALL_LIBDIR})
set(CMAKE_LIBRARY_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/${CMAKE_INSTALL_LIBDIR})
set(CMAKE_RUNTIME_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/${CMAKE_INSTALL_BINDIR})

find_package(message 1 CONFIG REQUIRED)
get_property(_loc TARGET message::message-shared PROPERTY LOCATION)
message(STATUS "Found message: ${_loc} (found version ${message_VERSION})")

add_executable(use_message use_message.cpp)

target_link_libraries(use_message
  PUBLIC
    message::message-shared
  )

# 设置RPATH
# Prepare RPATH
file(RELATIVE_PATH _rel ${CMAKE_INSTALL_PREFIX}/${CMAKE_INSTALL_BINDIR} ${CMAKE_INSTALL_PREFIX})
if(APPLE)
  set(_rpath "@loader_path/${_rel}")
else()
  set(_rpath "\$ORIGIN/${_rel}")
endif()
file(TO_NATIVE_PATH "${_rpath}/${CMAKE_INSTALL_LIBDIR}" use_message_RPATH)

set_target_properties(use_message
  PROPERTIES
    MACOSX_RPATH ON
    SKIP_BUILD_RPATH OFF
    BUILD_WITH_INSTALL_RPATH OFF
    INSTALL_RPATH "${use_message_RPATH}"
    INSTALL_RPATH_USE_LINK_PATH ON
  )

# 可执行文件被安装到${CMAKE_INSTALL_PREFIX}/${CMAKE_INSTALL_BINDIR}
# 注意这是由外部超级构建指定的 -DCMAKE_INSTALL_PREFIX=${STAGED_INSTALL_PREFIX}
# 而RPATH被设置为了$ORIGIN../${CMAKE_INSTALL_LIBDIR}，因此可执行文件可以正确找到库message

# 主CMakeLists.txt中再次进行了安装，安装到CMAKE_INSTALL_PREFIX中，
# 注意这是用户在cmake -DCMAKE_INSTALL_PREFIX中传递的，和这里面的不一样
# 由于使用的RPATH是$ORIGIN../${CMAKE_INSTALL_LIBDIR},类似相对目录，所以安装后的可执行文件也能正确找到库
# install(
#   DIRECTORY
#     ${STAGED_INSTALL_PREFIX}/
#   DESTINATION
#     .
#   USE_SOURCE_PERMISSIONS
#   )

# 所以这里的安装是安装在STAGED_INSTALL_PREFIX中
# 主CMakeLists.txt中的安装是将这里的安装复制了一份到最外层用户指定的CMAKE_INSTALL_PREFIX中

install(
  TARGETS
    use_message
  RUNTIME
    DESTINATION ${CMAKE_INSTALL_BINDIR}
    COMPONENT bin
  )
