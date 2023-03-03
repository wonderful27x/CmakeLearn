# the name of the target operating system
# 设置目标系统，即要在什么系统上运行
set(CMAKE_SYSTEM_NAME Windows)

# which compilers to use
# 指定编译器
set(CMAKE_C_COMPILER i686-w64-mingw32-gcc)
set(CMAKE_CXX_COMPILER i686-w64-mingw32-g++)
set(CMAKE_Fortran_COMPILER i686-w64-mingw32-gfortran)

# here is the target environment located
# 这个例子中，我们不需要检测任何库或头文件。如果必要的话，我们将使用以下命令指定根路径:
#set(CMAKE_FIND_ROOT_PATH /path/to/target/environment)

# adjust the default behaviour of the find commands:
# search headers and libraries in the target environment
# 最后，调整find命令的默认行为。我们指示CMake在目标环境中查找头文件和库文件:
set(CMAKE_FIND_ROOT_PATH_MODE_INCLUDE ONLY)
set(CMAKE_FIND_ROOT_PATH_MODE_LIBRARY ONLY)
# search programs in the host environment
# 在主机环境中的搜索程序：
set(CMAKE_FIND_ROOT_PATH_MODE_PROGRAM NEVER)

