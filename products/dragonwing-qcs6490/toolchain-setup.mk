###############################################################################
## @file products/dragonwing-qcs6490/toolchain-setup.mk
## @brief Toolchain setup for Dragonwing QCS6490 (Qualcomm Yocto eSDK)
##
## This file configures the Qualcomm cross-compilation toolchain from the
## Yocto extensible SDK (eSDK) for the QCM6490 platform.
##
## Prerequisites:
##   1. Install the Qualcomm Yocto eSDK
##   2. Set QCOM_SDK_PATH environment variable or use default path
##
###############################################################################

# Qualcomm SDK root path (can be overridden via environment)
QCOM_SDK_PATH ?= $(HOME)/qcom-wayland_sdk

# Verify SDK exists
ifeq ("$(wildcard $(QCOM_SDK_PATH))","")
  $(error Qualcomm SDK not found at $(QCOM_SDK_PATH). Please install the eSDK or set QCOM_SDK_PATH)
endif

# SDK environment setup file
QCOM_ENV_FILE := $(QCOM_SDK_PATH)/environment-setup-armv8-2a-qcom-linux

ifeq ("$(wildcard $(QCOM_ENV_FILE))","")
  $(error SDK environment file not found: $(QCOM_ENV_FILE))
endif

# SDK sysroots
QCOM_SDK_TARGET_SYSROOT := $(QCOM_SDK_PATH)/tmp/sysroots/qcm6490-idp
QCOM_SDK_HOST_SYSROOT   := $(QCOM_SDK_PATH)/tmp/sysroots/x86_64

# Verify sysroots exist
ifeq ("$(wildcard $(QCOM_SDK_TARGET_SYSROOT))","")
  $(error Target sysroot not found: $(QCOM_SDK_TARGET_SYSROOT))
endif

# Cross-compiler toolchain path
QCOM_TOOLCHAIN_PATH := $(QCOM_SDK_HOST_SYSROOT)/usr/bin/aarch64-qcom-linux

# Cross-compiler prefix (full path)
TARGET_CROSS := $(QCOM_TOOLCHAIN_PATH)/aarch64-qcom-linux-

# Define toolchain triplet directly to avoid auto-detection issues
TARGET_TOOLCHAIN_TRIPLET := aarch64-qcom-linux

# Compiler tools (full paths)
TARGET_CC      := $(TARGET_CROSS)gcc
TARGET_CXX     := $(TARGET_CROSS)g++
TARGET_CPP     := $(TARGET_CROSS)gcc -E
TARGET_AS      := $(TARGET_CROSS)as
TARGET_LD      := $(TARGET_CROSS)ld
TARGET_STRIP   := $(TARGET_CROSS)strip
TARGET_RANLIB  := $(TARGET_CROSS)ranlib
TARGET_OBJCOPY := $(TARGET_CROSS)objcopy
TARGET_OBJDUMP := $(TARGET_CROSS)objdump
TARGET_AR      := $(TARGET_CROSS)ar
TARGET_NM      := $(TARGET_CROSS)nm
TARGET_READELF := $(TARGET_CROSS)readelf

# Architecture-specific flags for ARMv8.2-A (Qualcomm Kryo cores)
QCOM_ARCH_FLAGS := \
    -march=armv8.2-a+crypto \
    -mbranch-protection=standard

# Security hardening flags (from Qualcomm SDK)
QCOM_SECURITY_FLAGS := \
    -fstack-protector-strong \
    -D_FORTIFY_SOURCE=2 \
    -Wformat \
    -Wformat-security \
    -Werror=format-security

# Optimization flags
QCOM_OPT_FLAGS := -O2 -pipe -g -feliminate-unused-debug-types

# Sysroot flag
QCOM_SYSROOT_FLAG := --sysroot=$(QCOM_SDK_TARGET_SYSROOT)

# Global C flags
TARGET_GLOBAL_CFLAGS += \
    $(QCOM_ARCH_FLAGS) \
    $(QCOM_SECURITY_FLAGS) \
    $(QCOM_OPT_FLAGS) \
    $(QCOM_SYSROOT_FLAG)

# Global C++ flags (inherit C flags)
TARGET_GLOBAL_CXXFLAGS += \
    $(QCOM_ARCH_FLAGS) \
    $(QCOM_SECURITY_FLAGS) \
    $(QCOM_OPT_FLAGS) \
    $(QCOM_SYSROOT_FLAG)

# Global linker flags
TARGET_GLOBAL_LDFLAGS += \
    -Wl,-O1 \
    -Wl,--hash-style=gnu \
    -Wl,--as-needed \
    -Wl,-z,relro,-z,now \
    $(QCOM_SYSROOT_FLAG)

# Include paths
TARGET_GLOBAL_C_INCLUDES += \
    $(QCOM_SDK_TARGET_SYSROOT)/usr/include

# Library search paths
TARGET_GLOBAL_LDFLAGS += \
    -L$(QCOM_SDK_TARGET_SYSROOT)/usr/lib \
    -L$(QCOM_SDK_TARGET_SYSROOT)/lib

# PKG_CONFIG setup for cross-compilation
export PKG_CONFIG_SYSROOT_DIR := $(QCOM_SDK_TARGET_SYSROOT)
export PKG_CONFIG_PATH := $(QCOM_SDK_TARGET_SYSROOT)/usr/lib/pkgconfig:$(QCOM_SDK_TARGET_SYSROOT)/usr/share/pkgconfig

# CMake toolchain variables (for CMAKE modules)
CMAKE_SYSTEM_NAME := Linux
CMAKE_SYSTEM_PROCESSOR := aarch64
CMAKE_SYSROOT := $(QCOM_SDK_TARGET_SYSROOT)

# Autotools configure flags
AUTOTOOLS_CONFIGURE_ARGS += \
    --host=aarch64-qcom-linux \
    --build=x86_64-linux

###############################################################################
## Debug: Show SDK configuration
###############################################################################
.PHONY: qcom-sdk-info
qcom-sdk-info:
	@echo "=== Qualcomm QCS6490 SDK Configuration ==="
	@echo "SDK Path:         $(QCOM_SDK_PATH)"
	@echo "Target Sysroot:   $(QCOM_SDK_TARGET_SYSROOT)"
	@echo "Host Sysroot:     $(QCOM_SDK_HOST_SYSROOT)"
	@echo "Toolchain Path:   $(QCOM_TOOLCHAIN_PATH)"
	@echo "Cross Prefix:     $(TARGET_CROSS)"
	@echo "CC:               $(TARGET_CC)"
	@echo "CXX:              $(TARGET_CXX)"
	@echo "CFLAGS:           $(TARGET_GLOBAL_CFLAGS)"
	@echo "LDFLAGS:          $(TARGET_GLOBAL_LDFLAGS)"
