#!/bin/bash

SCRIPT=$(dirname -- "$( readlink -f -- "$0"; )";)

# ============================== Fonts
fonts() {
  echo "-- Installing required fonts"
  if uname -a | grep Linux
  then
    mkdir -p $HOME/.local/share/fonts
    ln -fs $SCRIPT/submodules/sfmono-font/SF* $HOME/.local/share/fonts/
    fc-cache -f -v
  fi
}

# ============================== gnome-terminal color scheme
# NOT WORKING YET
gt_colorscm() {
  if which gnome-terminal &> /dev/null
  then
    echo "-- Install everforest gnome-terminal theme"
    converter="$SCRIPT/submodules/iterm-color-to-gnome-terminal"
    echo 'Converting...'
    python3 $converter/iterm-color-to-gnome-terminal.py \
      -n 'Everforest Hard Light' \
      $SCRIPT/submodules/everforest.iterm2/Everforest_hard_light.itermcolors \
      | python3 $converter/import-gnome-terminal-profile.py -n 'Everforest Hard Light'
  fi
}

# ============================== vim
vim() {
  ln -fs $SCRIPT/editors/vim $HOME/.vimrc
  mkdir -p $HOME/.config/nvim
  ln -fs $SCRIPT/editors/vim $HOME/.config/nvim/init.vim

  echo "-- Installing vim-plug"
  if which nvim &> /dev/null
  then
    sh -c 'curl -fLo "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/autoload/plug.vim --create-dirs \
      https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
  fi

  if which vim &> /dev/null
  then
    curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
      https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  fi

  echo 'Do not forget to launch (n)vim and install all the plugins'
}

# ============================== shells
shells() {
  echo '-- Setting up shells'
  ln -fs $SCRIPT/shells/generic_shrc $HOME/.generic_shrc

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

# ============================== tmux
tmux() {
  if which tmux &> /dev/null
  then
    echo '-- Setting up tmux'
    ln -fs $SCRIPT/tmux/theme $HOME/.tmux.theme
    ln -fs $SCRIPT/tmux/config $HOME/.tmux.conf
  fi
}

# ============================== git
git() {
  if which git &> /dev/null
  then
    echo '-- Setting up git'
    ln -fs $SCRIPT/git/message $HOME/.gitmessage
    ln -fs $SCRIPT/git/config $HOME/.gitconfig
  fi
}

# gt_colorscm
fonts
vim
shells
tmux
git
