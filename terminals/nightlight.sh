#!/bin/bash

# Get the current option
option=$1

change_theme() {
    ssh $host bash <<EOF
        if [[ -f $HOME/.config/helix/config.toml ]]
        then
            sed -i 's/theme = ".*"/theme = "$1"/' $HOME/.config/helix/config.toml
        fi
EOF
}

# Function to change the profile of all open kitty-terminal windows
change_profile() {
    if [[ $1 == 'dark' ]]
    then
        ln -fs $HOME/.config/kitty/ayu_mirage.conf $HOME/.config/kitty/current-theme.conf
        sed -i 's/theme = ".*"/theme = "ayu_mirage"/' $HOME/.config/helix/config.toml
    else
        ln -fs $HOME/.config/kitty/rose-pine-dawn.conf $HOME/.config/kitty/current-theme.conf
        sed -i 's/theme = ".*"/theme = "rose_pine_dawn"/' $HOME/.config/helix/config.toml
    fi

    while IFS= read -r host
    do
        if [[ $1 == 'dark' ]]
        then
            ssh $host touch .darkmode < /dev/null
            change_theme "ayu_mirage"
        else
            ssh $host rm -f .darkmode < /dev/null
            change_theme "rose_pine_dawn"
        fi
    done < <(cat "$HOME/.ssh/servers")

    files="/tmp/kitty-$USER-*"
    for instance in $files
    do
        kitty @ --to "unix:$instance" set-colors --all --configured $HOME/.config/kitty/kitty.conf
    done
}

ssh-add -L 2> /dev/null
if [ $? -ne 0 ]
then
  exit 1
fi

# Check if option is "dark" or "light"
if [ "$option" == "dark" ]; then
    touch $HOME/.darkmode
    change_profile "dark"
elif [ "$option" == "light" ]; then
    rm -f $HOME/.darkmode
    change_profile
else
    echo "Invalid option. Please use 'dark' or 'light'."
fi
