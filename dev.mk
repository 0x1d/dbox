waypoint-install:
	curl -fsSL https://apt.releases.hashicorp.com/gpg | sudo apt-key add -
	sudo apt-add-repository "deb [arch=amd64] https://apt.releases.hashicorp.com $(lsb_release -cs) main"
	sudo apt-get update && sudo apt-get install waypoint
waypoint-cluster: cluster-create
	-waypoint install --platform=kubernetes -accept-tos
	waypoint ui -authenticate
waypoint-up:
	waypoint init && waypoint up
not-waypoint-cluster: not-cluster
	waypoint context clear

k3d-install:
	curl -s https://raw.githubusercontent.com/rancher/k3d/main/install.sh | bash
cluster-create:
	-k3d cluster create demostream --agents 1
	kubectl config use-context k3d-demostream
	kubectl cluster-info
not-cluster:
	k3d cluster delete demostream
