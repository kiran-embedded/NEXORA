# NEXORA - Hardware & Kernel Optimization

Developed by **Kiran_embedded** ([GitHub](https://github.com/kiran-embedded))

NEXORA is a high-performance hardware and kernel optimization module designed specifically for Samsung Galaxy devices (A-Series, S-Series, Z-Series, M-Series, and F-Series) running One UI on Android 14, 15, and 16 with Linux GKI kernels.

## Key Capabilities

- **Dynamic Hardware Auto-Detection**: Dynamically resolves device model, SoC platform, and kernel version during installation.
- **LZ4 Hardware ZRAM & Zero Page-Cluster**: Configures high-throughput LZ4 swap compression (~4,000 MB/s) with `page-cluster=0` (strictly 1 page / 4 KB fault decompression).
- **RAM Plus Disablement Enforced**: Locks `ram_expand_size=0` to guarantee 100% direct physical RAM usage without flash degradation.
- **UFS Multi-Queue Acceleration**: Bypasses redundant software merging (`nomerges=2`), silences I/O statistics spinlocks (`iostats=0`), and sets 512 KB readahead buffers.
- **Zero-Latency Touch Scaling**: Tunes `sugov_ext` frequency governor for instantaneous touch ramp-up (`up_rate_limit_us=0`) while preserving stock idle power down-ramping.
- **Display Refresh Synchronization**: Dynamically detects the panel's maximum peak refresh rate (120Hz, 90Hz, or 60Hz) and locks timing.
- **Low-Latency Network Stack**: Keeps TCP congestion windows active across pauses (`tcp_slow_start_after_idle=0`) and eliminates packet delay (`tcp_autocorking=0`).
- **Safe & Systemless**: 100% rootless userspace/systemless Magisk & KernelSU execution. Preserves Knox 0x0 warranty and read-only partition integrity.

## Installation

1. Download `NEXORA-v1.0.0-Samsung.zip` from the Releases tab.
2. Open **KernelSU**, **Magisk**, or **APatch**.
3. Select **Install from storage** and flash the ZIP.
4. Reboot the device.

## License

This project is licensed under the Apache 2.0 License.
