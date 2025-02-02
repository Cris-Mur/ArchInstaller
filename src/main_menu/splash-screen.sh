#!/usr/bin/env bash

###############################################################################
### SPLASH SCREEN FUNCTIONS
###############################################################################

main_splash_screen() {
    local splash_screen="$RESOURCE_DIRECTORY/splash.txt"
    if [ ! -f  "$splash_screen" ]; then
        echo "Splash screen NOT found at '$splash_screen'"
        alternative_splash_screen
        return 1
    fi
    echo "$(cat "$splash_screen")"
}

alternative_splash_screen() {
    local splash_screen="$RESOURCE_DIRECTORY/alternative-splash.txt"
    if [ ! -f  "$splash_screen" ]; then
        echo "Alternative Splash screen NOT found at '$splash_screen'"
        main_splash_screen
        return 1
    fi
    echo -e "$(cat "$splash_screen")"
}
