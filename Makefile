.PHONY: all
all: oc drivers kexts ssdt config

####################################### OpenCore #######################################

OC_RELEASE = 2020-07-10
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

Downloads/OpenCore-$(OC_VERSION)-$(OC_BUILD).zip:
	mkdir -p $(@D)
	wget -nv https://github.com/williambj1/OpenCore-Factory/releases/download/$(OC_RELEASE)/OpenCore-$(OC_VERSION)-$(OC_BUILD).zip  -O $@

####################################### Drivers #######################################

.PHONY: drivers
drivers: EFI/OC/Drivers/HfsPlus.efi

EFI/OC/Drivers/HfsPlus.efi:
	wget -nv https://github.com/acidanthera/OcBinaryData/raw/master/Drivers/HfsPlus.efi -O $@

####################################### Kexts #######################################

KEXTS += VirtualSMC SMCProcessor SMCSuperIO SMCBatteryManager Lilu WhateverGreen AppleALC VoodooInput VoodooPS2Controller 
KEXTS += IntelBluetoothFirmware IntelBluetoothInjector itlwm
KEXTS += USBMap AsusSMC

VirtualSMC_REPO = acidanthera/VirtualSMC
VirtualSMC_VERSION = 1.1.4
VirtualSMC_BUILD = RELEASE

Lilu_REPO = acidanthera/Lilu
Lilu_VERSION = 1.4.5
Lilu_BUILD = RELEASE

WhateverGreen_REPO = acidanthera/WhateverGreen
WhateverGreen_VERSION = 1.4.0
WhateverGreen_BUILD = RELEASE

AppleALC_REPO = acidanthera/AppleALC
AppleALC_VERSION = 1.5.0
AppleALC_BUILD = RELEASE

VoodooInput_REPO = acidanthera/VoodooInput
VoodooInput_VERSION = 1.0.6
VoodooInput_BUILD = RELEASE

VoodooPS2Controller_REPO = acidanthera/VoodooPS2
VoodooPS2Controller_VERSION = 2.1.5
VoodooPS2Controller_BUILD = RELEASE

AsusSMC_REPO = hieplpvip/AsusSMC
AsusSMC_VERSION = 1.2.2
AsusSMC_BUILD = RELEASE

.PHONY: kexts
kexts: $(patsubst %, EFI/OC/Kexts/%.kext, $(KEXTS))

Downloads/Kexts/%: Downloads/Kexts/%.zip
	unzip $< -d $@

Downloads/Kexts/%.zip:
	mkdir -p Downloads/Kexts
	wget -nv https://github.com/$($*_REPO)/releases/download/$($*_VERSION)/$*-$($*_VERSION)-$($*_BUILD).zip -O $@

.PRECIOUS: Downloads/Kexts/%
EFI/OC/Kexts/%.kext: Downloads/Kexts/%
	mkdir -p $(@D)
	cp -r $</$*.kext $@

EFI/OC/Kexts/VirtualSMC.kext EFI/OC/Kexts/SMC%.kext: Downloads/Kexts/VirtualSMC
	mkdir -p $(@D)
	cp -r $</Kexts/$(notdir $@) $@

EFI/OC/Kexts/IntelBluetoothFirmware.kext EFI/OC/Kexts/IntelBluetoothInjector.kext: EFI/OC/Kexts/IntelBluetooth%.kext : IntelBluetoothFirmware/DerivedData/IntelBluetooth%.kext
	cp -R $< $@

EFI/OC/Kexts/itlwm.kext: itlwm/DerivedData/itlwm.kext
	cp -R $< $@

EFI/OC/Kexts/USBMap.kext: USBMap.kext
	cp -R $< $@

###################################### SSDT #######################################

SSDTS = SSDT-PLUG-DRTNIA SSDT-EC-USBX-LAPTOP SSDT-GPI0 SSDT-PNLF

.PHONY: ssdt
ssdt: $(patsubst %, EFI/OC/ACPI/%.aml, $(SSDTS))

EFI/OC/ACPI/SSDT-PLUG-DRTNIA.aml EFI/OC/ACPI/SSDT-EC-USBX-LAPTOP.aml EFI/OC/ACPI/SSDT-PNLF.aml:
	wget -nv https://github.com/dortania/Getting-Started-With-ACPI/raw/master/extra-files/compiled/$(notdir $@) -O $@

EFI/OC/ACPI/%.aml: dsl/%.dsl
	iasl -p $@ $<

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

itlwm/DerivedData/itlwm.kext: itlwm/itlwm/FwBinary.cpp
	cd itlwm && xcodebuild -target itlwm -sdk macosx10.15 CONFIGURATION_BUILD_DIR=DerivedData

itlwm/itlwm/FwBinary.cpp:
	PROJECT_DIR=$(PWD)/itlwm itlwm/fw_gen.sh

###################################### IntelBluetooth #######################################

IntelBluetoothFirmware/DerivedData/IntelBluetooth%.kext:
	cd IntelBluetoothFirmware && xcodebuild -target IntelBluetooth$* -sdk macosx10.15 CONFIGURATION_BUILD_DIR=DerivedData

###################################### OcBinaryData #######################################

EFI/OC/Resources: OcBinaryData/Resources EFI
	cp -r $< $@

###################################### Modified GRUB shell #######################################

modGRUBShell_VERSION = 1.1

EFI/OC/Tools/modGRUBShell.efi: EFI
	wget -nv https://github.com/datasone/grub-mod-setup_var/releases/download/$(modGRUBShell_VERSION)/modGRUBShell.efi -O $@

###################################### Clean #######################################

.PHONY: clean cleanall
clean:
	rm -rf EFI

cleanall:
	rm -rf Downloads EFI IntelBluetoothFirmware/DerivedData itlwm/DerivedData

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
	sudo diskutil mount /dev/disk0s1
endif

.PHONY: install
install: config $(EFI)
	sudo rm -rf $(EFI)/OC
	sudo cp -r EFI/OC $(EFI)
