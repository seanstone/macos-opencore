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

.PHONY: macos
macos:
	gibMacOS/gibMacOS.command -r -v Catalina
