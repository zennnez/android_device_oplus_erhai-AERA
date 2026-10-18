#
# Copyright (C) 2025 The Android Open Source Project
#
# SPDX-License-Identifier: Apache-2.0
#

DEVICE_PATH := device/oneplus/erhai

# Inherit from device.mk configuration
$(call inherit-product, $(DEVICE_PATH)/device.mk)

## Device identifier
PRODUCT_DEVICE       := erhai
PRODUCT_NAME         := twrp_erhai
PRODUCT_BRAND        := oneplus
PRODUCT_MODEL        := OnePlus Pad 2 Pro
PRODUCT_MANUFACTURER := oneplus

PRODUCT_GMS_CLIENTID_BASE := android-oplus

# Theme
AERA_STATUS_ICONS_ALIGN := center
TW_STATUS_ICONS_ALIGN   := center
