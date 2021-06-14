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
* https://www.reddit.com/r/hackintosh/comments/mki10b/tiger_lake_hackintosh_support
* https://www.reddit.com/r/hackintosh/comments/nkyedd/worlds_first_working_intel_11th_tiger_lake
* https://www.olarila.com/topic/14072-wip-step-by-step-z590-gigabyte-vision-d-i7-rocket-lake-s/

## NVMe

Doesn't work :(

Problem:
> * macOS doesn't support hardware RAID or IDE mode properly.
> * Note drives already using Intel Rapid Storage Technology(RST, soft RAID for Windows and Linux) will not be accessible in macOS.

* https://www.tonymacx86.com/threads/nvme-ssd-and-intel-rapid-storage-bios-mode.257660/
* https://github.com/fidele007/CLOVER/tree/master/kexts/Other/SATA-RAID-unsupported.kext
* https://www.tonymacx86.com/threads/guide-hackrnvmefamily-co-existence-with-ionvmefamily-using-class-code-spoof.210316/
* https://medium.com/@salbito/patching-support-for-nvme-ssds-on-macos-sierra-43672c94e2a8
* https://www.tonymacx86.com/threads/fully-functional-windows-10-high-sierra-dual-boot-32gb-intel-optane.262361/
* https://www.insanelymac.com/forum/topic/301456-modded-appleahciportkext-for-raid-sata-in-laptops-for-mavericks-andor-yosemite/
* https://www.tonymacx86.com/threads/change-sata-selection-mode-from-ahci-to-raid.216355/
* https://www.insanelymac.com/forum/files/file/56-appleahciportkext-for-raid/
* https://www.insanelymac.com/forum/topic/183644-ich10r-in-raid-mode-working-in-slsorta/
* http://bradstevo.blogspot.com/2012/01/making-ahci-hackintosh-install-raid.html
* https://www.tonymacx86.com/threads/success-hp-pavilion-x360-15-cr0037wm-oc-0-6-4.307211/
* https://www.tonymacx86.com/threads/most-powerful-hackbook-pro-asus-rog-g701vo-cs74k-i7-6820-64gb-ddr4-w-980-dedicated.217739/

> NVMe as NVMe (eg. SATA mode AHCI) is way different from NVMe as RST (SATA mode RAID).
> Having NVMe devices with SATA mode RAID, means the NVMe devices disappear (as standalone NVMe on PCIe) and instead are connected to the chipset SATA controller instead.
> It likely causes a problem for macOS ACHI port kext.

### Fixing

* https://bugs.freebsd.org/bugzilla/show_bug.cgi?id=252253
* https://developer.apple.com/documentation/kernel/implementing_drivers_system_extensions_and_kexts

## Build on macOS

```
$ brew install wget
$ brew install acpica
```
