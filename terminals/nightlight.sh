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

ssh-add -L 2> /dev/null
if [ $? -ne 0 ]
then
  exit 1
fi

set -x
# Check if option is "dark" or "light"
if [ "$option" == "dark" ]; then
    change_profile moon

    touch $HOME/.darkmode
    sed -i 's/theme = ".*"/theme = "rose_pine_moon"/' ${HOME}/.config/helix/config.toml
    # pkill -USR1 hx
    while read -r host; do
      scp -q .darkmode $host:~
      
      ssh $host bash <<EOF
        if [[ -f $HOME/.config/helix/config.toml ]]
        then
            sed -i 's/theme = ".*"/theme = "rose_pine_moon"/' ${HOME}/.config/helix/config.toml
        fi
        if [[ -f $HOME/.cargo/bin/zellij ]]
        then
            sed -i 's/theme ".*"/theme "rose-pine-moon"/' ${HOME}/.config/zellij/config.kdl
        fi
EOF
    done < "$HOME/.ssh/servers"
elif [ "$option" == "light" ]; then
    change_profile dawn

    rm $HOME/.darkmode
    sed -i 's/theme = ".*"/theme = "rose_pine_dawn"/' ${HOME}/.config/helix/config.toml
    # pkill -USR1 hx
    while read -r host; do
      ssh $host bash <<EOF
        rm ~/.darkmode
        if [[ -f $HOME/.config/helix/config.toml ]]
        then
            sed -i 's/theme = ".*"/theme = "rose_pine_dawn"/' ${HOME}/.config/helix/config.toml
        fi
        if [[ -f $HOME/.cargo/bin/zellij ]]
        then
            sed -i 's/theme ".*"/theme "rose-pine-dawn"/' ${HOME}/.config/zellij/config.kdl
        fi
EOF
    done < "$HOME/.ssh/servers"
else
    echo "Invalid option. Please use 'dark' or 'light'."
fi
