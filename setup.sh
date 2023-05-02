#!/usr/bin/env bash

SCRIPT=$(dirname -- "$( readlink -f -- "$0"; )";)

# ============================== Fonts
install_fonts() {
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

# ============================== kitty-terminal
install_kitty_terminal() {
  echo "-- Installing kitty terminal"
  if which kitty &> /dev/null
  then
    mkdir -p $HOME/.config/kitty
    ln -fs $SCRIPT/terminals/kitty/* $HOME/.config/kitty/
    ln -fs $SCRIPT/terminals/nightlight.sh $HOME/.local/bin/
  fi
}

# ============================== gnome-terminal
install_gnome_terminal() {
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
      ln -fs $SCRIPT/terminals/nightlight.sh $HOME/.local/bin/
      dconf reset -f /org/gnome/terminal/legacy/profiles:/
      dconf load / < $SCRIPT/terminals/gnome-terminal/everforest-dark-hard-theme.dconf
      dconf load / < $SCRIPT/terminals/gnome-terminal/everforest-light-hard-theme.dconf
      dconf write /org/gnome/terminal/legacy/default-profile "'b1dcc9dd-5262-4d8d-a863-c897e6d979b9'"

    fi
  }

  shortcuts
  gt_colorscm
}

# ============================== vim
install_vim() {
  if which vim &> /dev/null
  then
    ln -fs $SCRIPT/editors/vimrc $HOME/.vimrc
    curl --silent -fLo ~/.vim/autoload/plug.vim --create-dirs \
      https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  fi

  echo "-- Installing vim-plug"
  if which nvim &> /dev/null
  then
    mkdir -p $HOME/.config/nvim
    ln -fs $SCRIPT/editors/vimrc $HOME/.config/nvim/init.vim
    ln -fs $SCRIPT/editors/nvim/lua $HOME/.config/nvim/
    sh -c 'curl --silent -fLo "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/autoload/plug.vim --create-dirs \
      https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
  fi

  echo 'Do not forget to launch (n)vim and install all the plugins'
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

# ============================== tmux
install_tmux() {
  if which tmux &> /dev/null
  then
    echo '-- Setting up tmux'
    mkdir -p $HOME/.tmux/plugins
    [ ! -d $HOME/.tmux/plugins/tpm ] && \
      git clone -q https://github.com/tmux-plugins/tpm $HOME/.tmux/plugins/tpm
    mkdir -p $HOME/.config/tmux
    ln -fs $SCRIPT/tmux/config $HOME/.config/tmux/tmux.conf
  fi
}

# ============================== git
install_git() {
  if which git &> /dev/null
  then
    echo '-- Setting up git'
    ln -fs $SCRIPT/git/message $HOME/.gitmessage
    ln -fs $SCRIPT/git/config $HOME/.gitconfig

    echo '-- Installing lazygit'
    if which brew &> /dev/null
    then
      brew install lazygit
    else
      LAZYGIT_VERSION=$(curl -s "https://api.github.com/repos/jesseduffield/lazygit/releases/latest" | grep '"tag_name":' |  sed -E 's/.*"v*([^"]+)".*/\1/')
      curl --silent -Lo /tmp/lazygit.tar.gz "https://github.com/jesseduffield/lazygit/releases/latest/download/lazygit_${LAZYGIT_VERSION}_Linux_x86_64.tar.gz"
      tar xf /tmp/lazygit.tar.gz -C $HOME/.local/bin lazygit
      rm /tmp/lazygit.tar.gz
    fi
    mkdir -p $HOME/.config/lazygit
    ln -fs $SCRIPT/git/lazygit.conf $HOME/.config/lazygit/config.yml
  fi
}

# ============================== Mail
install_mail() {
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
install_rust() {
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

install_fonts
install_gnome_terminal
install_kitty_terminal
install_vim
install_shells
install_tmux
install_git
install_mail
install_rust
