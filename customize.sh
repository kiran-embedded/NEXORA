ui_print " "
ui_print "  ███╗   ██╗███████╗██╗  ██╗ ██████╗ ██████╗  █████╗ "
ui_print "  ████╗  ██║██╔════╝╚██╗██╔╝██╔═══██╗██╔══██╗██╔══██╗"
ui_print "  ██╔██╗ ██║█████╗   ╚███╔╝ ██║   ██║██████╔╝███████║"
ui_print "  ██║╚██╗██║██╔══╝   ██╔██╗ ██║   ██║██╔══██╗██╔══██║"
ui_print "  ██║ ╚████║███████╗██╔╝ ██╗╚██████╔╝██║  ██║██║  ██║"
ui_print "  ╚═╝  ╚═══╝╚══════╝╚═╝  ╚═╝ ╚═════╝ ╚═╝  ╚═╝╚═╝  ╚═╝"
ui_print " "
ui_print "  ==================================================="
ui_print "   NEXORA - Samsung Hardware & Kernel Optimizer      "
ui_print "   Architect : Kiran_embedded                        "
ui_print "   GitHub    : https://github.com/kiran-embedded     "
ui_print "   Version   : 1.0.0 (Release)                       "
ui_print "  ==================================================="
ui_print " "

# Extract dynamic device telemetry
DEV_MODEL=$(getprop ro.product.model)
DEV_DEVICE=$(getprop ro.product.device)
DEV_PLATFORM=$(getprop ro.board.platform)
DEV_ANDROID=$(getprop ro.build.version.release)
DEV_KERNEL=$(uname -r | cut -d'-' -f1)

# Classify SoC vendor dynamically
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

ui_print "  [i] Device Model   : $DEV_MODEL ($DEV_DEVICE)"
ui_print "  [i] Platform SoC   : $SOC_TYPE"
ui_print "  [i] Android Version: Android $DEV_ANDROID"
ui_print "  [i] Linux Kernel   : $DEV_KERNEL GKI"
ui_print "  [i] Display Target : Synchronized to ${DETECTED_FPS}Hz"
ui_print " "
sleep 0.8

ui_print "  ─── [1/6] Virtual Memory & Hardware ZRAM ──────────"
ui_print "  ├── Enabling LZ4 hardware compression..."
ui_print "  ├── Calibrating page-cluster to 0 (single-page faulting)..."
ui_print "  └── Locking Swappiness (60) & VFS pressure (70)..."
ui_print "  [✓] Memory subsystem calibrated."
ui_print " "
sleep 0.4

ui_print "  ─── [2/6] UFS Storage & Hardware NCQ Queues ────────"
ui_print "  ├── Setting nomerges=2 (offload block merging to UFS NCQ)..."
ui_print "  ├── Silencing iostats spinlock accounting..."
ui_print "  └── Expanding UFS readahead buffer to 512 KB..."
ui_print "  [✓] Storage pipelines accelerated."
ui_print " "
sleep 0.4

ui_print "  ─── [3/6] CPU Scheduler & Governor Calibration ────"
ui_print "  ├── Tuning sugov_ext: 0us instant ramp-up on touch..."
ui_print "  ├── Prioritizing immediate child thread dispatch..."
ui_print "  └── Preserving native PowerHAL uclamp ownership..."
ui_print "  [✓] CPU responsiveness locked."
ui_print " "
sleep 0.4

ui_print "  ─── [4/6] Display & Touch Synchronization ─────────"
ui_print "  ├── Synchronizing continuous ${DETECTED_FPS}Hz refresh rate..."
ui_print "  └── Polling 240Hz high-frequency touch sampling..."
ui_print "  [✓] Display timing synchronized."
ui_print " "
sleep 0.4

ui_print "  ─── [5/6] Network Latency & Zero-Stall Sockets ────"
ui_print "  ├── Setting tcp_slow_start_after_idle=0..."
ui_print "  └── Disabling packet autocorking delays..."
ui_print "  [✓] Low-latency network stack active."
ui_print " "
sleep 0.4

ui_print "  ─── [6/6] Kernel Log Overhead Elimination ─────────"
ui_print "  ├── Silencing printk console debug logging..."
ui_print "  ├── Disabling scheduler statistics accounting..."
ui_print "  └── Terminating background Perfetto tracers..."
ui_print "  [✓] Overhead eliminated."
ui_print " "

set_perm_recursive $MODPATH 0 0 0755 0644
set_perm $MODPATH/service.sh 0 0 0755

ui_print "  ==================================================="
ui_print "   [✓] NEXORA installed successfully!                "
ui_print "   Developed with precision by Kiran_embedded       "
ui_print "  ==================================================="
ui_print " "
