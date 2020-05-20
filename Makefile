.PHONY: opencore
opencore: OpenCore
	rm -fv OpenCore/EFI/OC/Drivers/{OpenUsbKbDxe,UsbMouseDxe,NvmExpressDxe,XhciDxe,HiiDatabase,OpenCanopy,Ps2KeyboardDxe,Ps2MouseDxe}.efi
	rm -fv OpenCore/EFI/OC/Tools/*

OpenCore: OpenCore-0.5.8-RELEASE.zip
	mkdir -p $@
	unzip $< -d $@

OpenCore-0.5.8-RELEASE.zip:
	wget https://github.com/acidanthera/OpenCorePkg/releases/download/0.5.8/OpenCore-0.5.8-RELEASE.zip
	
.PHONY: macos
macos:
	gibMacOS/gibMacOS.command -r -v Catalina
