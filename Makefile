deps: k3d-install waypoint-install

TARGETS = $(shell ls apps)
$(TARGETS):
	./ctl.sh up apps/$@

include dev.mk