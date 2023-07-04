#!/usr/bin/env bash

SCRIPT=$(dirname -- "$( readlink -f -- "$0"; )";)

# ============================== kitty-terminal
install_kitty_terminal() {
  echo "-- Installing kitty terminal"
  if which kitty &> /dev/null
  then
    mkdir -p $HOME/.local/bin
    ln -fs $SCRIPT/terminals/nightlight.sh $HOME/.local/bin/
  fi
}

# ============================== shells
install_shells() {
  echo '-- Setting up shells'
  ln -fs $SCRIPT/shells/generic_shrc $HOME/.generic_shrc

  echo '-- Setting up ssh rc'
  ln -fs $SCRIPT/shells/sshrc $HOME/.ssh/rc

  if which bash &> /dev/null
  then
    echo 'Link bash configuration'
    ln -fs $SCRIPT/shells/bashrc $HOME/.bashrc
  fi

  if which zsh &> /dev/null
  then
    echo 'Link zsh configuration'
    ln -fs $SCRIPT/shells/zshrc $HOME/.zshrc
  fi
}


install_kitty_terminal
install_shells

uninstallations.sh
