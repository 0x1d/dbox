deps: k3d-install waypoint-install

install:
	cp -r dotfiles/config/* ${HOME}/.config
	sudo cp configuration.nix /etc/nixos/configuration.nix
	sudo nixos-rebuild switch

TARGETS = $(shell ls apps)
$(TARGETS):
	./ctl.sh up apps/$@

include dev.mk