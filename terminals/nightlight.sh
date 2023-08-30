#!/bin/bash

# Get the current option
option=$1

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

    while read -r host; do
        if [[ $1 == 'dark' ]]
        then
            ssh $host touch .darkmode
            ssh $host bash <<EOF
                if [[ -f $HOME/.config/helix/config.toml ]]
                then
                    sed -i 's/theme = ".*"/theme = "ayu_mirage"/' $HOME/.config/helix/config.toml
                fi
EOF
        else
            ssh $host rm -f $host
            ssh $host bash <<EOF
                if [[ -f $HOME/.config/helix/config.toml ]]
                then
                    sed -i 's/theme = ".*"/theme = "rose_pine_dawn"/' $HOME/.config/helix/config.toml
                fi
EOF
        fi
    done < $HOME/.ssh/servers

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

set -x
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
