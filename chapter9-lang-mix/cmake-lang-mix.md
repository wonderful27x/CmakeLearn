# 第9章 语言混合项目

本章的主要内容如下：

* 使用C/C++库构建Fortran项目
* 使用Fortran库构建C/C++项目
* 使用Cython构建C++和Python项目
* 使用Boost.Python构建C++和Python项目
* 使用pybind11构建C++和Python项目
* 使用Python CFFI混合C，C++，Fortran和Python

有很多的库比较适合特定领域的任务。我们的库直接使用这些专业库，是一中快捷的方式，这样就可以使用来自其他专家组的多年经验进行开发。随着计算机体系结构和编译器的发展，编程语言也在不断发展。几年前，大多数科学软件都是用Fortran语言编写的，而现在，C、C++和解释语言——Python——正占据着语言中心舞台。将编译语言代码与解释语言的代码集成在一起，变得确实越来越普遍，这样做有以下好处:

* 用户可以需要进行定制和扩展功能，以满足需求。
* 可以将Python等语言的表达能力与编译语言的性能结合起来，后者在内存寻址方面效率接近于极致，达到两全其美的目的。

正如我们之前的示例中展示的那样，可以使用`project`命令通过`LANGUAGES`关键字设置项目中使用的语言。CMake支持许多(但不是所有)编译的编程语言。从CMake 3.5开始，各种风格的汇编(如ASM-ATT，ASM，ASM-MASM和ASM- NASM)、C、C++、Fortran、Java、RC (Windows资源编译器)和Swift都可以选择。CMake 3.8增加了对另外两种语言的支持：C#和CUDA(请参阅发布说明:https://cmake.org/cmake/help/v3.8/release/3.8.html#languages )。

本章中，我们将展示如何以一种可移植且跨平台的方式集成用不同编译(C、C++和Fortran)和解释语言(Python)编写的代码。我们将展示如何利用CMake和一些工具集成不同编程语言。

## 关键知识

### 库保存目录
设置将静态库和动态库保存在build目录下的lib目录中。可执行文件保存在bin目录下，Fortran编译模块文件保存在modules目录下:
```
set(CMAKE_ARCHIVE_OUTPUT_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}/lib)
set(CMAKE_LIBRARY_OUTPUT_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}/lib)
set(CMAKE_RUNTIME_OUTPUT_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}/bin)
set(CMAKE_Fortran_MODULE_DIRECTORY
${CMAKE_CURRENT_BINARY_DIR}/modules)
```
使用GNUInstallDirs模块来设置CMake将静态和动态库，以及可执行文件保存的标准目录。我们还指示CMake将Fortran编译的模块文件放在modules目录下:
```
include(GNUInstallDirs)
set(CMAKE_ARCHIVE_OUTPUT_DIRECTORY
	${CMAKE_BINARY_DIR}/${CMAKE_INSTALL_LIBDIR})
set(CMAKE_LIBRARY_OUTPUT_DIRECTORY
	${CMAKE_BINARY_DIR}/${CMAKE_INSTALL_LIBDIR})
set(CMAKE_RUNTIME_OUTPUT_DIRECTORY
	${CMAKE_BINARY_DIR}/${CMAKE_INSTALL_BINDIR})
set(CMAKE_Fortran_MODULE_DIRECTORY ${PROJECT_BINARY_DIR}/modules)
```

### FortranCInterface: 检查所选C编译器与Fortran编译器的兼容性
```
target_sources(bt-randomgen-wrap
  PRIVATE
    interface_backtrace.f90
    interface_randomgen.f90
    randomgen.c
  )
```

### FortranCInterface_HEADER函数生成带有宏的头文件，以处理Fortran子例程的名称混乱
```
FortranCInterface_HEADER(
  fc_mangle.h
  MACRO_NAMESPACE "FC_"
  SYMBOLS DSCAL DGESV
)
```

### 混合语言的编译器连接器问题
```
target_sources(bt-randomgen-wrap
  PRIVATE
    interface_backtrace.f90
    interface_randomgen.f90
    randomgen.c
  )
```
CMake可以使用不同语言的源文件创建库。CMake能够做到以下几点:  
* 列出的源文件中获取目标文件，并识别要使用哪个编译器。  
* 选择适当的链接器，以便构建库(或可执行文件)。  

CMake如何决定使用哪个编译器？在project命令时使用参数LANGUAGES指定，这样CMake会检查系统上给定语言编译器。当使用源文件列表添加目标时，CMake将根据文件扩展名选择适当地编译器。因此，以.c结尾的文件使用C编译器编译，而以.f90结尾的文件将使用Fortran编译器编译。类似地，对于C++， .cpp或.cxx扩展将触发C++编译器。源文件属性可以用来告诉CMake在特定的源文件上使用哪个编译器:
```
set_source_files_properties(my_source_file.axx
  PROPERTIES
  	LANGUAGE CXX
  )
```
那链接器呢？CMake如何确定目标的链接器语言？如果目标混合了多个语言，则根据在语言混合中，优先级最高的语言来选择链接器语言。比如，我们的示例中混合了Fortran和C，因此Fortran语言比C语言具有更高的优先级，因此使用Fortran用作链接器语言。我们可以通过目标相应的LINKER_LANGUAGE属性，强制CMake为我们的目标使用特定的链接器语言:
```
set_target_properties(my_target
  PROPERTIES
  	LINKER_LANGUAGE Fortran
  )
```

### MODULE库
MODULE选项将生成一个插件库，也就是动态共享对象(DSO)，没有动态链接到任何可执行文件，但是仍然可以在运行时加载。由于我们使用C++来扩展Python，所以Python解释器需要能够在运行时加载我们的库。使用MODULE选项进行add_library，可以避免系统在库名前添加前缀(例如：Unix系统上的lib)。后一项操作是通过设置适当的目标属性来执行的，如下所示:
```
set_target_properties(account
  PROPERTIES
  	PREFIX ""
  )
```

### GenerateExportHeader
ACCOUNT_API定义在account_export.h中
```
include(GenerateExportHeader)
generate_export_header(account
  BASE_NAME account
  )
```
account_export.h头文件定义了接口函数的可见性，并确保这是以一种可移植的方式完成的
