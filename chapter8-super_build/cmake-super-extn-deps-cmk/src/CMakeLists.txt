cmake_minimum_required(VERSION 3.5 FATAL_ERROR)

project(recipe-03_core LANGUAGES C)

# 构建我们自己的代码，内部将调用fftw3库
# 使用CONFIG选项，将查找FFTW3Config.cmake模块而不是FFTW3.cmake
# 注意构建我们代码前在外部对fftw3进行了检查，如果没有安装会进行超级构建并安装
# 所以这里面这样写就很简单了
find_package(FFTW3 CONFIG REQUIRED)
# 打印位置版本信息
get_property(_loc TARGET FFTW3::fftw3 PROPERTY LOCATION)
message(STATUS "Found FFTW3: ${_loc} (found version ${FFTW3_VERSION})")

add_executable(fftw_example fftw_example.c)

target_link_libraries(fftw_example
  PRIVATE
    FFTW3::fftw3
  )
