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

iso:
	nixos-generate -f iso -c default.nix

vm:
	NIXOS_CONFIG=${SRCD}/os/vm.nix \
		nixos-rebuild -I nixos=${SRCD}/os/configuration.nix build-vm \
		./result/bin/run-vmhost-vm

# ------------------------------------------------------

TARGETS = $(shell ls apps)
$(TARGETS):
	./ctl.sh up apps/$@
