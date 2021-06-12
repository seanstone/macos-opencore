################################# OpenCore ###################################

OC_VERSION = 0.7.0
OC_BUILD = DEBUG

OC_DRIVERS = OpenRuntime HfsPlus
#OC_DRIVERS += CrScreenshotDxe OpenCanopy OpenHfsPlus
OC_TOOLS = OpenShell
#OC_TOOLS += ControlMsrE2 CsrUtil

################################## Kexts #####################################

KEXTS += VirtualSMC Lilu
#KEXTS += SMCProcessor SMCSuperIO SMCBatteryManager
#KEXTS += SMCLightSensor
KEXTS += WhateverGreen
#KEXTS += AppleALC
#KEXTS += AirportItlwm IntelBluetoothFirmware
#KEXTS += NVMeFix
#KEXTS += VoodooInput VoodooPS2Controller 
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

#################################### SSDT #####################################

SSDTS = SSDT-PNLF-CFL SSDT-XOSI
SSDTS += SSDT-EC-USBX-LAPTOP SSDT-PLUG-DRTNIA
SSDTS += SSDT-AWAC SSDT-RHUB

############################# Modified GRUB shell #############################

modGRUBShell_VERSION = 1.1