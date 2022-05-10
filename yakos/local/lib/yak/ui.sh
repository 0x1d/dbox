#!/usr/bin/env bash

###############################################################
# Print a horizontal divider
# Globals:
#   None
# Arguments:
#   TEXT
# Returns:
#   None
###############################################################
function ui_hr {
    printf '%*s\n' "${COLUMNS:-$(tput cols)}" '' | tr ' ' $1
}


###############################################################
# Print a text aligned right
# Globals:
#   None
# Arguments:
#   TEXT
# Returns:
#   None
###############################################################
function ui_right {
    printf "%${COLUMNS}s\n" $1
}

###############################################################
# Wrapper for Yes/No question. Yes is default.
# When choosing Y, FUNCTION is executed.
# Globals:
#   None
# Arguments:
#   TEXT
#   FUNCTION
# Returns:
#   None
# Usage:
# ui_decide \
# "Are you sure? [Y/n]"  \
# doYes
###############################################################
function ui_skippable {
    printf "\n"
    read -p "$1 " yn
    shift
    case $yn in
        [Nn]* ) printf "Skip\n";;
        * ) "$@";
    esac
}

###############################################################
# Clears the screen and prints title and horizontal divider
# Globals:
#   None
# Arguments:
#   TITLE
# Returns:
#   None
###############################################################
function ui_clear_screen_header {
    clear
    printf "$1\n"
    if [ -n "$2" ]; then
        printf "$2\n"
    fi
    ui_hr -
}


###############################################################
# Clears the screen, prints header and executes a function
# Globals:
#   None
# Arguments:
#   TITLE
#   FUNCTION
# Returns:
#   None
###############################################################
function ui_clear_screen {
    clear
    printf "$1\n"
    ui_hr -
    shift
    "$@"
}

###############################################################
# Prints a message and promt the user to press any key to continue
# Globals:
#   None
# Arguments:
#   MESSAGE
# Returns:
#   None
###############################################################
function ui_any_key {
    printf "\n$1\n"
    read -p "Press any key to continue..."
}