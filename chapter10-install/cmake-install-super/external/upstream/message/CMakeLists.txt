# 这个子项目主要就是为了处理message库这个依赖
find_package(message 1 CONFIG QUIET)
# 如果系统已经安装了，我们创建一个伪目录message_external,
# 因为外部依赖于它
if(message_FOUND)
  get_property(_loc TARGET message::message-shared PROPERTY LOCATION)
  message(STATUS "Found message: ${_loc} (found version ${message_VERSION})")
  add_library(message_external INTERFACE)  # dummy
else()
  # 没有找到则下载，执行超级构建，然后安装
  include(ExternalProject)
  message(STATUS "Suitable message could not be located, Building message instead.")
  ExternalProject_Add(message_external
    GIT_REPOSITORY
      https://github.com/dev-cafe/message.git
    GIT_TAG
      master
    UPDATE_COMMAND
      ""
    CMAKE_ARGS
      # 设置安装位置
      -DCMAKE_INSTALL_PREFIX=${STAGED_INSTALL_PREFIX}
      -DCMAKE_BUILD_TYPE=${CMAKE_BUILD_TYPE}
      -DCMAKE_CXX_COMPILER=${CMAKE_CXX_COMPILER}
    CMAKE_CACHE_ARGS
      -DCMAKE_CXX_FLAGS:STRING=${CMAKE_CXX_FLAGS}
    TEST_AFTER_INSTALL
      1
    DOWNLOAD_NO_PROGRESS
      1
    LOG_CONFIGURE
      1
    LOG_BUILD
      1
    LOG_INSTALL
      1
    )
  if(WIN32 AND NOT CYGWIN)
    set(DEF_message_DIR ${STAGED_INSTALL_PREFIX}/CMake)
  else()
    set(DEF_message_DIR ${STAGED_INSTALL_PREFIX}/share/cmake/message)
  endif()
  file(TO_NATIVE_PATH "${DEF_message_DIR}" DEF_message_DIR)
  # 设置安装目录message_DIR用于查找messageConfig.cmake模块
  set(message_DIR ${DEF_message_DIR}
      CACHE PATH "Path to internally built messageConfig.cmake" FORCE)
  message(STATUS "in message_DIR: ${message_DIR}")
endif()
