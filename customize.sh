ui_print "=========================================="
ui_print "     NEXORA - Universal Kernel Engine     "
ui_print "     Author: Kiran_embedded               "
ui_print "     Version: 1.0.0                       "
ui_print "=========================================="

# Dynamic Device Telemetry Detection
DEV_BRAND=$(getprop ro.product.brand)
DEV_MODEL=$(getprop ro.product.model)
DEV_DEVICE=$(getprop ro.product.device)
DEV_PLATFORM=$(getprop ro.board.platform)
DEV_ANDROID=$(getprop ro.build.version.release)
DEV_KERNEL=$(uname -r | cut -d'-' -f1)

# Classify SoC Vendor dynamically
case "$DEV_PLATFORM" in
    mt*|MT*) SOC_TYPE="MediaTek ($DEV_PLATFORM)" ;;
    exynos*|universal*) SOC_TYPE="Samsung Exynos ($DEV_PLATFORM)" ;;
    qcom*|sm*|kona*|kalama*|taro*) SOC_TYPE="Qualcomm Snapdragon ($DEV_PLATFORM)" ;;
    *) SOC_TYPE="Universal ARM64 ($DEV_PLATFORM)" ;;
esac

# Auto-detect display peak refresh rate capability
DETECTED_FPS=60
PEAK_PROP=$(settings get system peak_refresh_rate 2>/dev/null)
if [ -n "$PEAK_PROP" ] && [ "$PEAK_PROP" != "null" ]; then
    DETECTED_FPS=$(printf "%.0f" "$PEAK_PROP" 2>/dev/null || echo 60)
fi
if [ "$DETECTED_FPS" -lt 60 ] 2>/dev/null; then
    DETECTED_FPS=60
fi

ui_print "[i] Detected Device : $DEV_MODEL ($DEV_DEVICE)"
ui_print "[i] Hardware SoC    : $SOC_TYPE"
ui_print "[i] Android Version : Android $DEV_ANDROID"
ui_print "[i] Linux Kernel    : $DEV_KERNEL GKI"
ui_print "[i] Display Target  : Synchronized to ${DETECTED_FPS}Hz"
ui_print "------------------------------------------"

ui_print "[*] Calibrating virtual memory & LZ4 ZRAM..."
ui_print "[*] Accelerating storage I/O request queues..."
ui_print "[*] Tuning frequency governor response (0us)..."
ui_print "[*] Silencing kernel debug logs & tracers..."

set_perm_recursive $MODPATH 0 0 0755 0644
set_perm $MODPATH/service.sh 0 0 0755

ui_print "------------------------------------------"
ui_print "[+] NEXORA installation complete!"
ui_print "=========================================="
