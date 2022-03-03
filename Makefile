WINDOWS_CLI=https://github.com/letheanVPN/blockchain/releases/download/v4.0.4/lethean-4.0.4-windows.zip
LINUX_CLI=https://github.com/letheanVPN/blockchain/releases/download/v4.0.4/lethean-4.0.4-linux.zip
MACOS_CLI=https://github.com/letheanVPN/blockchain/releases/download/v4.0.4/lethean-4.0.4-macOS.zip

WINDOWS_SERVER=https://github.com/letheanVPN/lethean-server/releases/download/v2.0.1/windows-lethean-server.exe
LINUX_SERVER=https://github.com/letheanVPN/lethean-server/releases/download/v2.0.1/linux-lethean-server
MACOS_SERVER=https://github.com/letheanVPN/lethean-server/releases/download/v2.0.1/macos-lethean-server

WINDOWS_GUI=https://github.com/letheanVPN/desktop/releases/download/v4.0.4/windows-lethean-desktop.zip
LINUX_GUI=https://github.com/letheanVPN/desktop/releases/download/v4.0.4/linux-lethean-desktop.tar
MACOS_GUI=https://github.com/letheanVPN/desktop/releases/download/v4.0.4/macos-lethean-desktop.tar

all:
	echo "read the file"

build-base:
	mkdir -p build/conf build/wallets build/users build/data/objects

build-windows: build-base windows-cli windows-server windows-gui apply-perms
	cp -r ./windows/* ./build/
	cd build && zip -m9r ../windows-lethean.zip ./

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
	cd build && wget ${WINDOWS_SERVER} && mv windows-lethean-server.exe lethean-server.exe

linux-gui:
	cd build && wget ${LINUX_GUI} && tar -xvf linux-lethean-desktop.tar && rm linux-lethean-desktop.tar

linux-server:
	cd build && wget ${LINUX_SERVER} &&  mv linux-lethean-server lethean-server

macos-server:
	cd build && wget ${MACOS_SERVER} &&  mv macos-lethean-server lethean-server

macos-gui:
	cd build && wget ${MACOS_GUI} && tar -xvf macos-lethean-desktop.tar && rm macos-lethean-desktop.tar

clean:
	rm -rf build
