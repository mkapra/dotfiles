#!/usr/bin/env bash

SCRIPT=$(dirname -- "$( readlink -f -- "$0"; )";)

# ============================== Fonts
fonts() {
  echo "-- Installing required fonts"
  # Install fonts on local machines only. The simplest way to do this is
  # checking for a gnome-terminal application
  if which gnome-terminal &> /dev/null
  then
    mkdir -p $HOME/.local/share/fonts
    ln -fs $SCRIPT/submodules/sfmono-font/SF* $HOME/.local/share/fonts/
    fc-cache -f -v &> /dev/null
  fi
}

# ============================== gnome-terminal
gnome_terminal() {
  # shortcuts
  shortcuts() {
    if which gnome-terminal &> /dev/null
    then
      gsettings set org.gnome.Terminal.Legacy.Keybindings:/org/gnome/terminal/legacy/keybindings/ next-tab '<Primary>Tab'
      gsettings set org.gnome.Terminal.Legacy.Keybindings:/org/gnome/terminal/legacy/keybindings/ prev-tab '<Primary><Shift>Tab'

      for i in {1..10..1}
      do
        gsettings set org.gnome.Terminal.Legacy.Keybindings:/org/gnome/terminal/legacy/keybindings/ switch-to-tab-$i ''
      done
    fi
  }

  # color scheme
  gt_colorscm() {
    if which gnome-terminal &> /dev/null
    then
      echo "-- Install everforest gnome-terminal theme"
      profileId=$(dconf list /org/gnome/terminal/legacy/profiles:/ | grep -v default | grep -v list)
      dconf reset -f /org/gnome/terminal/legacy/profiles:/
      echo "Installing profile to id '${profileId}'"
      dconf load /org/gnome/terminal/legacy/profiles:/${profileId} < $SCRIPT/terminals/gnome-terminal/everforest-theme.dconf
    fi
  }

  shortcuts
  gt_colorscm
}

# ============================== vim
vim() {
  ln -fs $SCRIPT/editors/vimrc $HOME/.vimrc
  mkdir -p $HOME/.config/nvim
  ln -fs $SCRIPT/editors/vimrc $HOME/.config/nvim/init.vim

  echo "-- Installing vim-plug"
  if which nvim &> /dev/null
  then
    sh -c 'curl --silent -fLo "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/autoload/plug.vim --create-dirs \
      https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
  fi

  if which vim &> /dev/null
  then
    curl --silent -fLo ~/.vim/autoload/plug.vim --create-dirs \
      https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  fi

  if which brew &> /dev/null
  then
    mkdir -p $HOME/.config/svim
    ln -fs $SCRIPT/editors/svim/blacklist $HOME/.config/svim/blacklist
    brew services restart svim &> /dev/null
  fi

  echo 'Do not forget to launch (n)vim and install all the plugins'
}

# ============================== shells
shells() {
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

# ============================== Mail
mail() {
  if which mutt &> /dev/null
  then
    echo '-- Setting up mutt'
    mkdir -p $HOME/.mutt/.cache
    ln -fs $SCRIPT/mail/mutt/rc $HOME/.mutt/muttrc
    ln -fs $SCRIPT/mail/mutt/theme $HOME/.mutt/theme
    ln -fs $SCRIPT/submodules/mutt_bgrun/mutt_bgrun $HOME/.local/bin/mutt_bgrun
    chmod +x $HOME/.local/bin/mutt_bgrun

    if [[ "$(uname -a)" == *"Darwin"* ]]
    then
      echo 'Adding mailcap file for MacOS'
      ln -fs $SCRIPT/mail/mutt/mailcap.macos $HOME/.mutt/mailcap
    elif [[ "$(uname -a)" == *"Linux"* ]]
    then
      echo 'Adding mailcap file for Linux'
      ln -fs $SCRIPT/mail/mutt/mailcap.linux $HOME/.mutt/mailcap
    fi
  fi
}

# ============================== Rust Tools
rust() {
  if which cargo &> /dev/null
  then
    tools=('exa' 'rg')
    commands=('ls' 'grep')
    aliasses=('exa --icons' 'rg')

    echo "-- Installing ${tools[@]} with cargo"
    i=0
    for tool in "${tools[@]}"
    do
      grep -q "${aliasses[i]}" $HOME/.local_shrc && found=1 || found=0
      if [ $found -eq 0 ]
      then
        echo "Setting alias for ${commands[i]} -> ${aliasses[i]}"
        eval "echo \"alias ${commands[i]}='${aliasses[i]}'\" >> $HOME/.local_shrc"
      fi

      if which $tool &> /dev/null
      then
        echo "Tool $tool found. Doing nothing..."
        let i++
        continue
      fi

      cargo install -q $tool
      let i++
    done
  fi
}

fonts
gnome_terminal
vim
shells
tmux
git
mail
rust
