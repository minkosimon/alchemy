###############################################################################
## @file products/dragonwing-qcs6490/setup.mk
## @brief Product setup for Dragonwing QCS6490 board
##
## This file defines the target configuration for the Qualcomm QCS6490
## (Dragonwing) development board running Yocto Linux.
##
## Board: Thundercomm Dragonwing QCS6490 / RUBIK Pi 3
## SoC:   Qualcomm QCS6490 (Kryo 670 CPU, Adreno 643 GPU, Hexagon DSP)
## OS:    Yocto Linux (qcom-wayland distribution)
##
###############################################################################

# Product identification
TARGET_PRODUCT := dragonwing-qcs6490
TARGET_PRODUCT_VARIANT := aarch64

# Target OS configuration
TARGET_OS := linux
TARGET_OS_FLAVOUR := yocto

# Target architecture (ARM 64-bit)
TARGET_ARCH := aarch64

# Target CPU variant (Qualcomm Kryo 670)
TARGET_CPU := cortex-a78

# C library (glibc from Yocto SDK)
TARGET_LIBC := glibc

# Board-specific defines
TARGET_GLOBAL_CFLAGS += \
    -DTARGET_BOARD_QCS6490=1 \
    -DTARGET_BOARD_DRAGONWING=1

# Image format for deployment
TARGET_IMAGE_FORMAT := tar.gz

# Root filesystem layout
TARGET_ROOT_DESTDIR := usr

# Default directories
TARGET_DEFAULT_BIN_DESTDIR := $(TARGET_ROOT_DESTDIR)/bin
TARGET_DEFAULT_LIB_DESTDIR := $(TARGET_ROOT_DESTDIR)/lib
TARGET_DEFAULT_ETC_DESTDIR := etc

###############################################################################
## Optional: SDK directories (additional pre-built libraries)
###############################################################################
# TARGET_SDK_DIRS += /path/to/additional/sdk

###############################################################################
## Optional: Skeleton directories (files to copy to final image)
###############################################################################
# TARGET_SKEL_DIRS += $(TARGET_CONFIG_DIR)/skel

###############################################################################
## Board Information (for documentation)
###############################################################################
#
# Qualcomm QCS6490 SoC Features:
# - CPU: Octa-core Kryo 670 (1x Cortex-A78 @ 2.7GHz + 3x A78 @ 2.4GHz + 4x A55 @ 1.9GHz)
# - GPU: Adreno 643
# - DSP: Hexagon 698 with AI Engine
# - AI:  Qualcomm AI Engine (NPU + GPU + DSP)
# - Memory: LPDDR5
# - Connectivity: Wi-Fi 6E, Bluetooth 5.2, 5G optional
#
# Use Cases:
# - AI/ML inference at the edge
# - Computer vision applications
# - Robotics and drones
# - Smart displays and kiosks
#
###############################################################################
