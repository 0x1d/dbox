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
## 
##|------------------------------------------------------------
## Consul UI:   http://localhost:8500/ui
## Nomad UI:    http://localhost:4646/ui
##|------------------------------------------------------------
## 

## info		Display this info
function info {
    clear
    sed -n 's/^##//p' ctl.sh
    printf "\n------------------------------------------------------------\n"
    #tree -d
    nomad node status
    printf "\n\n"
    read -p 'Choose: ';
    echo "";
    ./ctl.sh ${REPLY}
}

## nwa		Start network agent
function nwa {
    consul agent -dev
}

## wsa		Start workload scheduling agent
function wsa {
    nomad agent -dev-connect
}

## run		Run workload
function run {
    pushd jobs 
        ls | fzf | xargs nomad job run 
    popd
    ctl_loop
}

function ctl_loop {
    read -p "Press any key to continue."
    info
}

${@:-info}
