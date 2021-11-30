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
## Consul UI:   http://localhost:8500/ui
## Nomad UI:    http://localhost:4646/ui
##-----------------------------------------------------------------

## config           dotify ~
function config {
    cp -r dotfiles/config/* ${HOME}/.config
}

## dev              Compose up
function dev {
    docker-compose -f dev/compose.yaml up -d
}
## not-dev                  down
function not-dev {
    docker-compose  -f dev/compose.yaml down --remove-orphans
}

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


## job             Workload Scheduling
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
    read -p "Press any key to continue."
}

${@:-ctl_loop}
