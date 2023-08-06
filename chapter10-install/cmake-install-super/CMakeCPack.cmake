# 此模块用于在构建目录下生成 CPackConfig.cmake。当运行以package或package_source目标的CMake命令时，CPack会自动调用生成的模块

# 设置报名，供应商，描述文件(包含安装说明)，包描述，许可协议
set(CPACK_PACKAGE_NAME "${PROJECT_NAME}")
set(CPACK_PACKAGE_VENDOR "wonderful")
set(CPACK_PACKAGE_DESCRIPTION_SUMMARY "message: super build")
# set(CPACK_PACKAGE_DESCRIPTION_FILE "${CMAKE_CURRENT_LIST_DIR}/INSTALL.md")
# set(CPACK_RESOURCE_FILE_LICENSE "${CMAKE_CURRENT_LIST_DIR}/LICENSE")

# 从发布包中安装时，文件将放在/opt/xxx目录下 ?
if(NOT CPACK_PACKAGING_INSTALL_PREFIX)
    set(CPACK_PACKAGING_INSTALL_PREFIX "/opt/${PROJECT_NAME}")
endif()

# TODO 版本号
set(CPACK_PACKAGE_VERSION_MAJOR "${PROJECT_VERSION_MAJOR}")
set(CPACK_PACKAGE_VERSION_MINOR "${PROJECT_VERSION_MINOR}")
set(CPACK_PACKAGE_VERSION_PATCH "${PROJECT_VERSION_PATCH}")

# 打包时需要忽略的文件
# set(CPACK_IGNORE_FILES "")
list(APPEND _cpack_source_ignore_files "${PROJECT_BINARY_DIR}")
list(APPEND _cpack_source_ignore_files "${CMAKE_INSTALL_PREFIX}")
list(APPEND _cpack_source_ignore_files "/cmake_ign_install/")
list(APPEND _cpack_source_ignore_files "/cmake_ign_third_depends/")
list(APPEND _cpack_source_ignore_files ".swp$")
list(APPEND _cpack_source_ignore_files "/.git/")
list(APPEND _cpack_source_ignore_files ".gitignore")
set(CPACK_SOURCE_IGNORE_FILES "${_cpack_source_ignore_files}")

# 源码打包生成器, 可以打包多种格式
set(CPACK_SOURCE_GENERATOR "ZIP;TGZ")
# 二进制文件打包生成器
set(CPACK_GENERATOR "ZIP;TGZ")

# CPackage中的生成器类似CMake的生成器概念
# CMake上下文中的生成器是用于生成本地构建脚本的工具，例如Unix Makefile或Visual Studio项目文件，而CPack上下文中的生成器是用于打包的工具。
# DEB包生成器将调用Debian打包实用程序，而TGZ生成器将调用给定平台上的归档工具
# 我们可以直接在build目录中调用CPack，并选择要与-G命令行选项一起使用的生成器:
# cpack -G RPM

# 设置原生平台二进制安装程序
if(UNIX)
  if(CMAKE_SYSTEM_NAME MATCHES Linux)
    list(APPEND CPACK_GENERATOR "DEB")
    set(CPACK_DEBIAN_PACKAGE_MAINTAINER "robertodr")
    set(CPACK_DEBIAN_PACKAGE_SECTION "devel")
    # TODO 指定依赖uuid
    # set(CPACK_DEBIAN_PACKAGE_DEPENDS "uuid-dev")

    list(APPEND CPACK_GENERATOR "RPM")
    # TODO release版本
    set(CPACK_RPM_PACKAGE_RELEASE "1")
    # 指定许可协议
    # set(CPACK_RPM_PACKAGE_LICENSE "MIT")
    # TODO 指定依赖uuid
    # set(CPACK_RPM_PACKAGE_REQUIRES "uuid-devel")
  endif()
endif()

if(WIN32 OR MINGW)
  list(APPEND CPACK_GENERATOR "NSIS")
  set(CPACK_NSIS_PACKAGE_NAME "super-build")
  set(CPACK_NSIS_CONTACT "robertdr")
  set(CPACK_NSIS_ENABLE_UNINSTALL_BEFORE_INSTALL ON)
endif()

if(APPLE)
  list(APPEND CPACK_GENERATOR "Bundle")
  set(CPACK_BUNDLE_NAME "super-build")
  # TODO
  # configure_file(${PROJECT_SOURCE_DIR}/cmake/Info.plist.in Info.plist @ONLY)
  # set(CPACK_BUNDLE_PLIST ${CMAKE_CURRENT_BINARY_DIR}/Info.plist)
  # set(CPACK_BUNDLE_ICON ${PROJECT_SOURCE_DIR}/cmake/coffee.icns)
endif()

message(STATUS "CPack generators: ${CPACK_GENERATOR}")

# 最后，我们包括了CPack.cmake标准模块。这将向构建系统添加一个package和一个package_source目标:
include(CPack)


