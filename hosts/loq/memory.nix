# Memory and swap tuning for 64GB RAM
{ ... }:

{
  # Optimize kernel memory management for large RAM
  boot.kernel.sysctl = {
    # Don't swap anonymous pages until the kernel is genuinely out of options:
    # 0 means it won't start swapping until free + file-backed pages drop below
    # a zone's high watermark, i.e. only under real memory pressure. Swap still
    # acts as an OOM safety net; it just isn't touched in normal operation.
    # Default: 60 (too aggressive), Range: 0-200
    "vm.swappiness" = 0;

    # Prefer keeping filesystem metadata in cache
    # Default: 100, Lower = keep more in cache
    "vm.vfs_cache_pressure" = 50;

    # Increase dirty page limits for better write performance
    # dirty_ratio: max % of RAM for dirty pages before blocking writes
    # 40% of 64GB = ~25GB buffer
    "vm.dirty_ratio" = 40;

    # When to start background writeback
    # 20% of 64GB = ~12GB
    "vm.dirty_background_ratio" = 20;

    # Increase memory reserves before swap activation
    # Default: 10, Higher = more RAM reserved
    "vm.watermark_scale_factor" = 125;
  };
}
