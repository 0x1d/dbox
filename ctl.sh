#!/usr/bin/env bash
##
## ▓██   ██▓ ▄▄▄       ██ ▄█▀ ▒█████    ██████ 
##  ▒██  ██▒▒████▄     ██▄█▒ ▒██▒  ██▒▒██    ▒ 
##   ▒██ ██░▒██  ▀█▄  ▓███▄░ ▒██░  ██▒░ ▓██▄   
##   ░ ▐██▓░░██▄▄▄▄██ ▓██ █▄ ▒██   ██░  ▒   ██▒
##   ░ ██▒▓░ ▓█   ▓██▒▒██▒ █▄░ ████▓▒░▒██████▒▒
##    ██▒▒▒  ▒▒   ▓▒█░▒ ▒▒ ▓▒░ ▒░▒░▒░ ▒ ▒▓▒ ▒ ░
##  ▓a██ ░▒░   ▒   ▒▒ ░░ ░▒ ▒░  ░ ▒ ▒░ ░ ░▒  ░ ░
##  ▒ ▒ ░░    ░   ▒   ░ ░░ ░ ░ ░ ░ ▒  ░  ░  ░  
##  ░ ░           ░  ░░  ░       ░ ░        ░  
##  ░ ░                                        
##
## Welcome to the DISCO -
## Decentralized Infrastructure for Serverless Compute Operations
##
#-----------------------------------------------------------------
# Consul:    http://$hostname:8500/ui
# Nomad:     http://$hostname:4646/ui
# Syncthing: http://$hostname:8384/
#-----------------------------------------------------------------
##
## ~> System ------------------------------------------------------
##
## config           Configure
function config {
    spacevim dotfiles/config
}
## bootstrap        Bootstrap
function bootstrap {
    make it so
}

##
## ~> Docker ------------------------------------------------------
##
## dcu              Compose up
function dcu {
    pushd dev
        docker-compose up
    popd
    ctl_continue
}
## dcd              Compose down
function dcd {
    pushd dev
        docker-compose down --remove-orphans
    popd
}
## dps              Show running containers
function dps {
    docker ps \
    | fzf --height=10 --layout=reverse \
    | awk '{ print $1}' | xargs docker inspect
    ctl_continue
}
##
## ~> Orchestrator -------------------------------------------------
##
## ui               Start web interface
function ui {
    hashi-ui --consul-enable --nomad-enable
    ctl_continue
}
## status           Query job status
function status {
    nomad status \
    | fzf --height=10 --layout=reverse \
    | awk '{ print $1}' | xargs nomad status
    ctl_continue
}
## job              Scheduling
function job {
    pushd jobs
        ls \
        | fzf --height=10 --layout=reverse \
        | xargs nomad job $@ 
    popd
  ctl_continue
}

##  └── plan        Plan worload
function plan {
    job plan 
}

##  └── run         Schedule workload
function run {
    job run
}




# server           Bootstrap control-plane
function server {
    sudo nomad agent \
        -server \
        -config=./os/etc/nomad.d/server.hcl \
        -bootstrap-expect=3
}

# client           Join data-plane
function client {
    sudo nomad agent \
        -client \
        -config=./os/etc/nomad.d/client.hcl \
        join 
}

function ctl_nomad_info {
    nomad node status
    printf "\n-----------------------------------------------------------------\n\n"
    nomad status
    printf "\n"
    printf "\n-----------------------------------------------------------------\n\n"
}

function ctl_info {
    clear
    sed -n 's/^##//p' ctl.sh 
    printf "\n-----------------------------------------------------------------\n\n"
}

function ctl_loop {
    ctl_info
    read -p 'Choose: ';
    ./ctl.sh ${REPLY}
    ctl_loop
}

function ctl_continue {
    read -p "Press [ENTER] to continue."
}

${@:-ctl_loop}
