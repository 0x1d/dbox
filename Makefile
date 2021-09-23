SHELL=/bin/bash

default: ctl.sh

.PHONY: ctl.sh
ctl.sh:
	./$@

up: ctl.sh
	./$< $@ apps/

down: ctl.sh
	./$< $@ apps/

include apps/infranodus/Makefile