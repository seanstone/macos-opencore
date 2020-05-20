.PHONY: opencore
opencore: OpenCore
	rm -fv OpenCore/EFI/OC/Drivers/{OpenUsbKbDxe,UsbMouseDxe,NvmExpressDxe,XhciDxe,HiiDatabase,OpenCanopy,Ps2KeyboardDxe,Ps2MouseDxe}.efi
	rm -fv OpenCore/EFI/OC/Tools/*

OpenCore: Downloads/OpenCore-0.5.8-RELEASE.zip
	mkdir -p $@
	unzip $< -d $@

Downloads/OpenCore-0.5.8-RELEASE.zip:
	wget https://github.com/acidanthera/OpenCorePkg/releases/download/0.5.8/OpenCore-0.5.8-RELEASE.zip -O $@

.PHONY: drivers
drivers: OpenCore/EFI/OC/Drivers/HfsPlus.efi

OpenCore/EFI/OC/Drivers/HfsPlus.efi:
	wget https://github.com/acidanthera/OcBinaryData/raw/master/Drivers/HfsPlus.efi -O $@

.PHONY: kexts
kexts: OpenCore/EFI/OC/Kexts/VirtualSMC.kext OpenCore/EFI/OC/Kexts/SMCProcessor.kext OpenCore/EFI/OC/Kexts/SMCSuperIO.kext OpenCore/EFI/OC/Kexts/Lilu.kext OpenCore/EFI/OC/Kexts/WhateverGreen.kext OpenCore/EFI/OC/Kexts/AppleALC.kext

OpenCore/EFI/OC/Kexts/VirtualSMC.kext OpenCore/EFI/OC/Kexts/SMCProcessor.kext OpenCore/EFI/OC/Kexts/SMCSuperIO.kext: OpenCore/EFI/OC/Kexts/%: Downloads/VirtualSMC/Kexts/%
	cp -r $< $@

Downloads/VirtualSMC/Kexts/%.kext: Downloads/VirtualSMC
	#

Downloads/VirtualSMC: Downloads/VirtualSMC-1.1.3-RELEASE.zip
	mkdir -p $@
	unzip $< -d $@

Downloads/VirtualSMC-1.1.3-RELEASE.zip:
	wget https://github.com/acidanthera/VirtualSMC/releases/download/1.1.3/VirtualSMC-1.1.3-RELEASE.zip -O $@

OpenCore/EFI/OC/Kexts/Lilu.kext: Downloads/Lilu/Lilu.kext
	cp -r $< $@

Downloads/Lilu/Lilu.kext: Downloads/Lilu
	#

Downloads/Lilu: Downloads/Lilu-1.4.4-RELEASE.zip
	mkdir -p $@
	unzip $< -d $@

Downloads/Lilu-1.4.4-RELEASE.zip:
	wget https://github.com/acidanthera/Lilu/releases/download/1.4.4/Lilu-1.4.4-RELEASE.zip -O $@

OpenCore/EFI/OC/Kexts/WhateverGreen.kext: Downloads/WhateverGreen/WhateverGreen.kext
	cp -r $< $@

Downloads/WhateverGreen/WhateverGreen.kext: Downloads/WhateverGreen
	#

Downloads/WhateverGreen: Downloads/WhateverGreen-1.3.9-RELEASE.zip
	mkdir -p $@
	unzip $< -d $@

Downloads/WhateverGreen-1.3.9-RELEASE.zip:
	wget https://github.com/acidanthera/WhateverGreen/releases/download/1.3.9/WhateverGreen-1.3.9-RELEASE.zip -O $@

OpenCore/EFI/OC/Kexts/AppleALC.kext: Downloads/AppleALC/AppleALC.kext
	cp -r $< $@

Downloads/AppleALC/AppleALC.kext: Downloads/AppleALC
	#

Downloads/AppleALC: Downloads/AppleALC-1.4.9-RELEASE.zip
	mkdir -p $@
	unzip $< -d $@

Downloads/AppleALC-1.4.9-RELEASE.zip:
	wget https://github.com/acidanthera/AppleALC/releases/download/1.4.9/AppleALC-1.4.9-RELEASE.zip -O $@

.PHONY: ssdt
ssdt: OpenCore/EFI/OC/ACPI/SSDT-PNLF.aml OpenCore/EFI/OC/ACPI/SSDT-GPI0.aml OpenCore/EFI/OC/ACPI/SSDT-HPET.aml

OpenCore/EFI/OC/ACPI/SSDT-PNLF.aml:
	wget https://github.com/dortania/Getting-Started-With-ACPI/raw/master/extra-files/SSDT-PNLF.aml -O $@

OpenCore/EFI/OC/ACPI/SSDT-GPI0.aml: SSDT/SSDT-GPI0.dsl
	iasl -p $@ $<

.PHONY: ssdt-quick
ssdt-quick: OpenCore/EFI/OC/ACPI/SSDT-EC-USBX-LAPTOP.aml OpenCore/EFI/OC/ACPI/SSDT-PLUG-DRTNIA.aml

OpenCore/EFI/OC/ACPI/SSDT-EC-USBX-LAPTOP.aml:
	wget https://github.com/dortania/Getting-Started-With-ACPI/raw/master/extra-files/SSDT-EC-USBX-LAPTOP.aml -O $@

OpenCore/EFI/OC/ACPI/SSDT-PLUG-DRTNIA.aml:
	wget https://github.com/dortania/Getting-Started-With-ACPI/raw/master/extra-files/SSDT-PLUG-DRTNIA.aml -O $@

.PHONY: dsdt
dsdt: SSDTTime/Results/DSDT.aml

OpenCore/EFI/OC/ACPI/SSDT-HPET.aml: SSDTTime/Results/SSDT-HPET.aml
	cp $< $@

SSDTTime/Results/SSDT-HPET.aml: SSDTTime/Results/DSDT.aml
	printf '1\n\nSSDTTime/Results/DSDT.aml\n\n\nq\n' | SSDTTime/SSDTTime.py

SSDTTime/Results/DSDT.aml:
	printf '4\n\nq\n' | SSDTTime/SSDTTime.py

.PHONY: macos
macos:
	gibMacOS/gibMacOS.command -r -v Catalina
