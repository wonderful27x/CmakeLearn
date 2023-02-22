cmake_minimum_required(VERSION 3.5 FATAL_ERROR)

project(recipe-01 LANGUAGES CXX)

set(CMAKE_CXX_STANDARD 11)
set(CMAKE_CXX_EXTENSIONS OFF)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

# 为当前目录底层目录设置EP_BASE目录属性
set_property(DIRECTORY PROPERTY EP_BASE ${CMAKE_BINARY_DIR}/subprojects)
message(STATUS "CMAKE_BINARY_DIR: ${CMAKE_BINARY_DIR}")

include(ExternalProject)

# 使用ExternalProject_Add函数将外部项目添加进来，
# 外部项目名叫${PROJECT_NAME}_core，它是一个完整cmake项目，它有project(xxx)语句
# SOURCE_DIR指定外部项目源目录
# CMAKE_ARGS将cmake选项传递给外部项目，这里传递了c++标准等
# CMAKE_CACHE_ARGS设置了编译器标志
# BUILD_ALWAYS保证外部项目每次都编译
# INSTALL_COMMAND设置安装操作，这里为空
# 最终外部项目被编译到build/subprojects中称为Build/recipe-01_core,这是EP_BASE指定的
# build/subprojects目录将包含如下目录
# Build
# Download
# Install
# Stamp
# Tmp

# ExternalProject_Add有许多选项，可用于微调外部项目的配置和编译的所有方面。这些选择可以分为以下几类:
# Directory：它们用于调优源码的结构，并为外部项目构建目录。本例中，我们使用SOURCE_DIR选项让CMake知道源文件在${CMAKE_CURRENT_LIST_DIR}/src文件夹中。用于构建项目和存储临时文件的目录，也可以在此类选项或目录属性中指定。通过设置EP_BASE目录属性，CMake将按照以下布局为各个子项目设置所有目录:
#    TMP_DIR = <EP_BASE>/tmp/<name>
#    STAMP_DIR = <EP_BASE>/Stamp/<name>
#    DOWNLOAD_DIR = <EP_BASE>/Download/<name>
#    SOURCE_DIR = <EP_BASE>/Source/<name>
#    BINARY_DIR = <EP_BASE>/Build/<name>
#    INSTALL_DIR = <EP_BASE>/Install/<name>
# Download：外部项目的代码可能需要从在线存储库或资源处下载。
# Update和Patch：可用于定义如何更新外部项目的源代码或如何应用补丁。
# Configure：默认情况下，CMake会假定外部项目是使用CMake配置的。如下面的示例所示，我们并不局限于这种情况。如果外部项目是CMake项目，ExternalProject_Add将调用CMake可执行文件，并传递选项。对于当前的示例，我们通过CMAKE_ARGS和CMAKE_CACHE_ARGS选项传递配置参数。前者作为命令行参数直接传递，而后者通过CMake脚本文件传递。示例中，脚本文件位于build/subprojects/tmp/recipe-01_core/recipe-01_core- cache-.cmake。然后，配置如以下所示:
#    $ cmake -DCMAKE_CXX_COMPILER=g++ -DCMAKE_CXX_STANDARD=11
#    -DCMAKE_CXX_EXTENSIONS=OFF -DCMAKE_CXX_STANDARD_REQUIRED=ON
#    -C/home/roberto/Workspace/robertodr/cmake-cookbook/chapter-08/recipe-01/cxx-example/build/subprojects/tmp/recipe-01_core/recipe-01_core-cache-.cmake "-GUnix Makefiles" /home/roberto/Workspace/robertodr/cmake-cookbook/chapter-08/recipe-01/cxx-example/src
# Build：可用于调整外部项目的实际编译。我们的示例使用BUILD_ALWAYS选项确保外部项目总会重新构建。
# Install：这些选项用于配置应该如何安装外部项目。我们的示例将INSTALL_COMMAND保留为空
# Test：为基于源代码构建的软件运行测试总是不错的想法。

# ExternalProject.cmake定义了ExternalProject_Get_Property命令，该命令对于检索外部项目的属性非常有用。外部项目的属性是在首次调用ExternalProject_Add命令时设置的。例如，在配置recipe-01_core时，检索要传递给CMake的参数可以通过以下方法实现:
# ExternalProject_Get_Property(${PROJECT_NAME}_core CMAKE_ARGS)
# message(STATUS "CMAKE_ARGS of ${PROJECT_NAME}_core ${CMAKE_ARGS}")
ExternalProject_Add(${PROJECT_NAME}_core
  SOURCE_DIR
    ${CMAKE_CURRENT_LIST_DIR}/src
  CMAKE_ARGS
    -DCMAKE_CXX_COMPILER=${CMAKE_CXX_COMPILER}
    -DCMAKE_CXX_STANDARD=${CMAKE_CXX_STANDARD}
    -DCMAKE_CXX_EXTENSIONS=${CMAKE_CXX_EXTENSIONS}
    -DCMAKE_CXX_STANDARD_REQUIRED=${CMAKE_CXX_STANDARD_REQUIRED}
  CMAKE_CACHE_ARGS
    -DCMAKE_CXX_FLAGS:STRING=${CMAKE_CXX_FLAGS}
  BUILD_ALWAYS
    1
  INSTALL_COMMAND
    ""
  )
