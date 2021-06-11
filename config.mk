################################# OpenCore ###################################

OC_VERSION = 0.7.0
OC_BUILD = RELEASE

OC_DRIVERS = CrScreenshotDxe HfsPlus OpenCanopy OpenHfsPlus OpenPartitionDxe OpenRuntime
OC_TOOLS = ControlMsrE2 CsrUtil OpenShell

################################## Kexts #####################################

KEXTS += VirtualSMC SMCProcessor SMCSuperIO SMCBatteryManager Lilu WhateverGreen AppleALC VoodooInput VoodooPS2Controller 
#KEXTS += IntelBluetoothFirmware IntelBluetoothInjector itlwm
#KEXTS += USBMap AsusSMC

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

AsusSMC_REPO = hieplpvip/AsusSMC
AsusSMC_VERSION = 1.4.1
AsusSMC_BUILD = RELEASE

#################################### SSDT #####################################

SSDTS = SSDT-PLUG-DRTNIA SSDT-EC-USBX-LAPTOP SSDT-GPI0 SSDT-PNLF

############################# Modified GRUB shell #############################

modGRUBShell_VERSION = 1.1