# 先检查库是否存在
find_package(FFTW3 CONFIG QUIET)

# 如果安装了添加fftw3_external因为外部对它进行了依赖，这里好像是个空的项目
if(FFTW3_FOUND)
  get_property(_loc TARGET FFTW3::fftw3 PROPERTY LOCATION)
  message(STATUS "Found FFTW3: ${_loc} (found version ${FFTW3_VERSION})")
  add_library(fftw3_external INTERFACE)  # dummy
# 否则下载并进行超级构建,然后安装，安装后是支持find_package的
else()
  message(STATUS "Suitable FFTW3 could not be located. Downloading and building!")

  include(ExternalProject)
  # 因为fftw3使用cmake构建，所以这里的超级构建很简单
  ExternalProject_Add(fftw3_external
    URL
      http://www.fftw.org/fftw-3.3.8.tar.gz
    URL_HASH
      MD5=8aac833c943d8e90d51b697b27d4384d
    DOWNLOAD_NO_PROGRESS
      1
    UPDATE_COMMAND
      ""
    LOG_CONFIGURE
      1
    LOG_BUILD
      1
    LOG_INSTALL
      1
    CMAKE_ARGS
      -DCMAKE_INSTALL_PREFIX=${STAGED_INSTALL_PREFIX}
      # 关闭test模块
      -DBUILD_TESTS=OFF
    CMAKE_CACHE_ARGS
      # 如果是windows上编译，设置-DWITH_OUR_MALLOC编译标志
      -DCMAKE_C_FLAGS:STRING=$<$<BOOL:WIN32>:-DWITH_OUR_MALLOC>
    )

  include(GNUInstallDirs)

  set(
    # 设置FFTW3_DIR, 告诉cmake FFTW3Config.cmake的位置
    FFTW3_DIR ${STAGED_INSTALL_PREFIX}/${CMAKE_INSTALL_LIBDIR}/cmake/fftw3
    CACHE PATH "Path to internally built FFTW3Config.cmake"
    FORCE
    )
endif()
