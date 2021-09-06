# ~/.zshrc

# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
# HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
# shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
# HISTSIZE=1000
# HISTFILESIZE=2000
 
# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
# shopt -s checkwinsize

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
#shopt -s globstar

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-color|*-256color) color_prompt=yes;;
esac

if [ "$color_prompt" = yes ]; then
    PS1='%~ %F{blue}λ%f '
else
    PS1='\u@\h:\w\$ '
fi
unset color_prompt

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    alias ll='ls -alF'
    alias la='ls -A'
    alias l='ls -CF'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

alias g='git'

# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.zsh_aliases, instead of adding them here directly.
if [ -f ~/.zsh_aliases ]; then
    . ~/.zsh_aliases
fi

# Make tmux play nicely with SSH Agent forwarding
if [ -z ${TMUX+x} ]; then
  # If this is not a tmux session then symlink $SSH_AUTH_SOCK
  if [ ! -S ~/.ssh/ssh_auth_sock ] && [ -S "$SSH_AUTH_SOCK" ]; then
    ln -sf $SSH_AUTH_SOCK ~/.ssh/ssh_auth_sock
  fi
else
  # If this is a tmux session then use the symlinked SSH_AUTH_SOCK
  export SSH_AUTH_SOCK=~/.ssh/ssh_auth_sock
fi

# Get different PS1's for different exit codes
__prompt_command() {
  local EXIT="$?"
  PS1='%~ '
 
  local red_lambda='%F{red}λ%f '
  local blue_lambda='%F{blue}λ%f '

  if [ $EXIT != 0 ]
  then
    PS1+=$red_lambda
  else
    PS1+=$blue_lambda
  fi
}
PROMPT_COMMAND=__prompt_command
precmd() { eval "$PROMPT_COMMAND" }

# Bind C-f to the fg command to be able to bring a background command to the foreground faster
# bind -x '"\C-f":"fg"'

# Environment Variables
export PATH=$HOME/bin:$HOME/.local/bin:$HOME/.cargo/bin:$PATH
# We want english....
export LC_ALL=en_US.UTF-8
export LC_MESSAGES=en_US.UTF-8
export LANG=en_US.UTF-8
