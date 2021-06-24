################################# OpenCore ###################################

OC_VERSION = 0.7.0
OC_BUILD = DEBUG

OC_DRIVERS = OpenRuntime HfsPlus
OC_DRIVERS += NvmExpressDxe
#OC_DRIVERS += CrScreenshotDxe OpenCanopy OpenHfsPlus
OC_TOOLS = OpenShell
#OC_TOOLS += ControlMsrE2 CsrUtil

################################## Kexts #####################################

KEXTS += VirtualSMC Lilu
KEXTS += SMCProcessor SMCSuperIO SMCBatteryManager
#KEXTS += SMCLightSensor
KEXTS += WhateverGreen
KEXTS += USBInjectAll
KEXTS += AppleALC
KEXTS += AirportItlwm 
KEXTS += IntelBluetoothFirmware IntelBluetoothInjector
KEXTS += NVMeFix CtlnaAHCIPort
KEXTS += VoodooPS2Controller 
KEXTS += VoodooI2C VoodooI2CHID VoodooI2CSynaptics
#KEXTS += VoodooRMI VoodooSMBus
#KEXTS += USBMap

VirtualSMC_REPO = acidanthera/VirtualSMC
VirtualSMC_VERSION = 1.2.4
VirtualSMC_BUILD = RELEASE

Lilu_REPO = acidanthera/Lilu
Lilu_VERSION = 1.5.3
Lilu_BUILD = RELEASE

WhateverGreen_REPO = acidanthera/WhateverGreen
WhateverGreen_VERSION = 1.5.0
WhateverGreen_BUILD = RELEASE

AppleALC_REPO = acidanthera/AppleALC
AppleALC_VERSION = 1.6.1
AppleALC_BUILD = RELEASE

VoodooInput_REPO = acidanthera/VoodooInput
VoodooInput_VERSION = 1.1.2
VoodooInput_BUILD = RELEASE

VoodooPS2Controller_REPO = acidanthera/VoodooPS2
VoodooPS2Controller_VERSION = 2.2.3
VoodooPS2Controller_BUILD = RELEASE

VoodooRMI_REPO = VoodooSMBus/VoodooRMI
VoodooRMI_VERSION = 1.3.3
VoodooRMI_BUILD = Release

VoodooI2C_REPO = VoodooI2C/VoodooI2C
VoodooI2C_VERSION = 2.6.5

USBInjectAll_VERSION = 2018-1108
USBInjectAll_BUILD = Release

AirportItlwm_REPO = OpenIntelWireless/itlwm
AirportItlwm_VERSION = 1.3.0
AirportItlwm_BUILD = stable_BigSur

IntelBluetooth_REPO = OpenIntelWireless/IntelBluetoothFirmware
IntelBluetooth_VERSION = 1.1.2

NVMeFix_REPO = acidanthera/NVMeFix
NVMeFix_VERSION = 1.0.8
NVMeFix_BUILD = RELEASE

#################################### SSDT #####################################

SSDTS = SSDT-PNLF-CFL SSDT-XOSI
SSDTS += SSDT-EC-USBX-LAPTOP SSDT-PLUG-DRTNIA
SSDTS += SSDT-AWAC
SSDTS += SSDT-USB-Reset

############################# Modified GRUB shell #############################

modGRUBShell_VERSION = 1.1