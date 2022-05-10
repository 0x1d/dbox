#!/usr/bin/env bash

###############################################################
# Initializes gCloud and yak CLI
# Globals:
#   None
# Arguments:
#   PROJECT_ID
#   DOCKER_REPO
# Returns:
#   None
###############################################################
function init_cli {
    if [ "$#" -ne 2 ]; then
        echo 'Wrong number of arguments. Please provide PROJECT_ID, DOCKER_REPO.'
        exit 1
    fi

    gcloud auth login || exit;
    gcloud config set project $1
    yak config init --containerRepo $2 --projectID $1
}

###############################################################
# Initializes gCloud and yak CLI with existing cluster
# Globals:
#   None
# Arguments:
#   PROJECT_ID
#   DOCKER_REPO
#   CLUSTER_NAME
#   ZONE
# Returns:
#   None
###############################################################
function init_cli_existing {
    if [ "$#" -ne 4 ]; then
        echo 'Wrong number of arguments. Please provide PROJECT_ID, DOCKER_REPO, CLUSTER_NAME, ZONE.'
        exit 1
    fi
    
    gcloud auth login || exit;
    gcloud config set project $1
    yak config init --containerRepo $2 --projectID $1
    gcloud container clusters get-credentials $3 -z $4
}