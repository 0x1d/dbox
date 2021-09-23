#!/bin/bash

APP=${APP:-app}
ENV=${ENV:-~/.shire}
SRC=${SRC:-https://github.com/0x1d/app.git}
BRANCH=${BRANCH:-master}
ENV_FILE=${ENV_FILE:-$ENV/$APP/.env}

[[ -f $ENV_FILE ]] && echo "Using $ENV_FILE" || (echo "Initalize $ENV_FILE" ; init)

function info {
    clear
    echo "------------------------------------------------------------"
    echo $APP
    echo "------------------------------------------------------------"
    cat $ENV_FILE
    echo "------------------------------------------------------------"
    sed -n 's/^##//p' /usr/local/bin/ctl.sh
    echo "------------------------------------------------------------"
    tree -d
}


##ctx         Run in app ENV
function ctx {
    pushd $ENV
        info
        $@
    popd
}

##init        Initialize app ENV
function init {
    git clone --single-branch --branch ${BRANCH} ${SRC} ${ENV}
    cp app.env $ENV/$APP/.env
}

##cnt       Run in privileged container
function cnt {
    docker run --rm --privileged \
        --workdir /workspace  \
        --volume ${PWD}:/workspace \
        --volume /dev:/dev \
        $@
}

##up   Just docker-compose up
function up {
    docker-compose --env-file $@.env -f $@.yml up --remove-orphans --force-recreate 
}

##compose   Just docker-compose
function compose {
    docker-compose $@
}

##build       Build app
function build {
    ctx compose build
}

##run         Run app
function run {
    compose up --remove-orphans --force-recreate --detach
}

##stop        Stop app
function stop {
    compose stop
}

##down      Shutdown app
function down {
    compose down
    rm -rf $ENV/$APP
}

##remove      Remove app and data
function remove {
    compose down
    rm -rf $ENV/$APP
}

${@:-info}
