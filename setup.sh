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
    mkdir -p $HOME/.config/kitty $HOME/.local/bin
    ln -fs $SCRIPT/terminals/kitty/kitty.conf $HOME/.config/kitty/
    ln -fs $SCRIPT/terminals/nightlight.sh $HOME/.local/bin/

    ln -fs $SCRIPT/submodules/kitty-rose-pine-theme/dist/rose-pine* $HOME/.config/kitty/
    ln -fs $SCRIPT/submodules/kitty-rose-pine-theme/icons/rose-pine-terminal-icon.png $HOME/.config/kitty/kitty.app.png

    if [[ "$(uname -a)" == *"Darwin"* ]]
    then
        rm /var/folders/*/*/*/com.apple.dock.iconcache; killall Dock
    fi
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
      mkdir -p $HOME/.local/bin
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
  configure_vim() {
    if which vim &> /dev/null
    then
      ln -fs $SCRIPT/editors/vimrc $HOME/.vimrc
      curl --silent -fLo ~/.vim/autoload/plug.vim --create-dirs \
        https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
    fi
  }

  configure_nvim() {
    echo "-- Configure nvim"
    if which nvim &> /dev/null
    then
      mkdir -p $HOME/.config/nvim
      ln -fs $SCRIPT/editors/nvim/* $HOME/.config/nvim/
    fi
  }

  configure_vim
  # configure_nvim

  echo 'Do not forget to launch (n)vim and install all the plugins'
}

# ============================== helix
install_helix() {
  if which hx &> /dev/null
  then
    mkdir -p $HOME/.config/helix
    ln -fs $SCRIPT/editors/helix/* $HOME/.config/helix
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

# ============================== zellij
install_zellij() {
  if which zellij &> /dev/null
  then
    echo '-- Setting up zellij'
    mkdir -p $HOME/.config/zellij
    ln -fs $SCRIPT/term_multiplexers/zellij/config.kdl $HOME/.config/zellij
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
    ln -fs $SCRIPT/term_multiplexers/tmux/config $HOME/.config/tmux/tmux.conf
  fi
}

# ============================== git
install_git() {
  if which git &> /dev/null
  then
    echo '-- Setting up git'
    ln -fs $SCRIPT/git/message $HOME/.gitmessage
    ln -fs $SCRIPT/git/config $HOME/.gitconfig
  fi
}

# ============================== Mail
install_mail() {
  if which mutt &> /dev/null
  then
    echo '-- Setting up mutt'
    mkdir -p $HOME/.mutt/.cache $HOME/.local/bin
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
    other_tools=('zellij' 'cargo-info' 'cargo-add' 'cargo-update' 'gitui')
    alias_tools=('exa' 'rg')
    commands=('ls' 'grep')
    aliasses=('exa --icons' 'rg')

    echo "-- Installing ${alias_tools[@]} with cargo"
    i=0
    for tool in "${alias_tools[@]}"
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

    for tool in "${other_tools[@]}"
    do
      cargo install -q $tool
    done
  fi
}

install_fonts
install_gnome_terminal
install_kitty_terminal
install_vim
install_helix
install_shells
install_zellij
install_tmux
install_git
install_mail
install_rust

./uninstallations.sh
