WINDOWS_CLI=https://github.com/letheanVPN/blockchain/releases/download/v4.0.4/lethean-4.0.4-windows.zip
LINUX_CLI=https://github.com/letheanVPN/blockchain/releases/download/v4.0.4/lethean-4.0.4-linux.zip
MACOS_CLI=https://github.com/letheanVPN/blockchain/releases/download/v4.0.4/lethean-4.0.4-macOS.zip

WINDOWS_SERVER=https://github.com/letheanVPN/launchers/releases/download/server/windows.zip
LINUX_SERVER=https://github.com/letheanVPN/launchers/releases/download/server/linux.zip
MACOS_SERVER=https://github.com/letheanVPN/launchers/releases/download/server/macos-intel.zip

WINDOWS_GUI=https://github.com/letheanVPN/desktop/releases/download/v4.0.3/windows-lethean-desktop.zip
LINUX_GUI=https://github.com/letheanVPN/desktop/releases/download/v4.0.3/linux-lethean-desktop.tar
MACOS_GUI=https://github.com/letheanVPN/desktop/releases/download/v4.0.3/macos-lethean-desktop.tar

all:
	echo "read the file"

build-base:
	mkdir -p build/conf build/wallets build/users build/data/objects

build-windows: build-base windows-cli windows-server windows-gui apply-perms
	cp -r ./windows/* ./build/
	cd build && tar -zcvf ../windows-lethean.tar ./

build-linux: build-base linux-cli linux-server linux-gui apply-perms
	cp -r ./linux-macos/* ./build/
	cd build && tar -zcvf ../linux-lethean.tar ./

build-macos: build-base macos-cli macos-server macos-gui apply-perms
	cp -r ./linux-macos/* ./build/
	cd build && tar -zcvf ../macos-lethean.tar ./

apply-perms:
	chmod +x build/cli/lethean* build/lethean-*

sign-macos:
	codesign -s 'Developer ID Application: Lethean LTD (W2DNA5L5DY)' --no-strict **/lethean* || true

windows-cli:
	wget ${WINDOWS_CLI}
	unzip -j lethean-4.0.4-windows.zip  -d ./build/cli/ -x **/._*
	rm lethean-4.0.4-windows.zip

linux-cli:
	wget ${LINUX_CLI}
	unzip -j lethean-4.0.4-linux.zip  -d ./build/cli/ -x **/._*
	rm lethean-4.0.4-linux.zip

macos-cli:
	wget ${MACOS_CLI}
	unzip -j lethean-4.0.4-macOS.zip  -d ./build/cli/ -x **/._*
	rm lethean-4.0.4-macOS.zip

windows-gui:
	cd build && wget ${WINDOWS_GUI} && unzip windows-lethean-desktop.zip && rm windows-lethean-desktop.zip

windows-server:
	cd build && wget ${WINDOWS_SERVER} && unzip windows.zip && rm windows.zip

linux-gui:
	cd build && wget ${LINUX_GUI} && tar -xvf linux-lethean-desktop.tar && rm linux-lethean-desktop.tar

linux-server:
	cd build && wget ${LINUX_SERVER} && unzip linux.zip && rm linux.zip

macos-server:
	cd build && wget ${MACOS_SERVER} && unzip macos-intel.zip && rm macos-intel.zip

macos-gui:
	cd build && wget ${MACOS_GUI} && tar -xvf macos-lethean-desktop.tar && rm macos-lethean-desktop.tar

clean:
	rm -rf build