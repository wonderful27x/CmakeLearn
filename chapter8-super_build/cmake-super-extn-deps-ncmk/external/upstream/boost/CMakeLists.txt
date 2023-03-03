# 先寻找boost库，版本号和库元件变量是在顶层cmake定义的
find_package(Boost ${Boost_MINIMUM_REQUIRED} QUIET COMPONENTS ${BOOST_COMPONENTS_REQUIRED})

if(Boost_FOUND)
  # 如果找到了，添加为接口库
  message(STATUS "Found Boost version ${Boost_MAJOR_VERSION}.${Boost_MINOR_VERSION}.${Boost_SUBMINOR_VERSION}")
  add_library(boost_external INTERFACE)
else()
  # 否则我们需要自己下载编译
  message(STATUS "Boost ${Boost_MINIMUM_REQUIRED} could not be located, Building Boost 1.61.0 instead.")

  # boost不使用cmake,而是使用b2编译,因此我们需要设置它编译时需要的一些参数
  # _toolset
  if(CMAKE_CXX_COMPILER_ID MATCHES "GNU")
    if(APPLE)
      set(_toolset "darwin")
    else()
      set(_toolset "gcc")
    endif()
  elseif(CMAKE_CXX_COMPILER_ID MATCHES ".*Clang")
    set(_toolset "clang")
  elseif(CMAKE_CXX_COMPILER_ID MATCHES "Intel")
    if(APPLE)
      set(_toolset "intel-darwin")
    else()
      set(_toolset "intel-linux")
    endif()
  endif()

  # Non-empty list. Compiled libraries needed
  # 需要编译的库_b2_select_libraries, 和安装全路径_build_byproducts
  if(NOT "${BOOST_COMPONENTS_REQUIRED}" STREQUAL "")
    # Replace unit_test_framework (used by CMake's find_package) with test (understood by Boost build toolchain)
    string(REPLACE "unit_test_framework" "test" _b2_needed_components "${BOOST_COMPONENTS_REQUIRED}")
    # Generate argument for BUILD_BYPRODUCTS
    set(_build_byproducts)
    set(_b2_select_libraries)
    foreach(_lib IN LISTS _b2_needed_components)
      list(APPEND _build_byproducts ${STAGED_INSTALL_PREFIX}/boost/lib/libboost_${_lib}${CMAKE_SHARED_LIBRARY_SUFFIX})
      list(APPEND _b2_select_libraries --with-${_lib})
    endforeach()
    # Transform the ;-separated list to a ,-separated list (digested by the Boost build toolchain!)
    string(REPLACE ";" "," _b2_needed_components "${_b2_needed_components}")
    set(_bootstrap_select_libraries "--with-libraries=${_b2_needed_components}")
    string(REPLACE ";" ", " printout "${BOOST_COMPONENTS_REQUIRED}")
    message(STATUS "  Libraries to be built: ${printout}")
  endif()

  # 添加超级构建,构建boost_external
  include(ExternalProject)
  ExternalProject_Add(boost_external
    # 下载
    URL
      https://sourceforge.net/projects/boost/files/boost/1.61.0/boost_1_61_0.zip
    URL_HASH
      SHA256=02d420e6908016d4ac74dfc712eec7d9616a7fc0da78b0a1b5b937536b2e01e8
    # 不显示进度
    DOWNLOAD_NO_PROGRESS
      1
    # 不更新
    UPDATE_COMMAND
      ""
    # 编译前的配置，使用b2进行编译，所以要设置需要的参数
    CONFIGURE_COMMAND
      <SOURCE_DIR>/bootstrap.sh
      --with-toolset=${_toolset}
      --prefix=${STAGED_INSTALL_PREFIX}/boost
      ${_bootstrap_select_libraries}
    # 使用b2进行编译
    BUILD_COMMAND
      <SOURCE_DIR>/b2 -q
           link=shared
           threading=multi
           variant=release
           toolset=${_toolset}
           ${_b2_select_libraries}
    LOG_BUILD
      1
    # 构建在源目录中发生
    BUILD_IN_SOURCE
      1
    # 安装
    INSTALL_COMMAND
      <SOURCE_DIR>/b2 -q install
           link=shared
           threading=multi
           variant=release
           toolset=${_toolset}
           ${_b2_select_libraries}
    LOG_INSTALL
      1
    # 安装路径
    BUILD_BYPRODUCTS
      "${_build_byproducts}"
    )

  # 设置一些变量来指导库的安装位置信息
  set(
    BOOST_ROOT ${STAGED_INSTALL_PREFIX}/boost
    CACHE PATH "Path to internally built Boost installation root"
    FORCE
    )
  set(
    BOOST_INCLUDEDIR ${BOOST_ROOT}/include
    CACHE PATH "Path to internally built Boost include directories"
    FORCE
    )
  set(
    BOOST_LIBRARYDIR ${BOOST_ROOT}/lib
    CACHE PATH "Path to internally built Boost library directories"
    FORCE
    )

  # Unset internal variables
  # 取消内部变量
  unset(_toolset)
  unset(_b2_needed_components)
  unset(_build_byproducts)
  unset(_b2_select_libraries)
  unset(_bootstrap_select_libraries)
endif()
