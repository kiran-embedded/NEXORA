#!/system/bin/sh
# ==============================================================================
# NEXORA - Samsung Hardware & Kernel Optimizer
# Architect: Kiran_embedded (https://github.com/kiran-embedded)
# Platform : Samsung Galaxy (MediaTek / Exynos / Snapdragon)
# ==============================================================================

while [ "$(getprop sys.boot_completed)" != "1" ]; do
    sleep 1
done

# 1. Kernel Logging & Background Overhead
echo "0 0 0 0" > /proc/sys/kernel/printk 2>/dev/null
echo 0 > /proc/sys/kernel/sched_schedstats 2>/dev/null
echo 1 > /proc/sys/kernel/timer_migration 2>/dev/null
echo 10 > /proc/sys/vm/stat_interval 2>/dev/null
echo 0 > /sys/module/binder/parameters/debug_mask 2>/dev/null

setprop persist.traced.enable 0
stop traced 2>/dev/null
stop traced_probes 2>/dev/null

# 2. CPU Governor Touch Calibration
for policy in /sys/devices/system/cpu/cpufreq/policy*; do
    [ -d "$policy/sugov_ext" ] || continue
    echo 0 > "$policy/sugov_ext/up_rate_limit_us" 2>/dev/null
    echo 1000 > "$policy/sugov_ext/down_rate_limit_us" 2>/dev/null
done

if [ -f /dev/cpuctl/top-app/cpu.uclamp.min ]; then
    chmod 0660 /dev/cpuctl/top-app/cpu.uclamp.min 2>/dev/null
    chown system:system /dev/cpuctl/top-app/cpu.uclamp.min 2>/dev/null
fi
echo 1 > /proc/sys/kernel/sched_child_runs_first 2>/dev/null

# 3. Virtual Memory & LZ4 ZRAM
echo 0 > /proc/sys/vm/page-cluster 2>/dev/null
echo 32768 > /proc/sys/vm/min_free_kbytes 2>/dev/null
echo 100 > /proc/sys/vm/swappiness
echo 70 > /proc/sys/vm/vfs_cache_pressure
echo 20 > /proc/sys/vm/dirty_ratio
echo 10 > /proc/sys/vm/dirty_background_ratio
echo 1500 > /proc/sys/vm/dirty_writeback_centisecs 2>/dev/null
echo 1000 > /proc/sys/vm/dirty_expire_centisecs 2>/dev/null
echo 0 > /sys/kernel/mm/lru_gen/min_ttl_ms 2>/dev/null

# Enforce RAM Plus Disabled
settings put global ram_expand_size 0 2>/dev/null
setprop persist.sys.zram.ram_expand_size 0 2>/dev/null

# LZ4 ZRAM Hardware Compression
if ! grep -q "\[lz4\]" /sys/block/zram0/comp_algorithm 2>/dev/null; then
    sync
    echo 3 > /proc/sys/vm/drop_caches 2>/dev/null
    swapoff /dev/block/zram0 2>/dev/null
    echo 1 > /sys/block/zram0/reset 2>/dev/null
    echo lz4 > /sys/block/zram0/comp_algorithm 2>/dev/null
    echo 4294967296 > /sys/block/zram0/disksize 2>/dev/null
    mkswap /dev/block/zram0 >/dev/null 2>&1
    swapon /dev/block/zram0 2>/dev/null
fi

device_config put activity_manager max_phantom_processes 2147483647 2>/dev/null
setprop sys.lmk.reportkills 0
setprop persist.sys.lmk.reportkills false

# 4. Storage Queues Optimization (UFS and eMMC)
for queue in /sys/block/sd*/queue /sys/block/mmcblk*/queue; do
    [ -d "$queue" ] || continue
    echo 2 > "$queue/nomerges" 2>/dev/null
    echo 0 > "$queue/iostats" 2>/dev/null
    echo 512 > "$queue/read_ahead_kb" 2>/dev/null
    echo 0 > "$queue/add_random" 2>/dev/null
    echo 2 > "$queue/rq_affinity" 2>/dev/null
done

settings put global sqlite_compatibility_wal_flags "truncate_size=524288,synchronous=NORMAL"

# 5. Low Latency Networking
settings put global wifi_scan_always_enabled 0
settings put global ble_scan_always_enabled 0
settings put global mobile_data_always_on 0
echo 0 > /proc/sys/net/ipv4/tcp_slow_start_after_idle 2>/dev/null
echo 0 > /proc/sys/net/ipv4/tcp_autocorking 2>/dev/null

# 6. Display Refresh Rate Dynamic Synchronization
settings put global accessibility_reduce_transparency 0
settings put secure accessibility_reduce_transparency 0

TARGET_FPS=60
PEAK_DETECT=$(settings get system peak_refresh_rate 2>/dev/null)
if [ -n "$PEAK_DETECT" ] && [ "$PEAK_DETECT" != "null" ]; then
    TARGET_FPS=$(printf "%.0f" "$PEAK_DETECT" 2>/dev/null || echo 60)
fi
if [ "$TARGET_FPS" -lt 60 ] 2>/dev/null; then
    TARGET_FPS=60
fi

settings put system min_refresh_rate "${TARGET_FPS}.0"
settings put system peak_refresh_rate "${TARGET_FPS}.0"
settings put global min_refresh_rate "${TARGET_FPS}.0"
settings put global peak_refresh_rate "${TARGET_FPS}.0"
settings put global refresh_rate_mode 2

if [ -f /sys/devices/platform/soc/11db1000.i2c/i2c-6/6-0038/fts_glove_mode ]; then
    echo 1 > /sys/devices/platform/soc/11db1000.i2c/i2c-6/6-0038/fts_glove_mode 2>/dev/null
fi
if [ -w /sys/class/sec/tsp/cmd ]; then
    echo glove_mode,1 > /sys/class/sec/tsp/cmd 2>/dev/null
fi
