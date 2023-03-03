# the following code to fetch a git repo at configure-time
# is inspired by and adapted after https://crascit.com/2015/07/25/cmake-gtest/
# defines ${_project_name}_SOURCE_DIR and ${_project_name}_BINARY_DIR

# 使用ExternalProject_Add模拟FetchContent的宏
macro(fetch_git_repo _project_name _download_root _git_url _git_tag)

  set(${_project_name}_SOURCE_DIR ${_download_root}/${_project_name}-src)
  set(${_project_name}_BINARY_DIR ${_download_root}/${_project_name}-build)

  # variables used configuring fetch_git_repo_sub.cmake
  set(FETCH_PROJECT_NAME ${_project_name})
  set(FETCH_SOURCE_DIR ${${_project_name}_SOURCE_DIR})
  set(FETCH_BINARY_DIR ${${_project_name}_BINARY_DIR})
  set(FETCH_GIT_REPOSITORY ${_git_url})
  set(FETCH_GIT_TAG ${_git_tag})

  # 生成一个CMakeLists.txt, 里面定义了ExternalProject_Add用于下载googletest
  configure_file(
    ${CMAKE_CURRENT_LIST_DIR}/fetch_at_configure_step.in
    ${_download_root}/CMakeLists.txt
    @ONLY
    )

  # undefine them again
  unset(FETCH_PROJECT_NAME)
  unset(FETCH_SOURCE_DIR)
  unset(FETCH_BINARY_DIR)
  unset(FETCH_GIT_REPOSITORY)
  unset(FETCH_GIT_TAG)

  # 用个cmake命令配置上面生成了CMakeLists.txt
  message(STATUS "run ${CMAKE_COMMAND} -G ${CMAKE_GENERATOR}")
  # configure sub-project
  execute_process(
    COMMAND
      "${CMAKE_COMMAND}" -G "${CMAKE_GENERATOR}" .
    WORKING_DIRECTORY
      ${_download_root}
    )

  # 使用cmake命令构建生成的CMakeLists.txt项目，使得ExternalProject_Add被执行从而进行下载
  # 这种思想太绝妙了！！！
  # 在主项目中配置(cmake)时构建(build)一个外部依赖(超级构建)
  message(STATUS "run ${CMAKE_COMMAND} --build .")
  # build sub-project which triggers ExternalProject_Add
  execute_process(
    COMMAND
      "${CMAKE_COMMAND}" --build .
    WORKING_DIRECTORY
      ${_download_root}
    )
endmacro()

