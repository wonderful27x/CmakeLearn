# 查找用于文档生成的工具
find_package(Perl REQUIRED)
find_package(Doxygen REQUIRED)

# 定义一个函数
# 这个函数可以理解这些参数：BUILD_DIR、DOXY_FILE、TARGET_NAME和COMMENT。使用cmake_parse_arguments标准CMake命令解析这些参数：
# 这个函数将会传递BUILD_DIR: 文档的输出目录
# DOXY_FILE: 模板文件, Doxyfile包含用于构建文档的所有Doxygen设置
function(add_doxygen_doc)
  set(options)
  # 单值命名参数
  set(oneValueArgs BUILD_DIR DOXY_FILE TARGET_NAME COMMENT)
  set(multiValueArgs)

  # 解析函数参数, 解析后的参数将会添加DOXY_DOC前缀
  # 如DOXY_FILE -> DOXY_DOC_DOXY_FILE
  cmake_parse_arguments(DOXY_DOC
    "${options}"
    "${oneValueArgs}"
    "${multiValueArgs}"
    ${ARGN}
    )

  # 根据模板文件生成Doxyfile
  # Doxyfile包含用于构建文档的所有Doxygen设置
  configure_file(
    ${DOXY_DOC_DOXY_FILE}
    ${DOXY_DOC_BUILD_DIR}/Doxyfile
    @ONLY
    )

  # CMake不支持文档构建。但是，我们可以使用add_custom_target执行任意操作
  # 调用doxygen命令生成文档
  add_custom_target(${DOXY_DOC_TARGET_NAME}
    COMMAND
      ${DOXYGEN_EXECUTABLE} Doxyfile
    WORKING_DIRECTORY
      ${DOXY_DOC_BUILD_DIR}
    COMMENT
      "Building ${DOXY_DOC_COMMENT} with Doxygen"
    VERBATIM
    )

  message(STATUS "Added ${DOXY_DOC_TARGET_NAME} [Doxygen] target to build documentation")
endfunction()
