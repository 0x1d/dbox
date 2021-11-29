dev-deps: k3d-install waypoint-install

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

##cni-install	for consul-connect integration
cni-install:
	curl -L -o cni-plugins.tgz "https://github.com/containernetworking/plugins/releases/download/v1.0.1/cni-plugins-linux-amd64-v1.0.1.tgz"
	sudo mkdir -p /opt/cni/bin
	sudo tar -C /opt/cni/bin -xzf cni-plugins.tgz