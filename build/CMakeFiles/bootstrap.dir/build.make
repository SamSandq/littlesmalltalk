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

# Include any dependencies generated for this target.
include CMakeFiles/bootstrap.dir/depend.make
# Include any dependencies generated by the compiler for this target.
include CMakeFiles/bootstrap.dir/compiler_depend.make

# Include the progress variables for this target.
include CMakeFiles/bootstrap.dir/progress.make

# Include the compile flags for this target's objects.
include CMakeFiles/bootstrap.dir/flags.make

CMakeFiles/bootstrap.dir/src/bootstrap/bootstrap.c.o: CMakeFiles/bootstrap.dir/flags.make
CMakeFiles/bootstrap.dir/src/bootstrap/bootstrap.c.o: /Users/sam/Downloads/littlesmalltalk-mac_gui/src/bootstrap/bootstrap.c
CMakeFiles/bootstrap.dir/src/bootstrap/bootstrap.c.o: CMakeFiles/bootstrap.dir/compiler_depend.ts
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green --progress-dir=/Users/sam/Downloads/littlesmalltalk-mac_gui/build/CMakeFiles --progress-num=$(CMAKE_PROGRESS_1) "Building C object CMakeFiles/bootstrap.dir/src/bootstrap/bootstrap.c.o"
	/Library/Developer/CommandLineTools/usr/bin/cc $(C_DEFINES) $(C_INCLUDES) $(C_FLAGS) -MD -MT CMakeFiles/bootstrap.dir/src/bootstrap/bootstrap.c.o -MF CMakeFiles/bootstrap.dir/src/bootstrap/bootstrap.c.o.d -o CMakeFiles/bootstrap.dir/src/bootstrap/bootstrap.c.o -c /Users/sam/Downloads/littlesmalltalk-mac_gui/src/bootstrap/bootstrap.c

CMakeFiles/bootstrap.dir/src/bootstrap/bootstrap.c.i: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Preprocessing C source to CMakeFiles/bootstrap.dir/src/bootstrap/bootstrap.c.i"
	/Library/Developer/CommandLineTools/usr/bin/cc $(C_DEFINES) $(C_INCLUDES) $(C_FLAGS) -E /Users/sam/Downloads/littlesmalltalk-mac_gui/src/bootstrap/bootstrap.c > CMakeFiles/bootstrap.dir/src/bootstrap/bootstrap.c.i

CMakeFiles/bootstrap.dir/src/bootstrap/bootstrap.c.s: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Compiling C source to assembly CMakeFiles/bootstrap.dir/src/bootstrap/bootstrap.c.s"
	/Library/Developer/CommandLineTools/usr/bin/cc $(C_DEFINES) $(C_INCLUDES) $(C_FLAGS) -S /Users/sam/Downloads/littlesmalltalk-mac_gui/src/bootstrap/bootstrap.c -o CMakeFiles/bootstrap.dir/src/bootstrap/bootstrap.c.s

CMakeFiles/bootstrap.dir/src/vm/err.c.o: CMakeFiles/bootstrap.dir/flags.make
CMakeFiles/bootstrap.dir/src/vm/err.c.o: /Users/sam/Downloads/littlesmalltalk-mac_gui/src/vm/err.c
CMakeFiles/bootstrap.dir/src/vm/err.c.o: CMakeFiles/bootstrap.dir/compiler_depend.ts
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green --progress-dir=/Users/sam/Downloads/littlesmalltalk-mac_gui/build/CMakeFiles --progress-num=$(CMAKE_PROGRESS_2) "Building C object CMakeFiles/bootstrap.dir/src/vm/err.c.o"
	/Library/Developer/CommandLineTools/usr/bin/cc $(C_DEFINES) $(C_INCLUDES) $(C_FLAGS) -MD -MT CMakeFiles/bootstrap.dir/src/vm/err.c.o -MF CMakeFiles/bootstrap.dir/src/vm/err.c.o.d -o CMakeFiles/bootstrap.dir/src/vm/err.c.o -c /Users/sam/Downloads/littlesmalltalk-mac_gui/src/vm/err.c

CMakeFiles/bootstrap.dir/src/vm/err.c.i: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Preprocessing C source to CMakeFiles/bootstrap.dir/src/vm/err.c.i"
	/Library/Developer/CommandLineTools/usr/bin/cc $(C_DEFINES) $(C_INCLUDES) $(C_FLAGS) -E /Users/sam/Downloads/littlesmalltalk-mac_gui/src/vm/err.c > CMakeFiles/bootstrap.dir/src/vm/err.c.i

CMakeFiles/bootstrap.dir/src/vm/err.c.s: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Compiling C source to assembly CMakeFiles/bootstrap.dir/src/vm/err.c.s"
	/Library/Developer/CommandLineTools/usr/bin/cc $(C_DEFINES) $(C_INCLUDES) $(C_FLAGS) -S /Users/sam/Downloads/littlesmalltalk-mac_gui/src/vm/err.c -o CMakeFiles/bootstrap.dir/src/vm/err.c.s

CMakeFiles/bootstrap.dir/src/vm/globals.c.o: CMakeFiles/bootstrap.dir/flags.make
CMakeFiles/bootstrap.dir/src/vm/globals.c.o: /Users/sam/Downloads/littlesmalltalk-mac_gui/src/vm/globals.c
CMakeFiles/bootstrap.dir/src/vm/globals.c.o: CMakeFiles/bootstrap.dir/compiler_depend.ts
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green --progress-dir=/Users/sam/Downloads/littlesmalltalk-mac_gui/build/CMakeFiles --progress-num=$(CMAKE_PROGRESS_3) "Building C object CMakeFiles/bootstrap.dir/src/vm/globals.c.o"
	/Library/Developer/CommandLineTools/usr/bin/cc $(C_DEFINES) $(C_INCLUDES) $(C_FLAGS) -MD -MT CMakeFiles/bootstrap.dir/src/vm/globals.c.o -MF CMakeFiles/bootstrap.dir/src/vm/globals.c.o.d -o CMakeFiles/bootstrap.dir/src/vm/globals.c.o -c /Users/sam/Downloads/littlesmalltalk-mac_gui/src/vm/globals.c

CMakeFiles/bootstrap.dir/src/vm/globals.c.i: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Preprocessing C source to CMakeFiles/bootstrap.dir/src/vm/globals.c.i"
	/Library/Developer/CommandLineTools/usr/bin/cc $(C_DEFINES) $(C_INCLUDES) $(C_FLAGS) -E /Users/sam/Downloads/littlesmalltalk-mac_gui/src/vm/globals.c > CMakeFiles/bootstrap.dir/src/vm/globals.c.i

CMakeFiles/bootstrap.dir/src/vm/globals.c.s: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Compiling C source to assembly CMakeFiles/bootstrap.dir/src/vm/globals.c.s"
	/Library/Developer/CommandLineTools/usr/bin/cc $(C_DEFINES) $(C_INCLUDES) $(C_FLAGS) -S /Users/sam/Downloads/littlesmalltalk-mac_gui/src/vm/globals.c -o CMakeFiles/bootstrap.dir/src/vm/globals.c.s

CMakeFiles/bootstrap.dir/src/vm/image.c.o: CMakeFiles/bootstrap.dir/flags.make
CMakeFiles/bootstrap.dir/src/vm/image.c.o: /Users/sam/Downloads/littlesmalltalk-mac_gui/src/vm/image.c
CMakeFiles/bootstrap.dir/src/vm/image.c.o: CMakeFiles/bootstrap.dir/compiler_depend.ts
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green --progress-dir=/Users/sam/Downloads/littlesmalltalk-mac_gui/build/CMakeFiles --progress-num=$(CMAKE_PROGRESS_4) "Building C object CMakeFiles/bootstrap.dir/src/vm/image.c.o"
	/Library/Developer/CommandLineTools/usr/bin/cc $(C_DEFINES) $(C_INCLUDES) $(C_FLAGS) -MD -MT CMakeFiles/bootstrap.dir/src/vm/image.c.o -MF CMakeFiles/bootstrap.dir/src/vm/image.c.o.d -o CMakeFiles/bootstrap.dir/src/vm/image.c.o -c /Users/sam/Downloads/littlesmalltalk-mac_gui/src/vm/image.c

CMakeFiles/bootstrap.dir/src/vm/image.c.i: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Preprocessing C source to CMakeFiles/bootstrap.dir/src/vm/image.c.i"
	/Library/Developer/CommandLineTools/usr/bin/cc $(C_DEFINES) $(C_INCLUDES) $(C_FLAGS) -E /Users/sam/Downloads/littlesmalltalk-mac_gui/src/vm/image.c > CMakeFiles/bootstrap.dir/src/vm/image.c.i

CMakeFiles/bootstrap.dir/src/vm/image.c.s: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Compiling C source to assembly CMakeFiles/bootstrap.dir/src/vm/image.c.s"
	/Library/Developer/CommandLineTools/usr/bin/cc $(C_DEFINES) $(C_INCLUDES) $(C_FLAGS) -S /Users/sam/Downloads/littlesmalltalk-mac_gui/src/vm/image.c -o CMakeFiles/bootstrap.dir/src/vm/image.c.s

CMakeFiles/bootstrap.dir/src/vm/interp.c.o: CMakeFiles/bootstrap.dir/flags.make
CMakeFiles/bootstrap.dir/src/vm/interp.c.o: /Users/sam/Downloads/littlesmalltalk-mac_gui/src/vm/interp.c
CMakeFiles/bootstrap.dir/src/vm/interp.c.o: CMakeFiles/bootstrap.dir/compiler_depend.ts
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green --progress-dir=/Users/sam/Downloads/littlesmalltalk-mac_gui/build/CMakeFiles --progress-num=$(CMAKE_PROGRESS_5) "Building C object CMakeFiles/bootstrap.dir/src/vm/interp.c.o"
	/Library/Developer/CommandLineTools/usr/bin/cc $(C_DEFINES) $(C_INCLUDES) $(C_FLAGS) -MD -MT CMakeFiles/bootstrap.dir/src/vm/interp.c.o -MF CMakeFiles/bootstrap.dir/src/vm/interp.c.o.d -o CMakeFiles/bootstrap.dir/src/vm/interp.c.o -c /Users/sam/Downloads/littlesmalltalk-mac_gui/src/vm/interp.c

CMakeFiles/bootstrap.dir/src/vm/interp.c.i: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Preprocessing C source to CMakeFiles/bootstrap.dir/src/vm/interp.c.i"
	/Library/Developer/CommandLineTools/usr/bin/cc $(C_DEFINES) $(C_INCLUDES) $(C_FLAGS) -E /Users/sam/Downloads/littlesmalltalk-mac_gui/src/vm/interp.c > CMakeFiles/bootstrap.dir/src/vm/interp.c.i

CMakeFiles/bootstrap.dir/src/vm/interp.c.s: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Compiling C source to assembly CMakeFiles/bootstrap.dir/src/vm/interp.c.s"
	/Library/Developer/CommandLineTools/usr/bin/cc $(C_DEFINES) $(C_INCLUDES) $(C_FLAGS) -S /Users/sam/Downloads/littlesmalltalk-mac_gui/src/vm/interp.c -o CMakeFiles/bootstrap.dir/src/vm/interp.c.s

CMakeFiles/bootstrap.dir/src/vm/memory.c.o: CMakeFiles/bootstrap.dir/flags.make
CMakeFiles/bootstrap.dir/src/vm/memory.c.o: /Users/sam/Downloads/littlesmalltalk-mac_gui/src/vm/memory.c
CMakeFiles/bootstrap.dir/src/vm/memory.c.o: CMakeFiles/bootstrap.dir/compiler_depend.ts
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green --progress-dir=/Users/sam/Downloads/littlesmalltalk-mac_gui/build/CMakeFiles --progress-num=$(CMAKE_PROGRESS_6) "Building C object CMakeFiles/bootstrap.dir/src/vm/memory.c.o"
	/Library/Developer/CommandLineTools/usr/bin/cc $(C_DEFINES) $(C_INCLUDES) $(C_FLAGS) -MD -MT CMakeFiles/bootstrap.dir/src/vm/memory.c.o -MF CMakeFiles/bootstrap.dir/src/vm/memory.c.o.d -o CMakeFiles/bootstrap.dir/src/vm/memory.c.o -c /Users/sam/Downloads/littlesmalltalk-mac_gui/src/vm/memory.c

CMakeFiles/bootstrap.dir/src/vm/memory.c.i: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Preprocessing C source to CMakeFiles/bootstrap.dir/src/vm/memory.c.i"
	/Library/Developer/CommandLineTools/usr/bin/cc $(C_DEFINES) $(C_INCLUDES) $(C_FLAGS) -E /Users/sam/Downloads/littlesmalltalk-mac_gui/src/vm/memory.c > CMakeFiles/bootstrap.dir/src/vm/memory.c.i

CMakeFiles/bootstrap.dir/src/vm/memory.c.s: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Compiling C source to assembly CMakeFiles/bootstrap.dir/src/vm/memory.c.s"
	/Library/Developer/CommandLineTools/usr/bin/cc $(C_DEFINES) $(C_INCLUDES) $(C_FLAGS) -S /Users/sam/Downloads/littlesmalltalk-mac_gui/src/vm/memory.c -o CMakeFiles/bootstrap.dir/src/vm/memory.c.s

CMakeFiles/bootstrap.dir/src/vm/prim.c.o: CMakeFiles/bootstrap.dir/flags.make
CMakeFiles/bootstrap.dir/src/vm/prim.c.o: /Users/sam/Downloads/littlesmalltalk-mac_gui/src/vm/prim.c
CMakeFiles/bootstrap.dir/src/vm/prim.c.o: CMakeFiles/bootstrap.dir/compiler_depend.ts
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green --progress-dir=/Users/sam/Downloads/littlesmalltalk-mac_gui/build/CMakeFiles --progress-num=$(CMAKE_PROGRESS_7) "Building C object CMakeFiles/bootstrap.dir/src/vm/prim.c.o"
	/Library/Developer/CommandLineTools/usr/bin/cc $(C_DEFINES) $(C_INCLUDES) $(C_FLAGS) -MD -MT CMakeFiles/bootstrap.dir/src/vm/prim.c.o -MF CMakeFiles/bootstrap.dir/src/vm/prim.c.o.d -o CMakeFiles/bootstrap.dir/src/vm/prim.c.o -c /Users/sam/Downloads/littlesmalltalk-mac_gui/src/vm/prim.c

CMakeFiles/bootstrap.dir/src/vm/prim.c.i: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Preprocessing C source to CMakeFiles/bootstrap.dir/src/vm/prim.c.i"
	/Library/Developer/CommandLineTools/usr/bin/cc $(C_DEFINES) $(C_INCLUDES) $(C_FLAGS) -E /Users/sam/Downloads/littlesmalltalk-mac_gui/src/vm/prim.c > CMakeFiles/bootstrap.dir/src/vm/prim.c.i

CMakeFiles/bootstrap.dir/src/vm/prim.c.s: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Compiling C source to assembly CMakeFiles/bootstrap.dir/src/vm/prim.c.s"
	/Library/Developer/CommandLineTools/usr/bin/cc $(C_DEFINES) $(C_INCLUDES) $(C_FLAGS) -S /Users/sam/Downloads/littlesmalltalk-mac_gui/src/vm/prim.c -o CMakeFiles/bootstrap.dir/src/vm/prim.c.s

CMakeFiles/bootstrap.dir/src/vm/mac_prims.c.o: CMakeFiles/bootstrap.dir/flags.make
CMakeFiles/bootstrap.dir/src/vm/mac_prims.c.o: /Users/sam/Downloads/littlesmalltalk-mac_gui/src/vm/mac_prims.c
CMakeFiles/bootstrap.dir/src/vm/mac_prims.c.o: CMakeFiles/bootstrap.dir/compiler_depend.ts
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green --progress-dir=/Users/sam/Downloads/littlesmalltalk-mac_gui/build/CMakeFiles --progress-num=$(CMAKE_PROGRESS_8) "Building C object CMakeFiles/bootstrap.dir/src/vm/mac_prims.c.o"
	/Library/Developer/CommandLineTools/usr/bin/cc $(C_DEFINES) $(C_INCLUDES) $(C_FLAGS) -MD -MT CMakeFiles/bootstrap.dir/src/vm/mac_prims.c.o -MF CMakeFiles/bootstrap.dir/src/vm/mac_prims.c.o.d -o CMakeFiles/bootstrap.dir/src/vm/mac_prims.c.o -c /Users/sam/Downloads/littlesmalltalk-mac_gui/src/vm/mac_prims.c

CMakeFiles/bootstrap.dir/src/vm/mac_prims.c.i: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Preprocessing C source to CMakeFiles/bootstrap.dir/src/vm/mac_prims.c.i"
	/Library/Developer/CommandLineTools/usr/bin/cc $(C_DEFINES) $(C_INCLUDES) $(C_FLAGS) -E /Users/sam/Downloads/littlesmalltalk-mac_gui/src/vm/mac_prims.c > CMakeFiles/bootstrap.dir/src/vm/mac_prims.c.i

CMakeFiles/bootstrap.dir/src/vm/mac_prims.c.s: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Compiling C source to assembly CMakeFiles/bootstrap.dir/src/vm/mac_prims.c.s"
	/Library/Developer/CommandLineTools/usr/bin/cc $(C_DEFINES) $(C_INCLUDES) $(C_FLAGS) -S /Users/sam/Downloads/littlesmalltalk-mac_gui/src/vm/mac_prims.c -o CMakeFiles/bootstrap.dir/src/vm/mac_prims.c.s

CMakeFiles/bootstrap.dir/src/vm/mac_gui.m.o: CMakeFiles/bootstrap.dir/flags.make
CMakeFiles/bootstrap.dir/src/vm/mac_gui.m.o: /Users/sam/Downloads/littlesmalltalk-mac_gui/src/vm/mac_gui.m
CMakeFiles/bootstrap.dir/src/vm/mac_gui.m.o: CMakeFiles/bootstrap.dir/compiler_depend.ts
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green --progress-dir=/Users/sam/Downloads/littlesmalltalk-mac_gui/build/CMakeFiles --progress-num=$(CMAKE_PROGRESS_9) "Building C object CMakeFiles/bootstrap.dir/src/vm/mac_gui.m.o"
	/Library/Developer/CommandLineTools/usr/bin/cc $(C_DEFINES) $(C_INCLUDES) $(C_FLAGS) -MD -MT CMakeFiles/bootstrap.dir/src/vm/mac_gui.m.o -MF CMakeFiles/bootstrap.dir/src/vm/mac_gui.m.o.d -o CMakeFiles/bootstrap.dir/src/vm/mac_gui.m.o -c /Users/sam/Downloads/littlesmalltalk-mac_gui/src/vm/mac_gui.m

CMakeFiles/bootstrap.dir/src/vm/mac_gui.m.i: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Preprocessing C source to CMakeFiles/bootstrap.dir/src/vm/mac_gui.m.i"
	/Library/Developer/CommandLineTools/usr/bin/cc $(C_DEFINES) $(C_INCLUDES) $(C_FLAGS) -E /Users/sam/Downloads/littlesmalltalk-mac_gui/src/vm/mac_gui.m > CMakeFiles/bootstrap.dir/src/vm/mac_gui.m.i

CMakeFiles/bootstrap.dir/src/vm/mac_gui.m.s: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Compiling C source to assembly CMakeFiles/bootstrap.dir/src/vm/mac_gui.m.s"
	/Library/Developer/CommandLineTools/usr/bin/cc $(C_DEFINES) $(C_INCLUDES) $(C_FLAGS) -S /Users/sam/Downloads/littlesmalltalk-mac_gui/src/vm/mac_gui.m -o CMakeFiles/bootstrap.dir/src/vm/mac_gui.m.s

# Object files for target bootstrap
bootstrap_OBJECTS = \
"CMakeFiles/bootstrap.dir/src/bootstrap/bootstrap.c.o" \
"CMakeFiles/bootstrap.dir/src/vm/err.c.o" \
"CMakeFiles/bootstrap.dir/src/vm/globals.c.o" \
"CMakeFiles/bootstrap.dir/src/vm/image.c.o" \
"CMakeFiles/bootstrap.dir/src/vm/interp.c.o" \
"CMakeFiles/bootstrap.dir/src/vm/memory.c.o" \
"CMakeFiles/bootstrap.dir/src/vm/prim.c.o" \
"CMakeFiles/bootstrap.dir/src/vm/mac_prims.c.o" \
"CMakeFiles/bootstrap.dir/src/vm/mac_gui.m.o"

# External object files for target bootstrap
bootstrap_EXTERNAL_OBJECTS =

bootstrap: CMakeFiles/bootstrap.dir/src/bootstrap/bootstrap.c.o
bootstrap: CMakeFiles/bootstrap.dir/src/vm/err.c.o
bootstrap: CMakeFiles/bootstrap.dir/src/vm/globals.c.o
bootstrap: CMakeFiles/bootstrap.dir/src/vm/image.c.o
bootstrap: CMakeFiles/bootstrap.dir/src/vm/interp.c.o
bootstrap: CMakeFiles/bootstrap.dir/src/vm/memory.c.o
bootstrap: CMakeFiles/bootstrap.dir/src/vm/prim.c.o
bootstrap: CMakeFiles/bootstrap.dir/src/vm/mac_prims.c.o
bootstrap: CMakeFiles/bootstrap.dir/src/vm/mac_gui.m.o
bootstrap: CMakeFiles/bootstrap.dir/build.make
bootstrap: CMakeFiles/bootstrap.dir/link.txt
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green --bold --progress-dir=/Users/sam/Downloads/littlesmalltalk-mac_gui/build/CMakeFiles --progress-num=$(CMAKE_PROGRESS_10) "Linking C executable bootstrap"
	$(CMAKE_COMMAND) -E cmake_link_script CMakeFiles/bootstrap.dir/link.txt --verbose=$(VERBOSE)

# Rule to build all files generated by this target.
CMakeFiles/bootstrap.dir/build: bootstrap
.PHONY : CMakeFiles/bootstrap.dir/build

CMakeFiles/bootstrap.dir/clean:
	$(CMAKE_COMMAND) -P CMakeFiles/bootstrap.dir/cmake_clean.cmake
.PHONY : CMakeFiles/bootstrap.dir/clean

CMakeFiles/bootstrap.dir/depend:
	cd /Users/sam/Downloads/littlesmalltalk-mac_gui/build && $(CMAKE_COMMAND) -E cmake_depends "Unix Makefiles" /Users/sam/Downloads/littlesmalltalk-mac_gui /Users/sam/Downloads/littlesmalltalk-mac_gui /Users/sam/Downloads/littlesmalltalk-mac_gui/build /Users/sam/Downloads/littlesmalltalk-mac_gui/build /Users/sam/Downloads/littlesmalltalk-mac_gui/build/CMakeFiles/bootstrap.dir/DependInfo.cmake --color=$(COLOR)
.PHONY : CMakeFiles/bootstrap.dir/depend

