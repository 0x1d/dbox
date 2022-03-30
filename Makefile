SHELL ?= bash
SRCD ?= $(shell pwd)
DOTCONFIG = $(shell ls dotfiles/config)
USER_CONFIG = $(shell ls ~/.config)

default: info

it: kdi3
so: use

commit: collect
collect: ${DOTCONFIG}

update: dbox

ctl:
	./ctl.sh

home:
	-ln -s ${PWD}/ctl.sh ${HOME}/ctl.sh
	cp -r dotfiles/config/* ${HOME}/.config

kdi3:
	sudo cp -r os/kde-i3.nix /etc/nixos/configuration.nix

dbox: home
	sudo cp -r os/dbox.nix /etc/nixos/

use:
	sudo nixos-rebuild switch

$(DOTCONFIG):
	@printf "\nCollect Config: $@\n"
	cp -r ~/.config/$@ dotfiles/config
	
# ------------------------------------------------------

nixpkgs:
	git clone https://github.com/NixOS/nixpkgs.git nixpkgs

iso:
	nixos-generate -f iso -c default.nix

vm:
	NIXOS_CONFIG=${SRCD}/os/vm.nix \
		nixos-rebuild -I nixos=${SRCD}/kde-iso.nix build-vm
	./result/bin/run-vmhost-vm

# ------------------------------------------------------

info:
	@printf "Config:\n${DOTCONFIG}"

TARGETS = $(shell ls apps)
$(TARGETS):
	./ctl.sh up apps/$@
