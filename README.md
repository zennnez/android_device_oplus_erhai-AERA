# OnePlus Pad 2 Pro erhai Android device tree

## Working

- [X] Boots
- [X] Display
- [X] Touch (Even in FastbootD)
- [X] Zip Flashing
- [X] ADB/FastbootD
- [X] WLAN firmware & network connectivity
- [X] Full AERA Recovery UI & LVGL interface (adaptive resolution)

## Testing

- [ ] FBE decryption & strongbox keymint
- [ ] Backup & Restore
- [ ] Factory Reset
- [ ] Adreno 830 GPU hardware acceleration
- [ ] Recovery Audio DSP & AGM service bridge
- [ ] Fastbootd & slotted image flashing
- [ ] ADB & MTP / OTG storage
- [ ] Haptics & Vibration

## Not working

- [ ] ????????

# How To Build

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
