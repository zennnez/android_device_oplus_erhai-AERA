#!/system/bin/sh
#
# USB gadget bring-up for sm87xx.
#
# Resolves the UDC name itself instead of relying only on the
# ro.boot.usbcontroller property trigger (which never fires if the bootloader
# does not pass androidboot.usbcontroller), forces the dwc3 glue into
# peripheral mode, and publishes sys.usb.controller for the UDC writes in
# init.recovery.usb.rc.

SCRIPTNAME="aera-usb-gadget.sh"
GADGET="/config/usb_gadget/g1"
TIMEOUT_DS=300 # 30 s, in tenths of a second

log() {
	echo "I:$SCRIPTNAME: $1" >> /dev/kmsg 2>/dev/null
	echo "I:$SCRIPTNAME: $1" >> /tmp/recovery.log
}

warn() {
	echo "W:$SCRIPTNAME: $1" >> /dev/kmsg 2>/dev/null
	echo "W:$SCRIPTNAME: $1" >> /tmp/recovery.log
}

fail() {
	echo "E:$SCRIPTNAME: $1" >> /dev/kmsg 2>/dev/null
	echo "E:$SCRIPTNAME: $1" >> /tmp/recovery.log
}

GLUE_NAME="$(getprop ro.boot.usb.dwc3_msm)"
[ -n "$GLUE_NAME" ] || GLUE_NAME="a600000.ssusb"
GLUE="/sys/bus/platform/devices/$GLUE_NAME"
UDC_PROP="$(getprop ro.boot.usbcontroller)"

# 1. Wait for the dwc3 glue "mode" node.
i=0
while [ ! -e "$GLUE/mode" ] && [ "$i" -lt "$TIMEOUT_DS" ]; do
	sleep 0.1
	i=$((i + 1))
done

BOUND="$(cat "$GADGET/UDC" 2>/dev/null)"
if [ -e "$GLUE/mode" ]; then
	log "dwc3 glue: $GLUE (mode=$(cat "$GLUE/mode" 2>/dev/null))"
	# Only cycle the role while no gadget is bound, otherwise we would drop
	# a live connection.
	if [ -z "$BOUND" ]; then
		echo idle > "$GLUE/mode" 2>/dev/null ||
			warn "write 'idle' to $GLUE/mode failed"
		sleep 0.5
		echo peripheral > "$GLUE/mode" 2>/dev/null ||
			warn "write 'peripheral' to $GLUE/mode failed"
	fi
else
	warn "$GLUE/mode not found after 30s, skipping peripheral mode switch (ro.boot.usb.dwc3_msm='$(getprop ro.boot.usb.dwc3_msm)'); usb-like platform devices: $(ls /sys/bus/platform/devices 2>/dev/null | grep -i 'usb\|dwc3' | tr '\n' ' ')"
fi

# 2. Resolve the UDC. Prefer ro.boot.usbcontroller; after 5 s (or when it is
#    unset) fall back to the first controller the kernel registered.
UDC=""
i=0
while [ "$i" -lt "$TIMEOUT_DS" ]; do
	if [ -n "$UDC_PROP" ] && [ -e "/sys/class/udc/$UDC_PROP" ]; then
		UDC="$UDC_PROP"
		break
	fi
	if [ -z "$UDC_PROP" ] || [ "$i" -ge 50 ]; then
		UDC="$(ls /sys/class/udc 2>/dev/null | head -n 1)"
		[ -n "$UDC" ] && break
	fi
	sleep 0.1
	i=$((i + 1))
done

if [ -z "$UDC" ]; then
	fail "no UDC in /sys/class/udc after 30s (ro.boot.usbcontroller='$UDC_PROP', glue=$GLUE, mode='$(cat "$GLUE/mode" 2>/dev/null)')"
	fail "inspect with: ls /sys/class/udc ; cat $GLUE/mode ; dmesg | grep -i 'dwc3\|udc\|gadget'"
	exit 1
fi

if [ "$UDC" != "$UDC_PROP" ]; then
	warn "using UDC '$UDC' (ro.boot.usbcontroller='$UDC_PROP')"
fi
setprop sys.usb.controller "$UDC"
log "UDC resolved: $UDC"

# 3. If adb/mtp was already linked before the UDC was known, the UDC write in
#    init.recovery.usb.rc wrote an empty name. Bind it now.
CUR="$(cat "$GADGET/UDC" 2>/dev/null)"
if [ -z "$CUR" ] && [ -e "$GADGET/configs/b.1/f1" ]; then
	if echo "$UDC" > "$GADGET/UDC" 2>/dev/null; then
		log "bound $UDC to $GADGET (function was linked before UDC was known)"
	else
		fail "write '$UDC' to $GADGET/UDC failed"
	fi
fi

log "udc state: $(cat "/sys/class/udc/$UDC/state" 2>/dev/null), bound: '$(cat "$GADGET/UDC" 2>/dev/null)'"
exit 0
