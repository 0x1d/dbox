#!/bin/bash

APP=${APP:-dbox}
ENV=${ENV:-~/.shroud}
DATA_PATH=${DATA_PATH:-$ENV/$APP}
ENV_FILE=${ENV_FILE:-$DATA_PATH/.env}
BRANCH=${BRANCH:-master}

[[ -f $ENV_FILE ]] && echo "Using $ENV_FILE" || (echo "Initalize $ENV_FILE" ; init)

##ctx         Run in app ENV
function ctx {
    pushd $ENV
        info
        $@
    popd
}

##init        Initialize app ENV
function init {
    git clone --single-branch --branch ${BRANCH} $1 ${ENV}
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

function info {
    clear
    echo "------------------------------------------------------------"
    echo $APP
    echo "------------------------------------------------------------"
    cat $ENV_FILE
    echo "------------------------------------------------------------"
    sed -n 's/^##//p' ctl.sh
    echo "------------------------------------------------------------"
    tree -d
}

${@:-info}
