VERSION_CLI=v4.0.4
VERSION_GUI=v4.0.4
VERSION_SERVER=v2.0.1



all: help

build-base:
	mkdir -p build/conf build/wallets build/users build/data/objects

build-windows: build-base windows-cli windows-server windows-gui apply-perms ## Builds Windows Download package
	cp -r ./windows/* ./build/
	cd build && zip -m9r ../windows-lethean.zip ./

build-linux: build-base linux-cli linux-server linux-gui apply-perms ## Builds Linux Download package
	cp -r ./linux-macos/* ./build/
	cd build && tar -zcvf ../linux-lethean.tar ./

build-macos: build-base macos-cli macos-server macos-gui apply-perms ## Builds Macos Download package
	cp -r ./linux-macos/* ./build/
	cd build && tar -zcvf ../macos-lethean.tar ./

apply-perms:
	chmod +x build/cli/lethean* build/lethean-*

sign-macos:
	codesign -s 'Developer ID Application: Lethean LTD (W2DNA5L5DY)' --no-strict **/lethean* || true

windows-cli: ## Download Windows CLI
	[ -f ./build/cli/letheand.exe ] || mkdir -p build/cli && wget https://github.com/letheanVPN/blockchain/releases/download/${VERSION_CLI}/lethean-4.0.4-windows.zip && unzip -j lethean-4.0.4-windows.zip  -d ./build/cli/ -x **/._* && rm lethean-4.0.4-windows.zip;

linux-cli:  ## Download Linux CLI
	[ -f ./build/cli/letheand ] || mkdir -p build/cli && wget https://github.com/letheanVPN/blockchain/releases/download/${VERSION_CLI}/lethean-4.0.4-linux.zip && unzip -j lethean-4.0.4-linux.zip  -d ./build/cli/ -x **/._* && rm lethean-4.0.4-linux.zip

macos-cli:  ## Download macOS CLI
	[ -f ./build/cli/letheand ] || mkdir -p build/cli && wget https://github.com/letheanVPN/blockchain/releases/download/${VERSION_CLI}/lethean-4.0.4-macOS.zip && unzip -j lethean-4.0.4-macOS.zip  -d ./build/cli/ -x **/._* && rm lethean-4.0.4-macOS.zip;

windows-gui:
	cd build && wget https://github.com/letheanVPN/desktop/releases/download/${VERSION_GUI}/windows-lethean-desktop.zip && unzip windows-lethean-desktop.zip && rm windows-lethean-desktop.zip

windows-server:
	cd build && wget https://github.com/letheanVPN/lethean-server/releases/download/${VERSION_SERVER}/windows-lethean-server.exe && mv windows-lethean-server.exe lethean-server.exe

linux-gui:
	cd build && wget https://github.com/letheanVPN/desktop/releases/download/${VERSION_GUI}/linux-lethean-desktop.tar && tar -xvf linux-lethean-desktop.tar && rm linux-lethean-desktop.tar

linux-server:
	cd build && wget https://github.com/letheanVPN/lethean-server/releases/download/${VERSION_SERVER}/linux-lethean-server &&  mv linux-lethean-server lethean-server

macos-server:
	cd build && wget https://github.com/letheanVPN/lethean-server/releases/download/${VERSION_SERVER}/macos-lethean-server &&  mv macos-lethean-server lethean-server

macos-gui:
	cd build && wget https://github.com/letheanVPN/desktop/releases/download/${VERSION_GUI}/macos-lethean-desktop.tar && tar -xvf macos-lethean-desktop.tar && rm macos-lethean-desktop.tar


start-chain:
	./build/cli/letheand --data-dir $(shell pwd)/data

start-chain-full:
	./build/cli/letheand --data-dir $(shell pwd)/data --confirm-external-bind --rpc-bind-ip 0.0.0.0 --detach

export-chain:
	./build/cli/lethean-blockchain-export --output-file $(shell pwd)/data/export/blockchain.raw

import-chain:
	./build/cli/lethean-blockchain-import --input-file $(shell pwd)/data/export/blockchain.raw --prep-blocks-threads 1 --batch-size 1000

help: ## Show this help
	@egrep -h '\s##\s' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m make %-30s\033[0m %s\n", $$1, $$2}'

clean:
	rm -rf build

.PHONY: help all clean