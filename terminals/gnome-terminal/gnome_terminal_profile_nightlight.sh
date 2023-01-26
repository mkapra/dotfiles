#!/bin/bash

# Define the dark and light profile UUIDs
dark_profile="358f6041-d4a0-4de3-90f3-e4afc6252ea1"
light_profile="b1dcc9dd-5262-4d8d-a863-c897e6d979b9"

# Get the current option
option=$1

# Function to change the profile of all open terminal windows
change_profile() {
    for win_id in $(xdotool search --name "Terminal"); do
        xdotool windowactivate $win_id && xdotool key --clearmodifiers Shift+F10 r $1
    done
}

win_id_orig=$(xdotool getwindowfocus)
# Check if option is "dark" or "light"
if [ "$option" == "dark" ]; then
    dconf write /org/gnome/terminal/legacy/profiles:/default "'$dark_profile'"
    change_profile 1
    touch $HOME/.darkmode
elif [ "$option" == "light" ]; then
    dconf write /org/gnome/terminal/legacy/profiles:/default "'$light_profile'"
    change_profile 2
    rm $HOME/.darkmode
else
    echo "Invalid option. Please use 'dark' or 'light'."
fi
xdotool windowactivate $win_id_orig
