#!/usr/bin/env bash

DIR="${BASH_SOURCE%/*}"
if [[ ! -d "$DIR" ]]; then DIR="$PWD"; fi

. ${DIR}/dialogs.sh

function yak_shell_menu {
    while true; do
        ui_clear_screen_header \
            "Yak Shell" \
            "CLI Tools for yak Cloud"
        printf      "yak\n"
        printf      "\t1) Mesh\n"
        printf      "\t2) Flow\n"
        ui_hr -
        printf      "Cluster\n"
        printf      "\t3) Login\n"
        ui_hr -
        printf      "Utilities\n"
        printf      "\t4) Watch pods\n"
        printf      "\t5) Create secret config\n"
        printf      "\t6) Create Docker secret\n"
        printf      "\t7) Enable sidecar injection\n"
        ui_hr -
        echo        "0) Exit"
        ui_hr -
        read -p     "Please choose: " mEntry
        case $mEntry in
            [0]* ) exit 0;;
            [1]* ) yak_mesh_cluster_bootstrapping;;
            [2]* ) yak_flow_cluster_bootstrapping;;
            [3]* ) step_cluster_login;;
            [4]* ) step_watch_resource;;
            [5]* ) step_create_secret_config;;
            [6]* ) step_create_docker_secret;;
            [7]* ) step_enable_sidecar_injection;;
            * ) echo "Please choose 0-7.";;
        esac
    done
}

function yak_mesh_cluster_bootstrapping {
    while true; do
        ui_clear_screen_header \
            "yak Mesh" \
            "Framework for Microservice Mesh"
        printf      "Bootstrap\n"
        printf      "\t1) Guided setup\n"
        ui_hr -
        echo        "0) Return"
        ui_hr -
        read -p     "Please choose: " mEntry
        case $mEntry in
            [0]* ) return;;
            [1]* ) guided_setup_mesh;;
            [3]* ) existing_cluster_setup_mesh;;
            * ) echo "Please choose 0-2.";;
        esac
    done
}

function yak_flow_cluster_bootstrapping {
    while true; do
        ui_clear_screen_header \
            "yak Flow" \
            "Framework for Event Driven Applications"
        printf      "Bootstrap\n"
        printf      "\t1) Guided setup\n"
        printf      "\t2) Quick setup\n"
        ui_hr -
        printf      "Custom Installation\n"
        printf      "\t3) Setup on existing cluster\n"
        printf      "\t5) Install Kafka\n"
        ui_hr -
        echo        "0) Return"
        ui_hr -
        read -p     "Please choose: " mEntry
        case $mEntry in
            [0]* ) return;;
            [1]* ) guided_setup_flow;;
            [2]* ) quick_setup_flow;;
            [3]* ) existing_cluster_setup_flow;;
            [5]* ) step_install_kafka;;
            * ) echo "Please choose 0-5.";;
        esac
    done
}
