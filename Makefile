info:
	./ctl.sh

nixpkgs:
	git clone https://github.com/NixOS/nixpkgs.git nixpkgs

iso: nixpkgs
	cd nixpkgs/nixos && nix-build \
		-A config.system.build.isoImage \
		-I nixos-config=modules/installer/cd-dvd/installation-cd-minimal.nix

image-aarch64:
	cd nixpkgs/nixos && nix-build nixos \
		-I nixos=${PWD}/os/configuration.nix \
		nixos-config=nixos/modules/installer/sd-card/sd-image-aarch64.nix \
		-A config.system.build.sdImage

vm:
	NIXOS_CONFIG=${PWD}/os/vm.nix nixos-rebuild -I nixos=${PWD}/os/configuration.nix build-vm
	./result/bin/run-vmhost-vm

configure:
	cp -r dotfiles/config/* ${HOME}/.config

install: configure
	sudo mkdir -p /etc/nomad/
	sudo cp os/dbox.nix /etc/nixos/configuration.nix
	sudo cp -r os/etc/nomad/* /etc/nomad/
	sudo nixos-rebuild switch

rebuild:
	nixos-rebuild

TARGETS = $(shell ls apps)
$(TARGETS):
	./ctl.sh up apps/$@

include dev.mk