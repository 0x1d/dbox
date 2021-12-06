SRCD ?= $(shell pwd)

default: ctl

it: configure
so: install

ctl:
	./ctl.sh

configure:
	cp -r dotfiles/config/* ${HOME}/.config

install: configure
	sudo cp -r os/etc/nixos/dbox.nix /etc/nixos/
	sudo nixos-rebuild switch

nomad:
	sudo cp -r os/etc/nomad.d/* /etc/nomad.d

# ------------------------------------------------------

nixpkgs:
	git clone https://github.com/NixOS/nixpkgs.git nixpkgs

iso: nixpkgs
	cd nixpkgs/nixos && nix-build \
		-A config.system.build.isoImage \
		-I nixos-config=modules/installer/cd-dvd/installation-cd-minimal.nix

image-aarch64:
	cd nixpkgs/nixos && nix-build nixos \
		-I nixos=${SRCD}/os/configuration.nix \
		nixos-config=nixos/modules/installer/sd-card/sd-image-aarch64.nix \
		-A config.system.build.sdImage

vm:
	NIXOS_CONFIG=${SRCD}/os/vm.nix nixos-rebuild -I nixos=${SRCD}/os/configuration.nix build-vm
	./result/bin/run-vmhost-vm

# ------------------------------------------------------

TARGETS = $(shell ls apps)
$(TARGETS):
	./ctl.sh up apps/$@
