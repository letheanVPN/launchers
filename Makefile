WINDOWS_CLI=https://github.com/letheanVPN/blockchain/releases/download/v4.0.4/lethean-4.0.4-windows.zip
LINUX_CLI=https://github.com/letheanVPN/blockchain/releases/download/v4.0.4/lethean-4.0.4-linux.zip
MACOS_CLI=https://github.com/letheanVPN/blockchain/releases/download/v4.0.4/lethean-4.0.4-macOS.zip

WINDOWS_SERVER=https://github.com/letheanVPN/launchers/releases/download/server/windows.zip
LINUX_SERVER=https://github.com/letheanVPN/launchers/releases/download/server/linux.zip
MACOS_SERVER=https://github.com/letheanVPN/launchers/releases/download/server/macos-intel.zip

WINDOWS_GUI=https://github.com/letheanVPN/workstation/releases/download/v4.0.0/lethean.exe.zip
LINUX_GUI=https://github.com/letheanVPN/workstation/releases/download/v4.0.0/lethean.zip
MACOS_GUI=https://github.com/letheanVPN/workstation/releases/download/v4.0.0/lethean.app.zip

all:
	echo "read the file"

build-base:
	mkdir -p build/conf build/wallets build/users build/data/objects

build-windows: build-base windows-cli windows-server windows-gui apply-perms sign-macos
	cp -r ./windows/* ./build/
	cd build && zip -m9r ../windows.zip ./

build-linux: build-base linux-cli linux-server linux-gui apply-perms sign-macos
	cp -r ./linux-macos/* ./build/
	cd build && zip -m9r ../linux.zip ./

build-macos: build-base macos-cli macos-server macos-gui apply-perms sign-macos
	cp -r ./linux-macos/* ./build/
	cd build && zip -m9r ../macos.zip ./

apply-perms:
	chmod +x **/lethean*

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
	cd build && wget ${WINDOWS_GUI} && unzip lethean.exe.zip && rm lethean.exe.zip

windows-server:
	cd build && wget ${WINDOWS_SERVER} && unzip windows.zip && rm windows.zip

linux-gui:
	cd build && wget ${LINUX_GUI} && unzip lethean.zip && rm lethean.zip

linux-server:
	cd build && wget ${LINUX_SERVER} && unzip linux.zip && rm linux.zip

macos-server:
	cd build && wget ${MACOS_SERVER} && unzip macos-intel.zip && rm macos-intel.zip

macos-gui:
	cd build && wget ${MACOS_GUI} && unzip lethean.app.zip && rm lethean.app.zip

clean:
	rm -rf build