#!/usr/bin/env bash

BIN_PATH=${BIN_PATH:-/run/current-system/sw/bin}

RED="31"
GREEN="32"
GREENBLD="\e[1;${GREEN}m"
REDBOLD="\e[1;${RED}m"
REDITALIC="\e[3;${RED}m"
EC="\e[0m"

##
## ~> System ------------------------------------------------------
##
function info {
    ctl_info
    ctl_continue
}
## config           Configure
function config {
    starship init fish --print-full-init > dotfiles/config/yakrc
    spacevim dotfiles/config
}
## bootstrap        Install configuration and rebuild system
function bootstrap {
    make it so
    ctl_continue
}
## shell            Interact with Starship
function shell {
    starship explain
    source .yakrc
    ctl_continue
}

## reboot           ReShave your yak
function reboot {
    reboot
}
## shutdown         Let your yak sleep with the fishes
function shutdown {
    shutdown -h now
}

##
## ~> Daemons ----------------------------------------------------
##
## nsa              Nomad Server Agent
function server {
    sudo nomad agent \
        -server \
        -config=./os/etc/nomad.d/server-single.hcl \
        -bootstrap-expect=1
}

## nca              Nomad Client Agent
function client {
    sudo nomad agent \
        -client \
        -config=./os/etc/nomad.d/client.hcl
}
## ui               Web interface
function ui {
    hashi-ui --consul-enable --nomad-enable
    ctl_continue
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



function ctl_nomad_info {
    nomad node status
    printf "\n-----------------------------------------------------------------\n\n"
    nomad status
    printf "\n"
    printf "\n-----------------------------------------------------------------\n\n"
}

function ctl_info {
    clear
    echo -e "${GREENBLD}$(cat motd)${EC}"
    sed -n 's/^##//p' ctl.sh 
    printf "\n-----------------------------------------------------------------\n\n"
}

function ctl_loop {
    ctl_info
    echo -e "${REDBOLD}Choose operation...${EC}"
    read -p '> ';
    ./ctl.sh ${REPLY}
    ctl_loop
}

function ctl_continue {
    read -p "Press [ENTER] to continue."
}

${@:-ctl_loop}
