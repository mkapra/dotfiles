set fish_greeting
set TERM "xterm-256color"
set EDITOR "vim"
set VISUAL "vim"

if type -q exa
  alias ll "exa -l -g --icons"
  alias lla "ll -a"
end

function fish_prompt
   set_color normal

   set_color $fish_color_cwd
   echo -n (prompt_pwd)
   set_color normal

   set_color blue
   echo -n ' λ '
   set_color normal
end

set -gx EDITOR nvim

set -gx PATH bin $PATH
set -gx PATH ~/bin $PATH
set -gx PATH ~/.local/bin $PATH
set -gx PATH ~/.cargo/bin $PATH

# Get !! working
function __history_previous_command
  switch (commandline -t)
    case "!"
      commandline -t $history[1]; commandline -f repaint
    case "*"
      commandline -i !
  end
end

function __history_previous_command_arguments
  switch (commandline -t)
    case "!"
      commandline -t ""
      commandline -f history-token-search-backward
    case "*"
      commandline -i '$'
  end
end
bind ! __history_previous_command
bind '$' __history_previous_command_arguments

# NVM
function __check_rvm --on-variable PWD --description 'Do nvm stuff'
  status --is-command-substitution; and return

  if test -f .nvmrc; and test -r .nvmrc;
    nvm use
  else
  end
end

function fish_user_key_bindings
  # peco
  # bind \cr peco_select_history # Bind for peco select history to Ctrl+R
  # bind \cf peco_change_directory # Bind for peco change directory to Ctrl+F
end
