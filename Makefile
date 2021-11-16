info:
	./ctl.sh

vm:
	NIXOS_CONFIG=${PWD}/os/vm.nix nixos-rebuild -I nixos=${PWD}/os/configuration.nix build-vm
	./result/bin/run-vmhost-vm

configure:
	cp -r dotfiles/config/* ${HOME}/.config

install: configure
	sudo cp os/configuration.nix /etc/nixos/configuration.nix
	sudo nixos-rebuild switch

TARGETS = $(shell ls apps)
$(TARGETS):
	./ctl.sh up apps/$@

include dev.mk