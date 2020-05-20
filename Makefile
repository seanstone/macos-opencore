.PHONY: macos
macos:
	gibMacOS/gibMacOS.command -r -v Catalina

.PHONY: opencore
opencore: OpenCore

OpenCore: OpenCore-0.5.8-RELEASE.zip
	mkdir -p $@
	unzip $< -d $@

OpenCore-0.5.8-RELEASE.zip:
	wget https://github.com/acidanthera/OpenCorePkg/releases/download/0.5.8/OpenCore-0.5.8-RELEASE.zip