TARGETS = $(shell ls apps)

info:
	kubectl cluster-info

it:
	$(MAKE) i3

$(TARGETS):
	./ctl.sh up apps/$@

cluster:
	k3d cluster create
	kubectl config use-context k3d-k3s-default
	kubectl cluster-info

waypoint:
	waypoint install --platform=kubernetes -accept-tos

destroy:
	k3d cluster delete