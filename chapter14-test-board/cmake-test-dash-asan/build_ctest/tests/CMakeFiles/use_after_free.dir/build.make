# CMAKE generated file: DO NOT EDIT!
# Generated by "Unix Makefiles" Generator, CMake Version 3.16

# Delete rule output on recipe failure.
.DELETE_ON_ERROR:


#=============================================================================
# Special targets provided by cmake.

# Disable implicit rules so canonical targets will work.
.SUFFIXES:


# Remove some rules from gmake that .SUFFIXES does not remove.
SUFFIXES =

.SUFFIXES: .hpux_make_needs_suffix_list


# Suppress display of executed commands.
$(VERBOSE).SILENT:


# A target that is always out of date.
cmake_force:

.PHONY : cmake_force

#=============================================================================
# Set environment variables for the build.

# The shell in which to execute make rules.
SHELL = /bin/sh

# The CMake executable.
CMAKE_COMMAND = /usr/bin/cmake

# The command to remove a file.
RM = /usr/bin/cmake -E remove -f

# Escaping for special characters.
EQUALS = =

# The top-level source directory on which CMake was run.
CMAKE_SOURCE_DIR = /mnt/e/wonderful/LEARN/cmake/cmake-code/chapter14-test-board/cmake-test-dash-asan

# The top-level build directory on which CMake was run.
CMAKE_BINARY_DIR = /mnt/e/wonderful/LEARN/cmake/cmake-code/chapter14-test-board/cmake-test-dash-asan/build_ctest

# Include any dependencies generated for this target.
include tests/CMakeFiles/use_after_free.dir/depend.make

# Include the progress variables for this target.
include tests/CMakeFiles/use_after_free.dir/progress.make

# Include the compile flags for this target's objects.
include tests/CMakeFiles/use_after_free.dir/flags.make

tests/CMakeFiles/use_after_free.dir/use_after_free.cpp.o: tests/CMakeFiles/use_after_free.dir/flags.make
tests/CMakeFiles/use_after_free.dir/use_after_free.cpp.o: ../tests/use_after_free.cpp
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green --progress-dir=/mnt/e/wonderful/LEARN/cmake/cmake-code/chapter14-test-board/cmake-test-dash-asan/build_ctest/CMakeFiles --progress-num=$(CMAKE_PROGRESS_1) "Building CXX object tests/CMakeFiles/use_after_free.dir/use_after_free.cpp.o"
	cd /mnt/e/wonderful/LEARN/cmake/cmake-code/chapter14-test-board/cmake-test-dash-asan/build_ctest/tests && /usr/bin/c++  $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -o CMakeFiles/use_after_free.dir/use_after_free.cpp.o -c /mnt/e/wonderful/LEARN/cmake/cmake-code/chapter14-test-board/cmake-test-dash-asan/tests/use_after_free.cpp

tests/CMakeFiles/use_after_free.dir/use_after_free.cpp.i: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Preprocessing CXX source to CMakeFiles/use_after_free.dir/use_after_free.cpp.i"
	cd /mnt/e/wonderful/LEARN/cmake/cmake-code/chapter14-test-board/cmake-test-dash-asan/build_ctest/tests && /usr/bin/c++ $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -E /mnt/e/wonderful/LEARN/cmake/cmake-code/chapter14-test-board/cmake-test-dash-asan/tests/use_after_free.cpp > CMakeFiles/use_after_free.dir/use_after_free.cpp.i

tests/CMakeFiles/use_after_free.dir/use_after_free.cpp.s: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Compiling CXX source to assembly CMakeFiles/use_after_free.dir/use_after_free.cpp.s"
	cd /mnt/e/wonderful/LEARN/cmake/cmake-code/chapter14-test-board/cmake-test-dash-asan/build_ctest/tests && /usr/bin/c++ $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -S /mnt/e/wonderful/LEARN/cmake/cmake-code/chapter14-test-board/cmake-test-dash-asan/tests/use_after_free.cpp -o CMakeFiles/use_after_free.dir/use_after_free.cpp.s

# Object files for target use_after_free
use_after_free_OBJECTS = \
"CMakeFiles/use_after_free.dir/use_after_free.cpp.o"

# External object files for target use_after_free
use_after_free_EXTERNAL_OBJECTS =

tests/use_after_free: tests/CMakeFiles/use_after_free.dir/use_after_free.cpp.o
tests/use_after_free: tests/CMakeFiles/use_after_free.dir/build.make
tests/use_after_free: src/libbuggy.a
tests/use_after_free: tests/CMakeFiles/use_after_free.dir/link.txt
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green --bold --progress-dir=/mnt/e/wonderful/LEARN/cmake/cmake-code/chapter14-test-board/cmake-test-dash-asan/build_ctest/CMakeFiles --progress-num=$(CMAKE_PROGRESS_2) "Linking CXX executable use_after_free"
	cd /mnt/e/wonderful/LEARN/cmake/cmake-code/chapter14-test-board/cmake-test-dash-asan/build_ctest/tests && $(CMAKE_COMMAND) -E cmake_link_script CMakeFiles/use_after_free.dir/link.txt --verbose=$(VERBOSE)

# Rule to build all files generated by this target.
tests/CMakeFiles/use_after_free.dir/build: tests/use_after_free

.PHONY : tests/CMakeFiles/use_after_free.dir/build

tests/CMakeFiles/use_after_free.dir/clean:
	cd /mnt/e/wonderful/LEARN/cmake/cmake-code/chapter14-test-board/cmake-test-dash-asan/build_ctest/tests && $(CMAKE_COMMAND) -P CMakeFiles/use_after_free.dir/cmake_clean.cmake
.PHONY : tests/CMakeFiles/use_after_free.dir/clean

tests/CMakeFiles/use_after_free.dir/depend:
	cd /mnt/e/wonderful/LEARN/cmake/cmake-code/chapter14-test-board/cmake-test-dash-asan/build_ctest && $(CMAKE_COMMAND) -E cmake_depends "Unix Makefiles" /mnt/e/wonderful/LEARN/cmake/cmake-code/chapter14-test-board/cmake-test-dash-asan /mnt/e/wonderful/LEARN/cmake/cmake-code/chapter14-test-board/cmake-test-dash-asan/tests /mnt/e/wonderful/LEARN/cmake/cmake-code/chapter14-test-board/cmake-test-dash-asan/build_ctest /mnt/e/wonderful/LEARN/cmake/cmake-code/chapter14-test-board/cmake-test-dash-asan/build_ctest/tests /mnt/e/wonderful/LEARN/cmake/cmake-code/chapter14-test-board/cmake-test-dash-asan/build_ctest/tests/CMakeFiles/use_after_free.dir/DependInfo.cmake --color=$(COLOR)
.PHONY : tests/CMakeFiles/use_after_free.dir/depend
