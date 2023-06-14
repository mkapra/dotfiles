#!/bin/bash

# Define the dark and light profile UUIDs
dark_profile="358f6041-d4a0-4de3-90f3-e4afc6252ea1"
light_profile="b1dcc9dd-5262-4d8d-a863-c897e6d979b9"

# Get the current option
option=$1

# Function to change the profile of all open kitty-terminal windows
change_profile() {
    ln -fs $HOME/.config/kitty/"rose-pine-$1.conf" $HOME/.config/kitty/current-theme.conf
    files="/tmp/kitty-$USER-*"
    for instance in $files
    do
        kitty @ --to "unix:$instance" set-colors --all --configured $HOME/.config/kitty/kitty.conf
    done
}

ssh-add -L | grep 'The agent has no identities'
if [ $? -eq 0 ]
then
  exit 1
fi

win_id_orig=$(xdotool getwindowfocus)
# Check if option is "dark" or "light"
if [ "$option" == "dark" ]; then
    # dconf write /org/gnome/terminal/legacy/profiles:/default "'$dark_profile'"
    change_profile moon
    exit

    touch $HOME/.darkmode
    while read -r host; do
      scp -q .darkmode $host:~
    done < "$HOME/.ssh/servers"
elif [ "$option" == "light" ]; then
    # dconf write /org/gnome/terminal/legacy/profiles:/default "'$light_profile'"
    change_profile dawn
    exit

    rm $HOME/.darkmode
    while read -r host; do
      ssh $host rm ~/.darkmode < /dev/null
    done < "$HOME/.ssh/servers"
else
    echo "Invalid option. Please use 'dark' or 'light'."
fi
xdotool windowactivate $win_id_orig
