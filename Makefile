.PHONY: all
all: oc drivers kexts ssdt config

####################################### OpenCore #######################################

OC_RELEASE = 2020-06-30
OC_VERSION = 0.6.0
OC_BUILD = RELEASE

.PHONY: opencore oc
opencore oc: EFI
	rm -fv EFI/OC/Drivers/{OpenUsbKbDxe,UsbMouseDxe,NvmExpressDxe,XhciDxe,HiiDatabase,OpenCanopy,AudioDxe,Ps2KeyboardDxe,Ps2MouseDxe}.efi
	rm -fv EFI/OC/Tools/*

EFI: Downloads/OpenCore/EFI
	cp -r $< $@

Downloads/OpenCore/EFI: Downloads/OpenCore

Downloads/OpenCore: Downloads/OpenCore-$(OC_VERSION)-$(OC_BUILD).zip
	mkdir -p $@
	unzip $< -d $@

.PRECIOUS: Downloads/OpenCore-$(OC_VERSION)-$(OC_BUILD).zip
Downloads/OpenCore-$(OC_VERSION)-$(OC_BUILD).zip:
	mkdir -p $(@D)
	wget -nv https://github.com/williambj1/OpenCore-Factory/releases/download/$(OC_RELEASE)/OpenCore-$(OC_VERSION)-$(OC_BUILD).zip  -O $@

####################################### Drivers #######################################

.PHONY: drivers
drivers: EFI/OC/Drivers/HfsPlus.efi

EFI/OC/Drivers/HfsPlus.efi:
	wget -nv https://github.com/acidanthera/OcBinaryData/raw/master/Drivers/HfsPlus.efi -O $@

####################################### Kexts #######################################

KEXTS = VirtualSMC SMCProcessor SMCSuperIO Lilu WhateverGreen AppleALC VoodooInput VoodooPS2Controller ACPIBatteryManager

VirtualSMC_VERSION = 1.1.4
VirtualSMC_BUILD = RELEASE
VirtualSMC_REPO = VirtualSMC
Lilu_VERSION = 1.4.5
Lilu_BUILD = RELEASE
Lilu_REPO = Lilu
WhateverGreen_VERSION = 1.4.0
WhateverGreen_BUILD = RELEASE
WhateverGreen_REPO = WhateverGreen
AppleALC_VERSION = 1.5.0
AppleALC_BUILD = RELEASE
AppleALC_REPO = AppleALC
VoodooInput_VERSION = 1.0.6
VoodooInput_BUILD = RELEASE
VoodooInput_REPO = VoodooInput
VoodooPS2Controller_VERSION = 2.1.5
VoodooPS2Controller_BUILD = RELEASE
VoodooPS2Controller_REPO = VoodooPS2

.PHONY: kexts
kexts: $(patsubst %, EFI/OC/Kexts/%.kext, $(KEXTS))

Downloads/Kexts/%:
	mkdir -p Downloads/Kexts
	wget -nv https://github.com/acidanthera/$($*_REPO)/releases/download/$($*_VERSION)/$*-$($*_VERSION)-$($*_BUILD).zip -O Downloads/Kexts/$*-$($*_VERSION)-$($*_BUILD).zip
	unzip Downloads/Kexts/$*-$($*_VERSION)-$($*_BUILD).zip -d $@

.PRECIOUS: Downloads/Kexts/%
EFI/OC/Kexts/%.kext: Downloads/Kexts/%
	mkdir -p $(@D)
	cp -r $</$*.kext $@

EFI/OC/Kexts/VirtualSMC.kext EFI/OC/Kexts/SMCProcessor.kext EFI/OC/Kexts/SMCSuperIO.kext: Downloads/Kexts/VirtualSMC
	mkdir -p $(@D)
	cp -r $</Kexts/$(notdir $@) $@

EFI/OC/Kexts/ACPIBatteryManager.kext: Downloads/Kexts/RehabMan-Battery-2018-1005
	mkdir -p $(@D)
	cp -r Downloads/Kexts/RehabMan-Battery-2018-1005/Release/ACPIBatteryManager.kext $@

Downloads/Kexts/RehabMan-Battery-2018-1005:
	mkdir -p Downloads/Kexts
	wget -nv https://bitbucket.org/RehabMan/os-x-acpi-battery-driver/downloads/RehabMan-Battery-2018-1005.zip -O Downloads/Kexts/RehabMan-Battery-2018-1005.zip
	unzip Downloads/Kexts/RehabMan-Battery-2018-1005.zip -d $@

###################################### Battry patch #######################################

.PHONY: battery
battery: Downloads/battery_ASUS-N55SL.txt

Downloads/battery_ASUS-N55SL.txt:
	wget -nv https://raw.githubusercontent.com/RehabMan/Laptop-DSDT-Patch/master/battery/battery_ASUS-N55SL.txt -O $@

###################################### SSDT #######################################

SSDTS = SSDT-PLUG-DRTNIA SSDT-EC-USBX-LAPTOP SSDT-GPI0 SSDT-PNLF
#SSDT-HPET

.PHONY: ssdt
ssdt: $(patsubst %, EFI/OC/ACPI/%.aml, $(SSDTS))

EFI/OC/ACPI/SSDT-PLUG-DRTNIA.aml EFI/OC/ACPI/SSDT-EC-USBX-LAPTOP.aml EFI/OC/ACPI/SSDT-PNLF.aml:
	wget -nv https://github.com/dortania/Getting-Started-With-ACPI/raw/master/extra-files/compiled/$(notdir $@) -O $@

EFI/OC/ACPI/%.aml: dsl/%.dsl
	iasl -p $@ $<

# .PHONY: dsdt
# dsdt: SSDTTime/Results/DSDT.aml

# EFI/OC/ACPI/SSDT-HPET.aml: SSDTTime/Results/SSDT-HPET.aml
# 	cp $< $@

# SSDTTime/Results/SSDT-HPET.aml: SSDTTime/Results/DSDT.aml
# 	printf '1\n\nSSDTTime/Results/DSDT.aml\n\n\nq\n' | SSDTTime/SSDTTime.py

# SSDTTime/Results/DSDT.aml:
# 	printf '4\n\nq\n' | SSDTTime/SSDTTime.py

###################################### config.plist #######################################

.PHONY: config
config: EFI/OC/config.plist

EFI/OC/config.plist: config.plist
	cp $< $@

###################################### MacOS #######################################

.PHONY: macos
macos:
	gibMacOS/gibMacOS.command -r -v Catalina

###################################### Clean #######################################

.PHONY: clean cleanall
clean:
	rm -rf EFI

cleanall:
	rm -rf Downloads EFI

###################################### Install #######################################

UNAME = $(shell uname)
ifeq ($(UNAME),Linux)
EFI = /boot/EFI/
endif
ifeq ($(UNAME),Darwin)
EFI = /Volumes/EFI/EFI/
endif

ifeq ($(UNAME),Darwin)
$(EFI):
	sudo diskutil mount /dev/disk0s9
endif

.PHONY: install
install: config $(EFI)
	sudo cp -r EFI/OC $(EFI)