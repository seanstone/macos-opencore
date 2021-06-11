.PHONY: all
all: oc drivers kexts ssdt config

include config.mk

####################################### OpenCore #######################################

.PHONY: opencore oc
opencore oc: EFI EFI/OC/Resources
	for f in EFI/OC/Drivers/*; do \
		if echo $(OC_DRIVERS) | grep -w $$(basename $$f .efi)> /dev/null; then \
			echo "Keeping driver $$f"; \
		else \
			rm -fv $$f; \
		fi; \
	done
	for f in EFI/OC/Tools/*; do \
		if echo $(OC_TOOLS) | grep -w $$(basename $$f .efi)> /dev/null; then \
			echo "Keeping tool $$f"; \
		else \
			rm -fv $$f; \
		fi; \
	done

EFI: Downloads/OpenCore/X64/EFI
	cp -r $< $@

Downloads/OpenCore/X64/EFI: Downloads/OpenCore

Downloads/OpenCore: Downloads/OpenCore-$(OC_VERSION)-$(OC_BUILD).zip
	mkdir -p $@
	unzip $< -d $@

Downloads/OpenCore-$(OC_VERSION)-$(OC_BUILD).zip:
	mkdir -p $(@D)
	wget -nv https://github.com/acidanthera/OpenCorePkg/releases/download/$(OC_VERSION)/OpenCore-$(OC_VERSION)-$(OC_BUILD).zip -O $@

####################################### Drivers #######################################

.PHONY: drivers
drivers: EFI/OC/Drivers/HfsPlus.efi

EFI/OC/Drivers/HfsPlus.efi:
	wget -nv https://github.com/acidanthera/OcBinaryData/raw/master/Drivers/HfsPlus.efi -O $@

####################################### Kexts #######################################

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

EFI/OC/Kexts/VirtualSMC.kext: Downloads/Kexts/VirtualSMC
	mkdir -p $(@D)
	cp -r $</Kexts/$(notdir $@) $@

EFI/OC/Kexts/SMC%.kext: Downloads/Kexts/VirtualSMC
	mkdir -p $(@D)
	cp -r $</Kexts/$(notdir $@) $@

EFI/OC/Kexts/IntelBluetoothFirmware.kext EFI/OC/Kexts/IntelBluetoothInjector.kext: EFI/OC/Kexts/IntelBluetooth%.kext : IntelBluetoothFirmware/DerivedData/IntelBluetooth%.kext
	cp -R $< $@

EFI/OC/Kexts/itlwm.kext: itlwm/DerivedData/itlwm.kext
	cp -R $< $@

EFI/OC/Kexts/USBMap.kext: USBMap.kext
	cp -R $< $@

###################################### SSDT #######################################

.PHONY: ssdt
ssdt: $(patsubst %, EFI/OC/ACPI/%.aml, $(SSDTS))

EFI/OC/ACPI/%.aml:
	wget -nv https://github.com/dortania/Getting-Started-With-ACPI/raw/master/extra-files/compiled/$(notdir $@) -O $@

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
