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
## A DISCO Environment
##
##-----------------------------------------------------------------
# Consul:    http://$hostname:8500/ui
# Nomad:     http://$hostname:4646/ui
# Syncthing: http://$hostname:8384/
#-----------------------------------------------------------------

## config           Configure node
function config {
    spacevim dotfiles/config
}
## provision        Bootstrap System
function provision {
    make it so
}

##-----------------------------------------------------------------

## dcud             Daemonized Compose
function dcud {
    docker-compose -f dev/compose.yaml up -d
}
## dcd              Compose down
function dcd {
    docker-compose -f dev/compose.yaml down --remove-orphans
}
##-----------------------------------------------------------------

## server           Bootstrap control-plane
function server {
    sudo nomad agent \
        -server \
        -config=./os/etc/nomad.d/server.hcl \
        -bootstrap-expect=3
}

## client           Join data-plane
function client {
    sudo nomad agent \
        -client \
        -config=./os/etc/nomad.d/client.hcl \
        join 
}

##-----------------------------------------------------------------


## job              Workload Scheduling
function job {
    pushd jobs
        ls \
        | fzf --height=10 --layout=reverse \
        | xargs nomad job $@ 
    popd
  ctl_continue
}

##  └── plan
function plan {
    job plan 
}

##  └── run
function run {
    job run
}

## status
function status {
    nomad status \
    | fzf --height=10 --layout=reverse \
    | awk '{ print $1}' | xargs nomad status
    ctl_continue
}

function ctl_info {
    clear
    sed -n 's/^##//p' ctl.sh 
    printf "\n-----------------------------------------------------------------\n\n"
    nomad node status
    printf "\n-----------------------------------------------------------------\n\n"
    nomad status
    printf "\n"
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
