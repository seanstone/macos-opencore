* [OpenCore Install Guide](https://dortania.github.io/OpenCore-Install-Guide/)

## Prerequisites

```
$ git submodule init
$ git submodule update
$ sudo pacman -S iasl
```

## Create macOS Installer

Download macOS image:
```
$ ./gibMacOS/gibMacOS.command
```

## Tiger Lake

* https://github.com/deniro98/hackintosh-asus-zenbook-duo-ux482ea
* https://github.com/balopez83/One_Mix_Yoga_4_Hackintosh
* https://github.com/NTHT1MD/Hackintosh_Opencore_HP-Pavilion-X360-dw1016TU-i3
* https://github.com/xqmnig/YOGA-14s-2021-hackintosh
* https://www.reddit.com/r/hackintosh/comments/mki10b/tiger_lake_hackintosh_support
* https://www.reddit.com/r/hackintosh/comments/nkyedd/worlds_first_working_intel_11th_tiger_lake
* https://www.olarila.com/topic/14072-wip-step-by-step-z590-gigabyte-vision-d-i7-rocket-lake-s/

## Fixing NVMe

* https://bugs.freebsd.org/bugzilla/show_bug.cgi?id=252253
* https://developer.apple.com/documentation/kernel/implementing_drivers_system_extensions_and_kexts
* https://github.com/RehabMan/patch-nvme
* https://github.com/acidanthera/MacKernelSDK
* https://github.com/acidanthera/NVMeFix
* https://developer.apple.com/documentation/kernel/hardware_families/pci/implementing_a_pcie_kext_for_a_thunderbolt_device
* https://github.com/cdf/Innie

## Intel Graphics

* https://sourceforge.net/p/vmsvga2/code/HEAD/tree/
* https://github.com/torvalds/linux/tree/master/drivers/gpu/drm/i915

## Build on macOS

```
$ brew install wget
$ brew install acpica
```
