# CMAKE generated file: DO NOT EDIT!
# Generated by "Unix Makefiles" Generator, CMake Version 3.25

# Delete rule output on recipe failure.
.DELETE_ON_ERROR:

#=============================================================================
# Special targets provided by cmake.

# Disable implicit rules so canonical targets will work.
.SUFFIXES:

# Disable VCS-based implicit rules.
% : %,v

# Disable VCS-based implicit rules.
% : RCS/%

# Disable VCS-based implicit rules.
% : RCS/%,v

# Disable VCS-based implicit rules.
% : SCCS/s.%

# Disable VCS-based implicit rules.
% : s.%

.SUFFIXES: .hpux_make_needs_suffix_list

# Command-line flag to silence nested $(MAKE).
$(VERBOSE)MAKESILENT = -s

#Suppress display of executed commands.
$(VERBOSE).SILENT:

# A target that is always out of date.
cmake_force:
.PHONY : cmake_force

#=============================================================================
# Set environment variables for the build.

# The shell in which to execute make rules.
SHELL = /bin/sh

# The CMake executable.
CMAKE_COMMAND = /Applications/CMake.app/Contents/bin/cmake

# The command to remove a file.
RM = /Applications/CMake.app/Contents/bin/cmake -E rm -f

# Escaping for special characters.
EQUALS = =

# The top-level source directory on which CMake was run.
CMAKE_SOURCE_DIR = /Users/sam/Downloads/littlesmalltalk-mac_gui

# The top-level build directory on which CMake was run.
CMAKE_BINARY_DIR = /Users/sam/Downloads/littlesmalltalk-mac_gui/build

# Utility rule file for baseimage.

# Include any custom commands dependencies for this target.
include CMakeFiles/baseimage.dir/compiler_depend.make

# Include the progress variables for this target.
include CMakeFiles/baseimage.dir/progress.make

CMakeFiles/baseimage:
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --blue --bold --progress-dir=/Users/sam/Downloads/littlesmalltalk-mac_gui/build/CMakeFiles --progress-num=$(CMAKE_PROGRESS_1) "Bootstrapping initial image file."
	/Users/sam/Downloads/littlesmalltalk-mac_gui/build/bootstrap -v /Users/sam/Downloads/littlesmalltalk-mac_gui/src/smalltalk/system/lst.st -o /Users/sam/Downloads/littlesmalltalk-mac_gui/build/lst_repl.img
	cp /Users/sam/Downloads/littlesmalltalk-mac_gui/build/lst_repl.img /Users/sam/Downloads/littlesmalltalk-mac_gui/build/lst.img

baseimage: CMakeFiles/baseimage
baseimage: CMakeFiles/baseimage.dir/build.make
.PHONY : baseimage

# Rule to build all files generated by this target.
CMakeFiles/baseimage.dir/build: baseimage
.PHONY : CMakeFiles/baseimage.dir/build

CMakeFiles/baseimage.dir/clean:
	$(CMAKE_COMMAND) -P CMakeFiles/baseimage.dir/cmake_clean.cmake
.PHONY : CMakeFiles/baseimage.dir/clean

CMakeFiles/baseimage.dir/depend:
	cd /Users/sam/Downloads/littlesmalltalk-mac_gui/build && $(CMAKE_COMMAND) -E cmake_depends "Unix Makefiles" /Users/sam/Downloads/littlesmalltalk-mac_gui /Users/sam/Downloads/littlesmalltalk-mac_gui /Users/sam/Downloads/littlesmalltalk-mac_gui/build /Users/sam/Downloads/littlesmalltalk-mac_gui/build /Users/sam/Downloads/littlesmalltalk-mac_gui/build/CMakeFiles/baseimage.dir/DependInfo.cmake --color=$(COLOR)
.PHONY : CMakeFiles/baseimage.dir/depend

