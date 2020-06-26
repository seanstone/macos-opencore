####################################### OpenCore #######################################

OC_VERSION = 0.5.9
OC_BUILD = DEBUG

.PHONY: opencore oc
opencore oc: OpenCore
	rm -fv OpenCore/EFI/OC/Drivers/{OpenUsbKbDxe,UsbMouseDxe,NvmExpressDxe,XhciDxe,HiiDatabase,OpenCanopy,Ps2KeyboardDxe,Ps2MouseDxe}.efi
	rm -fv OpenCore/EFI/OC/Tools/{BootKicker,ChipTune,CleanNvram,GopStop,HdaCodecDump,KeyTester,MmapDump,OpenControl,ResetSystem,RtcRw}.efi

OpenCore: Downloads/OpenCore-$(OC_VERSION)-$(OC_BUILD).zip
	mkdir -p $@
	unzip $< -d $@

.PRECIOUS: Downloads/OpenCore-$(OC_VERSION)-$(OC_BUILD).zip
Downloads/OpenCore-$(OC_VERSION)-$(OC_BUILD).zip:
	mkdir -p $(@D)
	wget -nv https://github.com/acidanthera/OpenCorePkg/releases/download/$(OC_VERSION)/OpenCore-$(OC_VERSION)-$(OC_BUILD).zip -O $@

####################################### Drivers #######################################

.PHONY: drivers
drivers: OpenCore/EFI/OC/Drivers/HfsPlus.efi

OpenCore/EFI/OC/Drivers/HfsPlus.efi:
	wget -nv https://github.com/acidanthera/OcBinaryData/raw/master/Drivers/HfsPlus.efi -O $@

####################################### Kexts #######################################

KEXTS = VirtualSMC SMCProcessor SMCSuperIO Lilu WhateverGreen AppleALC

VirtualSMC_VERSION = 1.1.4
VirtualSMC_BUILD = RELEASE
Lilu_VERSION = 1.4.5
Lilu_BUILD = RELEASE
WhateverGreen_VERSION = 1.4.0
WhateverGreen_BUILD = RELEASE
AppleALC_VERSION = 1.5.0
AppleALC_BUILD = RELEASE

.PHONY: kexts
kexts: $(patsubst %, OpenCore/EFI/OC/Kexts/%.kext, $(KEXTS))

Downloads/Kexts/%:
	mkdir -p Downloads/Kexts
	wget -nv https://github.com/acidanthera/$*/releases/download/$($*_VERSION)/$*-$($*_VERSION)-$($*_BUILD).zip -O Downloads/Kexts/$*-$($*_VERSION)-$($*_BUILD).zip
	unzip Downloads/Kexts/$*-$($*_VERSION)-$($*_BUILD).zip -d $@

.PRECIOUS: Downloads/Kexts/%
OpenCore/EFI/OC/Kexts/%.kext: Downloads/Kexts/%
	mkdir -p $(@D)
	cp -r $</$*.kext $@

OpenCore/EFI/OC/Kexts/VirtualSMC.kext OpenCore/EFI/OC/Kexts/SMCProcessor.kext OpenCore/EFI/OC/Kexts/SMCSuperIO.kext: Downloads/Kexts/VirtualSMC
	mkdir -p $(@D)
	cp -r $</Kexts/$(notdir $@) $@

###################################### SSDT #######################################

SSDTS = SSDT-PNLF SSDT-EC-USBX-LAPTOP SSDT-PLUG-DRTNIA SSDT-GPI0 SSDT-HPET

.PHONY: ssdt
ssdt: $(patsubst %, OpenCore/EFI/OC/ACPI/%.aml, $(SSDTS))

OpenCore/EFI/OC/ACPI/SSDT-PNLF.aml OpenCore/EFI/OC/ACPI/SSDT-EC-USBX-LAPTOP.aml OpenCore/EFI/OC/ACPI/SSDT-PLUG-DRTNIA.aml:
	wget -nv https://github.com/dortania/Getting-Started-With-ACPI/raw/master/extra-files/compiled/$(notdir $@) -O $@

OpenCore/EFI/OC/ACPI/SSDT-GPI0.aml: SSDT/SSDT-GPI0.dsl
	iasl -p $@ $<

.PHONY: dsdt
dsdt: SSDTTime/Results/DSDT.aml

OpenCore/EFI/OC/ACPI/SSDT-HPET.aml: SSDTTime/Results/SSDT-HPET.aml
	cp $< $@

SSDTTime/Results/SSDT-HPET.aml: SSDTTime/Results/DSDT.aml
	printf '1\n\nSSDTTime/Results/DSDT.aml\n\n\nq\n' | SSDTTime/SSDTTime.py

SSDTTime/Results/DSDT.aml:
	printf '4\n\nq\n' | SSDTTime/SSDTTime.py

###################################### MacOS #######################################

.PHONY: macos
macos:
	gibMacOS/gibMacOS.command -r -v Catalina

###################################### Clean #######################################

.PHONY: clean cleanall
clean:
	rm -rf Downloads
	rm -rf OpenCore/EFI/OC/Kexts/* OpenCore/EFI/OC/ACPI/*

cleanall:
	rm -rf OpenCore Downloads