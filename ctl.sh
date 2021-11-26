#!/usr/bin/env bash
## 
## ▓██   ██▓ ▄▄▄       ██ ▄█▀ ▒█████    ██████ 
##  ▒██  ██▒▒████▄     ██▄█▒ ▒██▒  ██▒▒██    ▒ 
##   ▒██ ██░▒██  ▀█▄  ▓███▄░ ▒██░  ██▒░ ▓██▄   
##   ░ ▐██▓░░██▄▄▄▄██ ▓██ █▄ ▒██   ██░  ▒   ██▒
##   ░ ██▒▓░ ▓█   ▓██▒▒██▒ █▄░ ████▓▒░▒██████▒▒
##    ██▒▒▒  ▒▒   ▓▒█░▒ ▒▒ ▓▒░ ▒░▒░▒░ ▒ ▒▓▒ ▒ ░
##  ▓██ ░▒░   ▒   ▒▒ ░░ ░▒ ▒░  ░ ▒ ▒░ ░ ░▒  ░ ░
##  ▒ ▒ ░░    ░   ▒   ░ ░░ ░ ░ ░ ░ ▒  ░  ░  ░  
##  ░ ░           ░  ░░  ░       ░ ░        ░  
##  ░ ░                                        
## 
## A DISCO Environment
## > Decentralized Infrastructure for Serverless Compute Operations
##-----------------------------------------------------------------
## Consul UI:   http://localhost:8500/ui
## Nomad UI:    http://localhost:4646/ui
##-----------------------------------------------------------------
## 

## install          Install
function install {
    sudo cp ./ctl.sh /bin/yak
}

## config           Configure ~
function config {
    cp -r dotfiles/config/* ${HOME}/.config
}

## dev              Development mode
function dev {
    docker-compose -f dev/compose.yaml up -d
}

## run              Run a job
function run {
    pushd jobs 
        ls \
        | fzf --height=10 --layout=reverse \
        | xargs nomad job run 
    popd
}

## service          Interact with service
function service {
    nomad status \
    | fzf --height=10 --layout=reverse \
    | awk '{ print $1}' | xargs nomad status
    ctl_continue
}

function ctl_info {
    clear
    sed -n 's/^##//p' ctl.sh 
    printf "\n-----------------------------------------------------------------\n\n"
    #tree -d
    nomad node status
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
