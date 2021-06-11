OC_VERSION = 0.6.6
OC_BUILD = RELEASE

KEXTS += VirtualSMC SMCProcessor SMCSuperIO SMCBatteryManager Lilu WhateverGreen AppleALC VoodooInput VoodooPS2Controller 
#KEXTS += IntelBluetoothFirmware IntelBluetoothInjector itlwm
KEXTS += USBMap AsusSMC

VirtualSMC_REPO = acidanthera/VirtualSMC
VirtualSMC_VERSION = 1.2.0
VirtualSMC_BUILD = RELEASE

Lilu_REPO = acidanthera/Lilu
Lilu_VERSION = 1.5.1
Lilu_BUILD = RELEASE

WhateverGreen_REPO = acidanthera/WhateverGreen
WhateverGreen_VERSION = 1.4.7
WhateverGreen_BUILD = RELEASE

AppleALC_REPO = acidanthera/AppleALC
AppleALC_VERSION = 1.5.7
AppleALC_BUILD = RELEASE

VoodooInput_REPO = acidanthera/VoodooInput
VoodooInput_VERSION = 1.1.0
VoodooInput_BUILD = RELEASE

VoodooPS2Controller_REPO = acidanthera/VoodooPS2
VoodooPS2Controller_VERSION = 2.2.1
VoodooPS2Controller_BUILD = RELEASE

AsusSMC_REPO = hieplpvip/AsusSMC
AsusSMC_VERSION = 1.4.1
AsusSMC_BUILD = RELEASE

SSDTS = SSDT-PLUG-DRTNIA SSDT-EC-USBX-LAPTOP SSDT-GPI0 SSDT-PNLF

modGRUBShell_VERSION = 1.1