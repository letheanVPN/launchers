VERSION_CLI=4.0.4
VERSION_GUI=4.0.6
VERSION_SERVER=2.0.5



all: help

build-base: clean
	mkdir -p build/conf build/wallets build/users build/data/objects

build-windows: build-base windows-cli windows-server windows-gui apply-perms ## Builds Windows Download package
	cp -r ./windows/* ./build/
	cd build && zip -m9r ../windows-lethean.zip ./

build-linux: build-base linux-cli linux-server linux-gui apply-perms ## Builds Linux Download package
	cp -r ./linux-macos/* ./build/
	cd build && tar -zcvf ../linux-lethean.tar ./

build-macos: build-base macos-cli macos-amd64-server macos-gui apply-perms ## Builds Macos Download package
	cp -r ./linux-macos/* ./build/
	cd build && tar -zcvf ../macos-lethean.tar ./

build-macos-arm64: build-base macos-cli macos-arm64-server macos-arm64-gui apply-perms ## Builds Macos Download package
	cp -r ./linux-macos/* ./build/
	cd build && tar -zcvf ../macos-arm64-lethean.tar ./

build-macos-amd64: build-base macos-cli macos-amd64-server macos-amd64-gui apply-perms ## Builds Macos Download package
	cp -r ./linux-macos/* ./build/
	cd build && tar -zcvf ../macos-amd64-lethean.tar ./

apply-perms:
	chmod +x build/cli/lethean* build/lethean-*

sign-macos:
	codesign -s 'Developer ID Application: Lethean LTD (W2DNA5L5DY)' --no-strict **/lethean* || true

windows-cli: ## Download Windows CLI
	[ -f ./build/cli/letheand.exe ] || mkdir -p build/cli && wget https://github.com/letheanVPN/blockchain/releases/download/v${VERSION_CLI}/lethean-${VERSION_CLI}-windows.zip && unzip -j lethean-${VERSION_CLI}-windows.zip  -d ./build/cli/ -x **/._* && rm lethean-${VERSION_CLI}-windows.zip;

linux-cli:  ## Download Linux CLI
	[ -f ./build/cli/letheand ] || mkdir -p build/cli && wget https://github.com/letheanVPN/blockchain/releases/download/v${VERSION_CLI}/lethean-${VERSION_CLI}-linux.zip && unzip -j lethean-${VERSION_CLI}-linux.zip  -d ./build/cli/ -x **/._* && rm lethean-${VERSION_CLI}-linux.zip

macos-cli:  ## Download macOS CLI
	[ -f ./build/cli/letheand ] || mkdir -p build/cli && wget https://github.com/letheanVPN/blockchain/releases/download/v${VERSION_CLI}/lethean-${VERSION_CLI}-macOS.zip && unzip -j lethean-${VERSION_CLI}-macOS.zip  -d ./build/cli/ -x **/._* && rm lethean-${VERSION_CLI}-macOS.zip;

windows-gui:
	cd build && wget https://github.com/letheanVPN/desktop/releases/download/v${VERSION_GUI}/windows-lethean-desktop.zip && unzip windows-lethean-desktop.zip && rm windows-lethean-desktop.zip

windows-server:
	cd build && wget https://github.com/letheanVPN/lethean-server/releases/download/v${VERSION_SERVER}/windows.zip && unzip -j windows.zip && rm windows.zip

linux-gui:
	cd build && wget https://github.com/letheanVPN/desktop/releases/download/v${VERSION_GUI}/linux-lethean-desktop.tar && tar -xvf linux-lethean-desktop.tar && rm linux-lethean-desktop.tar

linux-server:
	cd build && wget https://github.com/letheanVPN/lethean-server/releases/download/v${VERSION_SERVER}/linux.zip &&  unzip -j linux.zip  && rm linux.zip

macos-amd64-server:
	cd build && wget https://github.com/letheanVPN/lethean-server/releases/download/v${VERSION_SERVER}/macos-intel.zip &&  unzip -j macos-intel.zip  && rm macos-intel.zip

macos-arm64-server:
	cd build && wget https://github.com/letheanVPN/lethean-server/releases/download/v${VERSION_SERVER}/macos-arm.zip &&  unzip -j macos-arm.zip && rm macos-arm.zip

macos-gui:
	cd build && wget https://github.com/letheanVPN/desktop/releases/download/v${VERSION_GUI}/macos-lethean-desktop.tar && tar -xvf macos-lethean-desktop.tar && rm macos-lethean-desktop.tar

macos-amd64-gui:
	cd build && wget https://github.com/letheanVPN/desktop/releases/download/v${VERSION_GUI}/macos-amd64-lethean-desktop.tar && tar -xvf macos-amd64-lethean-desktop.tar && rm macos-amd64-lethean-desktop.tar

macos-arm64-gui:
	cd build && wget https://github.com/letheanVPN/desktop/releases/download/v${VERSION_GUI}/macos-arm64-lethean-desktop.tar && tar -xvf macos-arm64-lethean-desktop.tar && rm macos-arm64-lethean-desktop.tar

start-chain:
	./build/cli/letheand --data-dir $(shell pwd)/data

start-chain-full:
	./build/cli/letheand --data-dir $(shell pwd)/data --confirm-external-bind --rpc-bind-ip 0.0.0.0 --detach

export-chain:
	./build/cli/lethean-blockchain-export --data-dir $(shell pwd)/data --output-file $(shell pwd)/data/export/blockchain.raw

import-chain:
	./build/cli/lethean-blockchain-import --data-dir $(shell pwd)/data --input-file $(shell pwd)/data/export/blockchain.raw --prep-blocks-threads 1 --batch-size 1000

rsync-export:
	rsync --progress -rd rsync://seed.lethean.io:12000/export/blockchain.raw $(shell pwd)/data/export/blockchain.raw

help: ## Show this help
	@egrep -h '\s##\s' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m make %-30s\033[0m %s\n", $$1, $$2}'

clean:
	rm -rf build

.PHONY: help all clean
