#!/usr/bin/env bash

SCRIPT=$(dirname -- "$( readlink -f -- "$0"; )";)

# ============================== kitty-terminal
install_kitty_terminal() {
  echo "-- Installing kitty terminal"
  if which kitty &> /dev/null
  then
    mkdir -p $HOME/.local/bin
    ln -fs $SCRIPT/terminals/nightlight.sh $HOME/.local/bin/
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


install_fonts
install_gnome_terminal
install_kitty_terminal
install_shells

uninstallations.sh
