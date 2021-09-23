SHELL=/bin/bash
up: ctl.sh
	./$< $@ nextcloud
down: ctl.sh
	./$< $@ nextcloud
