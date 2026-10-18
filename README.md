# AERA Recovery device tree for OnePlus Pad 2 Pro & SM8750 Series

## Supported Devices

- OnePlus Pad 2 Pro (OPD2413 / OP615EL1) [CN]
- OnePlus 13 (PJZ110 / CPH2653 / OP5D0DL1 / OP5D55L1) [CN, GL]
- OnePlus 13T (PKX110 / OP60F5L1) [CN]
- OnePlus 13s (CPH2723 / OP612BL1) [IN]
- OnePlus Ace 5 Pro (PKR110 / OP60EBL1) [CN]
- OnePlus Ace 6 (PLQ110 / OP6113L1) [CN]
- OnePlus Turbo 6 (PLU110 / OP60F0L1) [CN]
- Realme GT7 Pro / Speed (RMX5010 / RMX5090 / RMX5011) [CN, GL, IN]
- Realme GT8 (RMX6699) [CN]

## Features

- [x] Full AERA Recovery UI & LVGL interface (adaptive resolution)
- [x] Adreno 830 GPU hardware acceleration
- [x] Recovery Audio DSP & AGM service bridge
- [x] WLAN firmware & network connectivity
- [x] FBE decryption & strongbox keymint
- [x] Fastbootd & slotted image flashing
- [x] ADB & MTP / OTG storage
- [x] Haptics & Vibration

## How to Build

### 1. Initialize AERA Manifest
```bash
repo init -u https://github.com/AERA-Recovery/android_manifest.git -b aera-16.0
repo sync -c --force-sync --no-clone-bundle --no-tags -j$(nproc)
```

### 2. Device Tree Placement
Place this repository under:
```bash
device/oneplus/erhai
```

### 3. Build AERA Recovery Image
```bash
source build/envsetup.sh
lunch twrp_erhai-bp2a-eng
mka adbd recoveryimage
```

The output image will be located at:
```bash
out/target/product/erhai/recovery.img
```

## Flashing

```bash
fastboot flash recovery recovery.img
```
or
```bash
fastboot flash recovery_a recovery.img
fastboot flash recovery_b recovery.img
```
