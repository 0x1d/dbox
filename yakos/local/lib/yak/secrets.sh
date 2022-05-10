#!/usr/bin/env bash

###############################################################
# Create a generic secret on the cluster
# Globals:
#   None
# Arguments:
#   NAMESPACE
#   APP
#   SERVICE
#   LOCAL_CONFIG_PATH
#   REMOTE_CONFIG_PATH
# Returns:
#   None
###############################################################
function create_secret_config {
    if [ "$#" -ne 5 ]; then
        echo 'Wrong number of arguments. Please provide NAMESPACE, APP, SERVICE, LOCAL_CONFIG_PATH, REMOTE_CONFIG_PATH.'
        exit 1
    fi

    kubectl create secret generic -n ${1} ${2}-${3}-config --from-file=${5}=${4} 
}

####################################################################
# Creates a docker-registry secret in given namespace.
# Globals:
#   None
# Arguments:
#   NAMESPACE
#   SECRET_NAME
#   DOCKER_SERVER
#   DOCKER_USER
#   DOCKER_PASSWORD
#   DOCKER_EMAIL
# Returns:
#   None
####################################################################
function create_docker_registry_secret {
    if [ "$#" -ne 6 ]; then
        echo 'Wrong number of arguments. Please provide NAMESPACE, SECRET_NAME, DOCKER_SERVER, DOCKER_USER, DOCKER_PASSWORD, DOCKER_EMAIL.'
        exit 1
    fi
    
    kubectl -n ${1} \
        create secret docker-registry ${2} \
        --docker-server=${3} \
        --docker-username=${4} \
        --docker-password=${5} \
        --docker-email=${6}
}