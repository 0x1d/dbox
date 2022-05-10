#!/usr/bin/env bash

###############################################################
# Install local Flow dependencies 
# and Istio + Knaive on cluster.
# Globals:
#   None
# Arguments:
#   CLUSTER_NAME
# Returns:
#   None
###############################################################
function init_flow {
    if [ "$#" -ne 1 ]; then
        echo 'Wrong number of arguments. Please provide CLUSTER_NAME.'
        exit 1
    fi
    
    yak flow init $1 --full || exit;
}

###############################################################
# Install Kafka broker and channel provisioning
# for Knative event bus.
# Globals:
#   KO_DOCKER_REPO (set)
#   GOPATH
# Arguments:
#   DOCKER_REPO
# Returns:
#   None
###############################################################
function install_kafka {
    if [ "$#" -ne 2 ]; then
        echo 'Wrong number of arguments. Please provide DOCKER_REPO, KNATIVE_RELEASE.'
        exit 1
    fi

    # KO_DOCKER_REPO needs to be exported for ko to work properly
    export KO_DOCKER_REPO=$1
    KNATIVE_EVENTING_RELEASE=$2
    KAFKA_SOURCE=eventing/contrib/kafka
    KNATIVE_GOPATH=${GOPATH}/src/github.com/knative

    # install ko
    go get github.com/google/ko/cmd/ko
    
    # checkout Knative Eventing release 
    rm -rf ${KNATIVE_GOPATH}
    mkdir -p ${KNATIVE_GOPATH}
    git clone -b ${KNATIVE_EVENTING_RELEASE} https://github.com/knative/eventing.git ${KNATIVE_GOPATH}/eventing

    # setup Kafka resources
    kubectl create namespace kafka
    kubectl apply -n kafka -f ${KNATIVE_GOPATH}/${KAFKA_SOURCE}/config/broker/kafka-broker.yaml
    ko apply -f ${KNATIVE_GOPATH}/${KAFKA_SOURCE}/config/kafka.yaml
}