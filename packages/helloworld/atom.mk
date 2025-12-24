###############################################################################
## @file packages/helloworld/atom.mk
## @brief Hello World package for Dragonwing QCS6490
##
## This is a simple example module demonstrating how to create an
## executable package in the Alchemy build system.
##
###############################################################################

# Get the directory where this atom.mk file is located
LOCAL_PATH := $(call my-dir)

# Clear all LOCAL_* variables before defining a new module
include $(CLEAR_VARS)

#------------------------------------------------------------------------------
# Module Configuration
#------------------------------------------------------------------------------

# Module name (will be the executable name)
LOCAL_MODULE := helloworld

# Description for documentation
LOCAL_DESCRIPTION := Hello World example for QCS6490 board

# Category for organization
LOCAL_CATEGORY_PATH := examples

#------------------------------------------------------------------------------
# Source Files
#------------------------------------------------------------------------------

# List of source files to compile (relative to LOCAL_PATH)
LOCAL_SRC_FILES := \
    src/helloworld.c

#------------------------------------------------------------------------------
# Compilation Flags (optional)
#------------------------------------------------------------------------------

# Additional C compiler flags
LOCAL_CFLAGS := \
    -Wall \
    -Wextra \
    -Wpedantic

# Additional linker flags (if needed)
# LOCAL_LDFLAGS :=

# Additional libraries to link (if needed)
# LOCAL_LDLIBS := -lpthread

#------------------------------------------------------------------------------
# Dependencies (optional)
#------------------------------------------------------------------------------

# Other modules this module depends on
# LOCAL_LIBRARIES := some-library

# Header-only dependencies (not linked, only include paths)
# LOCAL_DEPENDS_HEADERS := some-header-only-lib

#------------------------------------------------------------------------------
# Installation
#------------------------------------------------------------------------------

# Destination directory (default is usr/bin for executables)
# LOCAL_DESTDIR := usr/bin

# Custom filename (default is module name)
# LOCAL_MODULE_FILENAME := helloworld

#------------------------------------------------------------------------------
# Build the executable
#------------------------------------------------------------------------------

include $(BUILD_EXECUTABLE)
