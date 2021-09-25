SHELL=/bin/bash

up: ctl.sh
	./$< $@ components/nextcloud

down: ctl.sh
	./$< $@ components/nextcloud

include components/infranodus.mk