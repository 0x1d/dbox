#!/usr/bin/env bash

###############################################################
# Enable automatic Istio sidecar injection on given namespace.
# Globals:
#   None
# Arguments:
#   NAMESPACE
# Returns:
#   None
####################################################################
function enable_sidecar_injection {
    if [ "$#" -ne 1 ]; then
        echo 'Wrong number of arguments. Please provide NAMESPACE.'
        exit 1
    fi

    kubectl label namespace ${1} istio-injection=enabled
}
