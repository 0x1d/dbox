#!/usr/bin/env bash

###############################################################
# Setup container repository on cluster
# Globals:
#   None
# Arguments:
#   PROJECT_ID
# Returns:
#   None
###############################################################
function create_gcr_repo {
    if [ "$#" -ne 1 ]; then
        echo 'Wrong number of arguments. Please provide PROJECT_ID.'
        exit 1
    fi
    
    yak repo create $1
}

###############################################################
# Configure GCR Docker integration
# Globals:
#   None
# Arguments:
#   None
# Returns:
#   None
###############################################################
function configure_gcloud_docker {
    gcloud auth configure-docker
}
