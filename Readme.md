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

* https://www.tonymacx86.com/threads/nvme-ssd-and-intel-rapid-storage-bios-mode.257660/
* https://github.com/fidele007/CLOVER/tree/master/kexts/Other/SATA-RAID-unsupported.kext
* https://www.tonymacx86.com/threads/guide-hackrnvmefamily-co-existence-with-ionvmefamily-using-class-code-spoof.210316/
* https://medium.com/@salbito/patching-support-for-nvme-ssds-on-macos-sierra-43672c94e2a8
* https://www.tonymacx86.com/threads/fully-functional-windows-10-high-sierra-dual-boot-32gb-intel-optane.262361/

## Build on macOS

```
$ brew install wget
$ brew install acpica
```
