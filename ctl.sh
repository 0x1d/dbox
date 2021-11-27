#!/usr/bin/env bash
## 
## ██████╗ ██████╗  ██████╗ ██╗  ██╗
## ██╔══██╗██╔══██╗██╔═══██╗╚██╗██╔╝
## ██║  ██║██████╔╝██║   ██║ ╚███╔╝ 
## ██║  ██║██╔══██╗██║   ██║ ██╔██╗ 
## ██████╔╝██████╔╝╚██████╔╝██╔╝ ██╗
## ╚═════╝ ╚═════╝  ╚═════╝ ╚═╝  ╚═╝             
##                 
## Another Open Source DISCO Environment
##
##-----------------------------------------------------------------
## Consul UI:   http://localhost:8500/ui
## Nomad UI:    http://localhost:4646/ui
##-----------------------------------------------------------------


## install          Install
install () {
    sudo cp ./ctl.sh /bin/yak
}

## config           dotify ~
config () {
    cp -r dotfiles/config/* ${HOME}/.config
}

## dev              Compose up
dev () {
    docker-compose -f dev/compose.yaml up -d
}
## not-dev                  down
not-dev () {
    docker-compose  -f dev/compose.yaml down --remove-orphans
}

##-----------------------------------------------------------------

## job             Workload Scheduling
job () {
    pushd jobs
        ls \
        | fzf --height=10 --layout=reverse \
        | xargs nomad job $@ 
    popd
    ctl_continue
}

##  └── plan
plan () {
    job plan 
}

##  └── run
run () {
    job run
}

## status
 status () {
    nomad status \
    | fzf --height=10 --layout=reverse \
    | awk '() { print $1}' | xargs nomad status
    ctl_continue
}

ctl_info () {
    clear
    sed -n 's/^##//p' ctl.sh 
    printf "\n-----------------------------------------------------------------\n\n"
    nomad node status
    printf "\n-----------------------------------------------------------------\n\n"
    nomad status
    printf "\n"
    printf "\n-----------------------------------------------------------------\n\n"
}

ctl_loop () {
    ctl_info
    read -p 'Choose: ';
    ./ctl.sh $() {REPLY}
    ctl_loop
}

ctl_continue () {
    read -p "Press any key to continue."
}

${@:-ctl_loop}
