#!/usr/bin/env bash

###############################################################################
show_about() {
    clear
    local about_file="$RESOURCE_DIRECTORY/About.txt"
    if [ ! -f "$about_file" ]; then
        echo "About message file not found at '$about_file'"
        return 1
    fi
    echo -e "$(cat "$about_file")"
}
