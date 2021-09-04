# ~/.zshrc

##############################################################################
# zsh Configuration File
# edited: 20. April 2021
##############################################################################

##############################################################################
# Aliases
##############################################################################
alias ls="ls -G"
alias g="git"
alias gc="gitmoji -c"
alias g+="g++ -std=c++17" # C++

alias v="nvim"
alias nano="v"
alias vi="v"
alias sublime-text="v"

alias ave="ansible-vault edit"

##############################################################################
# Variables
##############################################################################
export PATH=$HOME/bin:$HOME/.local/bin:/usr/local/bin:$PATH:/Applications/:/usr/local/opt/llvm/bin
export HOMEBREW_NO_AUTO_UPDATE=1 # No autoupdate for homebrew
export LC_ALL=en_US.UTF-8
export LC_CTYPE=en_US.UTF-8
[ -f /usr/libexec/java_home ] && export JAVA_HOME=$(/usr/libexec/java_home)

export EDITOR=nvim

autoload -U colors && colors

##############################################################################
# Git
##############################################################################
# Checks if working tree is dirty
function parse_git_dirty() {
  local STATUS
  local -a FLAGS
  FLAGS=('--porcelain')
  if [[ "${DISABLE_UNTRACKED_FILES_DIRTY:-}" == "true" ]]; then
    FLAGS+='--untracked-files=no'
  fi
  FLAGS+="--ignore-submodules=${GIT_STATUS_IGNORE_SUBMODULES:-dirty}"
  STATUS=$(git status ${FLAGS} 2> /dev/null | tail -n1)
  if [[ -n $STATUS ]]; then
    echo "*"
  else
    echo ""
  fi
}

autoload -Uz vcs_info
precmd_vcs_info() { vcs_info }
precmd_functions+=( precmd_vcs_info )
setopt prompt_subst
zstyle ':vcs_info:git:*' formats '<%b>'

##############################################################################
# PS
##############################################################################
return_code="%(?..%{$fg[red]%}%? ↵%{$reset_color%})"
host_color="%(!.%{$fg[red]%}.%{$fg[green]%})"

# PROMPT=" %2~ %{$fg[yellow]%}\$vcs_info_msg_0_\$(parse_git_dirty)%{$reset_color%}%B${host_color}➤%{$reset_color%}%b "
PROMPT="%2~ %{$fg[yellow]%}\$vcs_info_msg_0_\$(parse_git_dirty)%{$reset_color%}%B${host_color}❯%{$reset_color%}%b "
RPS1="${return_code}"

##############################################################################
# Autocompletion
##############################################################################
fpath=(~/.zsh/completion $fpath) # Add path to custom scripts
autoload -U compinit
compinit

# zsh History
HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000
setopt share_history

# Show completion menu when number of options is at least 2
# + case insensitive path-completion 
zstyle ':completion:*' matcher-list 'm:{[:lower:][:upper:]}={[:upper:][:lower:]}' 'm:{[:lower:][:upper:]}={[:upper:][:lower:]} l:|=* r:|=*' 'm:{[:lower:][:upper:]}={[:upper:][:lower:]} l:|=* r:|=*' 'm:{[:lower:][:upper:]}={[:upper:][:lower:]} l:|=* r:|=*' menu select=2

ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=#ADD8E6,underline"
# source ~/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh

##############################################################################
# Keybindings
##############################################################################
bindkey -v # vi mode
bindkey '^r' history-incremental-search-backward
bindkey '^a' beginning-of-line
bindkey '^e' end-of-line
bindkey '^P' up-history
bindkey '^N' down-history
bindkey '\e.' insert-last-word

bindkey -s '^O' 'vim $(fzf)^M'
bindkey -s '^F' 'fg^M'

bindkey '^ ' autosuggest-accept

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

##############################################################################
# FZF Color
##############################################################################
test -e "${HOME}/.iterm2_shell_integration.zsh" && \
  source "${HOME}/.iterm2_shell_integration.zsh"

##############################################################################
# Misc
##############################################################################
# Github API Key for Homebrew
[ -f $HOME/.github_homebrew_key ] && source $HOME/.github_homebrew_key
# Haskell
[ -f "/Users/mkapra/.ghcup/env" ] && source "/Users/mkapra/.ghcup/env"

# Add RVM to PATH for scripting. Make sure this is the last PATH variable change.
export PATH="$PATH:$HOME/.rvm/bin"
