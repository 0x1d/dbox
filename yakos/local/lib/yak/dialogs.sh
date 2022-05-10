#!/usr/bin/env bash
#
# yak Shell dialogs for cluster bootstrapping

DIR="${BASH_SOURCE%/*}"
if [[ ! -d "$DIR" ]]; then DIR="$PWD"; fi

. ${DIR}/init.sh
. ${DIR}/cluster.sh
. ${DIR}/repo.sh
. ${DIR}/flow.sh
. ${DIR}/secrets.sh
. ${DIR}/istio.sh
. ${DIR}/ui.sh

function step_init_cli {
    printf "Authenticate with Google Cloud and initialize local yak config.\n\n"
    init_cli $1 $2
    ui_any_key
}

function step_setup_gcr {
    printf "Setup container repository from scratch.\n"
    printf "If you've already created the repoitory please skip this step to avoid errors.\n"

    ui_skippable "Proceed? [Y/n]" \
        create_gcr_repo $1

    printf "If you want to push images to GCR, you need to enable Docker integration.\n"
    ui_skippable "Enable GCR Docker integration? [Y/n]" \
        configure_gcloud_docker
    
    ui_any_key
}

function step_create_minimal_cluster {
    echo "Create a cluster:"
    echo "PROJECT_ID: $1"
    echo "CLUSTER_NAME: $2"
    echo "ZONE: $3"
    echo "MACHINE_TYPE: $4"

    ui_skippable "Proceed? [Y/n]" \
        create_minimal_cluster $1 $2 $3 $4

    ui_any_key
}
function step_create_mesh_default_cluster {
    echo "Create a cluster:"
    echo "PROJECT_ID: $1"
    echo "CLUSTER_NAME: $2"

    ui_skippable "Proceed? [Y/n]" \
        create_default_cluster $1 $2

    ui_any_key
}

function step_install_flow {
    printf "Setup yak Flow on your cluster.\n"

    CLUSTER_NAME=$1
    if [ "$#" -ne 1 ]; then
        read -p "Cluster Name: " CLUSTER_NAME
    fi

    ui_skippable "Proceed? [Y/n]" \
        init_flow ${CLUSTER_NAME}

    ui_any_key
}

function step_install_kafka {
    printf "Setup a Kafka Broker, ClusterChannelProvisioner, Controller, and Dispatcher.\n"
    printf "For more information, please refer to:\n"
    printf "https://github.com/knative/eventing/tree/master/contrib/kafka/config\n\n"

    DOCKER_REPO=$1
    KNATIVE_RELEASE=$2
    if [ "$#" -ne 2 ]; then
        read -p     "KO Docker Repo: " DOCKER_REPO
        read -e -p  "Knative Kafka Release: " -i "release-0.4" KNATIVE_RELEASE
    fi

    ui_skippable "Proceed? [Y/n]" \
        install_kafka ${DOCKER_REPO} ${KNATIVE_RELEASE}
    
    ui_any_key
}

function step_enable_sidecar_injection {
    ui_clear_screen_header \
        "Utilities > Enable Sidecar Injection" \
        "Enable automatic Istio sidecar injection on given namespace."

    read -p "Namespace: " NAMESPACE
    enable_sidecar_injection ${NAMESPACE}

    ui_any_key
}

function step_create_secret_config {
    
    ui_clear_screen_header \
        "Utilities > Create Secret Config" \
        "Create a generic secret config on the cluster in form of APP-SERVICE-config."

    read -p "Namespace: " NAMESPACE
    read -p "App: " APP
    read -p "Service: " SERVICE
    read -p "Local config path: " LOCAL_CONFIG_PATH
    read -p "Remote config path: " REMOTE_CONFIG_PATH

    create_secret_config ${NAMESPACE} ${APP} ${SERVICE} ${LOCAL_CONFIG_PATH} ${REMOTE_CONFIG_PATH}

    ui_any_key
}

function step_create_docker_secret {
    ui_clear_screen_header \
        "Utilities > Create Docker-Registry Config Secret" \
        "Create a docker-registry secret config on the cluster"

    read -e -p  "Namespace: " -i "default" NAMESPACE
    read -e -p  "Secret Name: " -i "dockerhub-from-cli" SECRET_NAME
    read -e -p  "Registry: " -i "https://index.docker.io/v1/" DOCKER_SERVER
    read -p     "User: "  DOCKER_USER
    read -p     "Password: "  DOCKER_PASSWORD
    read -p     "E-Mail: "  DOCKER_EMAIL

    create_docker_registry_secret ${NAMESPACE} ${SECRET_NAME} ${DOCKER_SERVER} ${DOCKER_USER} ${DOCKER_PASSWORD} ${DOCKER_EMAIL}

    ui_any_key
}

function step_watch_resource {
    ui_clear_screen_header \
        "Utilities > Resources"

    read -e -p  "Namespace: " -i "default" NAMESPACE
    read -e -p  "Resource: " -i "pods" RESOURCE

    watch_resource ${NAMESPACE} ${RESOURCE}
}


function step_cluster_login {
    ui_clear_screen_header \
        "Cluster > Login" \
        "Setup local yak config and cluster login"

    read -p     "Project: " PROJECT
    read -p     "Cluster Name: " CLUSTER_NAME
    read -e -p  "Docker Repo: " -i "gcr.io/${PROJECT}" DOCKER_REPO
    read -e -p  "Cluster Zone: " -i "us-east1-b" CLUSTER_ZONE
    
    ui_clear_screen \
        "Cluster > Login to existing cluster" \
        init_cli_existing ${PROJECT} ${DOCKER_REPO} ${CLUSTER_NAME} ${CLUSTER_ZONE}
    
    ui_clear_screen \
        "Cluster > Setup GCR" \
        step_setup_gcr ${PROJECT}

    ui_any_key "Done."
}

function guided_setup_flow {
    ui_clear_screen_header \
        "yak Flow > Guided Setup" \
        "Bootstrap a cluster, setup container repository and install yak Flow."
    
    read -p     "Project: " PROJECT
    read -p     "Cluster Name: " CLUSTER_NAME
    read -e -p  "Docker Repo: " -i "gcr.io/${PROJECT}" DOCKER_REPO
    read -e -p  "Cluster Zone: " -i "us-east1-b" CLUSTER_ZONE
    read -e -p  "Machine Type: " -i "n1-standard-2" MACHINE_TYPE

    ui_clear_screen \
        "yak Flow > Initialize CLI" \
        step_init_cli ${PROJECT} ${DOCKER_REPO}

    ui_clear_screen \
        "yak Flow > Setup GCR" \
        step_setup_gcr ${PROJECT}

    ui_clear_screen \
        "yak Flow > Create Cluster" \
        step_create_minimal_cluster ${PROJECT} ${CLUSTER_NAME} ${CLUSTER_ZONE} ${MACHINE_TYPE}

    ui_clear_screen \
        "yak Flow > Install Flow" \
        step_install_flow ${CLUSTER_NAME}

    ui_any_key "Done."
}

function quick_setup_flow {
    ui_clear_screen_header \
        "yak Flow > Quick Setup" \
        "Bootstrap a cluster with minimal user interaction."
    
    read -p     "Project: " PROJECT
    read -p     "Cluster Name: " CLUSTER_NAME
    read -e -p  "Docker Repo: " -i "gcr.io/${PROJECT}" DOCKER_REPO
    read -e -p  "Cluster Zone: " -i "us-east1-b" CLUSTER_ZONE
    read -e -p  "Machine Type: " -i "n1-standard-2" MACHINE_TYPE

    init_cli ${PROJECT} ${DOCKER_REPO}
    create_gcr_repo ${PROJECT}
    configure_gcloud_docker
    create_minimal_cluster ${PROJECT} ${CLUSTER_NAME} ${CLUSTER_ZONE} ${MACHINE_TYPE}
    init_flow ${CLUSTER_NAME}
    
    ui_any_key "Done."
}

function existing_cluster_setup_flow {
    ui_clear_screen_header \
        "yak Flow > Setup on existing cluster" \
        "Install yak Flow on an existing cluster."

    read -p     "Project: " PROJECT
    read -p     "Cluster Name: " CLUSTER_NAME
    read -e -p  "Docker Repo: " -i "gcr.io/${PROJECT}" DOCKER_REPO
    read -e -p  "Cluster Zone: " -i "us-east1-b" CLUSTER_ZONE
    
    init_cli_existing ${PROJECT} ${DOCKER_REPO} ${CLUSTER_NAME} ${CLUSTER_ZONE}
    step_setup_gcr ${PROJECT}
    step_install_flow ${CLUSTER_NAME}

    ui_any_key "Done."
}


function guided_setup_mesh {
    ui_clear_screen_header \
        "yak Mesh > Guided Setup" \
        "Bootstrap a default Mesh cluster."
    
    read -p     "Project: " PROJECT
    read -p     "Cluster Name: " CLUSTER_NAME
    read -e -p  "Docker Repo: " -i "gcr.io/${PROJECT}" DOCKER_REPO

    ui_clear_screen \
        "yak Mesh > Initialize CLI" \
        step_init_cli ${PROJECT} ${DOCKER_REPO}

    ui_clear_screen \
        "yak Mesh > Setup GCR" \
        step_setup_gcr ${PROJECT}

    ui_clear_screen \
        "yak Mesh > Create Cluster" \
        step_create_mesh_default_cluster ${PROJECT} ${CLUSTER_NAME}

    ui_any_key "Done."
}
