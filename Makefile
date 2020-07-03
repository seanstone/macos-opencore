.PHONY: all
all: oc drivers kexts ssdt config

####################################### OpenCore #######################################

OC_RELEASE = 2020-06-30
OC_VERSION = 0.6.0
OC_BUILD = RELEASE

.PHONY: opencore oc
opencore oc: EFI EFI/OC/Resources
	rm -fv EFI/OC/Drivers/{OpenUsbKbDxe,UsbMouseDxe,NvmExpressDxe,XhciDxe,HiiDatabase,AudioDxe,Ps2KeyboardDxe,Ps2MouseDxe}.efi
	rm -fv EFI/OC/Tools/{BootKicker,ChipTune,CleanNvram,GopStop,HdaCodecDump,KeyTester,MmapDump,OpenControl,ResetSystem,RtcRw}.efi

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

KEXTS = VirtualSMC SMCProcessor SMCSuperIO Lilu WhateverGreen AppleALC VoodooInput VoodooPS2Controller SMCBatteryManager IntelBluetoothFirmware IntelBluetoothInjector itlwm USBMap

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

EFI/OC/Kexts/VirtualSMC.kext EFI/OC/Kexts/SMCProcessor.kext EFI/OC/Kexts/SMCSuperIO.kext EFI/OC/Kexts/SMCBatteryManager.kext: Downloads/Kexts/VirtualSMC
	mkdir -p $(@D)
	cp -r $</Kexts/$(notdir $@) $@

EFI/OC/Kexts/IntelBluetoothFirmware.kext: IntelBluetoothFirmware/DerivedData/IntelBluetoothFirmware.kext
	cp -R $< $@

EFI/OC/Kexts/IntelBluetoothInjector.kext: IntelBluetoothFirmware/DerivedData/IntelBluetoothInjector.kext
	cp -R $< $@

EFI/OC/Kexts/itlwm.kext: itlwm/DerivedData/itlwm.kext
	cp -R $< $@

EFI/OC/Kexts/USBMap.kext: USBMap.kext
	cp -R $< $@

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

###################################### itlwm #######################################

itlwm/DerivedData/itlwm.kext:
	cd itlwm && xcodebuild -target itlwm -sdk macosx10.15 CONFIGURATION_BUILD_DIR=DerivedData

###################################### IntelBluetooth #######################################

IntelBluetoothFirmware/DerivedData/IntelBluetoothFirmware.kext:
	cd IntelBluetoothFirmware && xcodebuild -target IntelBluetoothFirmware -sdk macosx10.15 CONFIGURATION_BUILD_DIR=DerivedData

IntelBluetoothFirmware/DerivedData/IntelBluetoothInjector.kext:
	cd IntelBluetoothFirmware && xcodebuild -target IntelBluetoothInjector -sdk macosx10.15 CONFIGURATION_BUILD_DIR=DerivedData

###################################### itlwm #######################################

EFI/OC/Resources: OcBinaryData/Resources EFI
	cp -r $< $@

###################################### Modified GRUB shell #######################################

EFI/OC/Tools/modGRUBShell.efi: EFI
	wget -nv https://github.com/datasone/grub-mod-setup_var/releases/download/1.1/modGRUBShell.efi -O $@

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

