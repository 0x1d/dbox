WAYPOINT_VERSION=0.7.1
PATH=$PATH:$HOME/bin

it: install
so: up
not: destroy
away: uninstall

install: install-docker

up:
	waypoint init && waypoint up
destroy:
	waypoint destroy -auto-approve
uninstall:
	waypoint server uninstall -auto-approve
clear:
	waypoint context clear

install-kubernetes: install-bin
	waypoint install --platform=kubernetes -accept-tos
	waypoint ui -authenticate
install-docker: install-bin
	waypoint install --platform=docker -accept-tos
	waypoint ui -authenticate
install-nomad: install-bin
	waypoint install -platform=nomad -accept-tos
	waypoint ui -authenticate

install-bin:
	wget https://releases.hashicorp.com/waypoint/${WAYPOINT_VERSION}/waypoint_${WAYPOINT_VERSION}_linux_amd64.zip
	unzip waypoint_${WAYPOINT_VERSION}_linux_amd64.zip
	mv waypoint ~/bin/
	rm waypoint_${WAYPOINT_VERSION}_linux_amd64.zip	