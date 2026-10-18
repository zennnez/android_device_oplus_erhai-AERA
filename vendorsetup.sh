#
#	This file is part of the AERA Recovery Project
# 	Copyright (C) 2025-2026 The AERA Recovery Project
#
#	This software is released under GPL version 3 or any later version.
#	See <http://www.gnu.org/licenses/>.
#
FDEVICE="erhai"

aera_get_target_device() {
local chkdev=$(echo "$BASH_SOURCE" | grep -w $FDEVICE)
   if [ -n "$chkdev" ]; then 
      AERA_BUILD_DEVICE="$FDEVICE"
   else
      chkdev=$(set | grep BASH_ARGV | grep -w $FDEVICE)
      [ -n "$chkdev" ] && AERA_BUILD_DEVICE="$FDEVICE"
   fi
}

if [ -z "$1" -a -z "$AERA_BUILD_DEVICE" ]; then
   aera_get_target_device
fi

if [ "$1" = "$FDEVICE" -o "$AERA_BUILD_DEVICE" = "$FDEVICE" ]; then
	export LC_ALL="C"
	export AERA_AB_DEVICE=1
	export AERA_USE_TAR_BINARY=1
	export AERA_USE_SED_BINARY=1
	export AERA_USE_LZ4_BINARY=1
	export AERA_USE_ZSTD_BINARY=1
	export AERA_USE_DATE_BINARY=1
	export AERA_DELETE_AROMAFM=1
	export AERA_VANILLA_BUILD=1
	export AERA_PRODUCT_PREFIX=AERA
	export AERA_BUILD_STATUS=Official
	export AERA_BUILD_TYPE=Beta
	export AERA_PRODUCT_PREFIX="$AERA_PRODUCT_PREFIX"
	export AERA_USE_GREP_BINARY=1
	export AERA_USE_BUSYBOX_BINARY=1
	export AERA_USE_XZ_UTILS=1
	export AERA_VIRTUAL_AB_DEVICE=1
	export AERA_ALLOW_EARLY_SETTINGS_LOAD=1
	export AERA_USE_UPDATED_MAGISKBOOT=1
	# Keep magiskboot/repacking support, but omit the bundled installer ZIP.
	# AERA's WPE runtime shares strict 100 MiB recovery partition.
	export AERA_DELETE_MAGISK_ADDON=1
	export AERA_USE_FSCK_EROFS_BINARY=1
	export AERA_USE_PATCHELF_BINARY=1
	export AERA_SETTINGS_ROOT_DIRECTORY=/data/recovery
	export AERA_MISCELLANEOUS_ROOT_DIRECTORY=/sdcard
	export AERA_ALLOW_EARLY_SETTINGS_LOAD=1

	# Device targets for OnePlus Pad 2 Pro (erhai) & SM8750 series
	export TARGET_DEVICE_ALT="OPD2413,OP615EL1,OnePlus_Pad2Pro,PJZ110,OP5D55L1,OP5D0DL1,CPH2649,CPH2653,CPH2655,PKX110,CPH2723,PKR110,PLQ110,PLU110,RMX5010,RMX5090,RMX5011,RMX6699,erhai,sm87xx"
	export AERA_TARGET_DEVICES="$TARGET_DEVICE_ALT"
	export AERA_USE_DMSETUP=1
	export AERA_ENABLE_ROOT_MANAGER=1
	# AERA begins at R1.0; do not append a legacy maintainer patch suffix.
	unset AERA_MAINTAINER_PATCH_VERSION
fi
#
