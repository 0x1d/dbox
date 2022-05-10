#!/usr/bin/env bash

###############################################################
# Create a cluster without service mesh.
# Globals:
#   None
# Arguments:
#   PROJECT_ID
#   CLUSTER_NAME
#   ZONE
#   MACHINE_TYPE
# Returns:
#   None
###############################################################
function create_minimal_cluster {
    if [ "$#" -ne 4 ]; then
        echo 'Wrong number of arguments. Please provide PROJECT_ID, CLUSTER_NAME, ZONE, MACHINE_TYPE.'
        return
    fi
    
    yak cluster create \
        --zone $3 \
        --project $1 \
        --machine-type $4 \
        --num-nodes 4 \
        --min-nodes 1 \
        --max-nodes 4 \
        --autoscaling \
        --cluster-version latest \
        --minimal \
        $2  || exit;
}

###############################################################
# Create a default yak cluster with service mesh.
# Globals:
#   None
# Arguments:
#   PROJECT_ID
#   CLUSTER_NAME
# Returns:
#   None
###############################################################
function create_default_cluster {
    if [ "$#" -ne 2 ]; then
        echo 'Too few arguments. Please provide PROJECT_ID, CLUSTER_NAME.'
        exit 1
    fi

    PROJECT=$1
    CLUSTER_NAME=$2
    ZONE=us-east1-b
    MACHINE_TYPE=n1-highcpu-4
    NUM_NODES=3
    CLUSTER_VERSION=latest

    yak cluster create \
        --zone ${ZONE} \
        --project ${PROJECT} \
        --machine-type ${MACHINE_TYPE} \
        --num-nodes ${NUM_NODES} \
        --min-nodes 1 \
        --max-nodes 4 \
        --autoscaling \
        --cluster-version ${CLUSTER_VERSION} \
        ${CLUSTER_NAME} || exit;
}

###############################################################
# Watch RESOURCE in given NAMESPACE
# Globals:
#   None
# Arguments:
#   NAMESPACE
#   RESOURCE
# Returns:
#   None
###############################################################
function watch_resource {
    if [ "$#" -ne 2 ]; then
        echo 'Too few arguments. Please provide NAMESPACE, RESOURCE.'
        exit 1
    fi    
    
    watch -n 3 kubectl get -n $1 $2
}