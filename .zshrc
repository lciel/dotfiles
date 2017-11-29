# users generic .zshrc file for zsh(1)

## Environment variable configuration
#
# LANG
#
export LANG=ja_JP.UTF-8

## Emoji
export SSH_EMOJI=$'\U26A1'
export CLOCK_EMOJI=$'\U1F552'

## Default shell configuration
#
# set prompt
#
autoload colors
colors
case ${UID} in
0)
  PROMPT="%B%{${fg[red]}%}%/#%{${reset_color}%}%b "
  PROMPT2="%B%{${fg[red]}%}%_#%{${reset_color}%}%b "
  SPROMPT="%B%{${fg[red]}%}%r is correct? [n,y,a,e]:%{${reset_color}%}%b "
  ;;
*)
  SSH_SIGN=""
  if [ -n "${REMOTEHOST}${SSH_CONNECTION}" ]; then SSH_SIGN="${SSH_EMOJI} "; fi
  PROMPT="
%F{248}[%D{%m/%d %H:%M:%S}]%f ${SSH_SIGN}%F{073}%n@%m%f%F{180}:%~%f
$ "
  PROMPT2="%F{098}%_%%%f "
  SPROMPT="%F{198}%r is correct? [n,y,a,e]:%f "
  ;;
esac

re-prompt() {
    zle .reset-prompt
    zle .accept-line
}

zle -N accept-line re-prompt

# show SSH sign

# auto change directory
#
setopt auto_cd

# auto directory pushd that you can get dirs list by cd -[tab]
#
setopt auto_pushd

# command correct edition before each completion attempt
#
setopt correct

# compacked complete list display
#
setopt list_packed

# no remove postfix slash of command line
#
setopt noautoremoveslash

# no beep sound when complete list displayed
#
setopt nolistbeep

## Keybind configuration
#
# emacs like keybind (e.x. Ctrl-a goes to head of a line and Ctrl-e goes
# to end of it)
#
bindkey -e

# historical backward/forward search with linehead string binded to ^P/^N
#
autoload history-search-end
zle -N history-beginning-search-backward-end history-search-end
zle -N history-beginning-search-forward-end history-search-end
bindkey "^p" history-beginning-search-backward-end
bindkey "^n" history-beginning-search-forward-end
bindkey "\\ep" history-beginning-search-backward-end
bindkey "\\en" history-beginning-search-forward-end

## Command history configuration
#
HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000
setopt hist_ignore_dups # ignore duplication command history list
setopt share_history # share command history data

## Completion configuration
#
autoload -U compinit
compinit


## Window configs

set_window() {
    echo -ne "\ek$1\e\\"
}

set_default_window() {
    local cmd=$1
    local ssh_host=""
    if [ -n "${REMOTEHOST}${SSH_CONNECTION}" ]; then ssh_host="${SSH_EMOJI} ${HOST%%.*}:"; fi
    set_window "${cmd} ${ssh_host}$(if [ $(pwd) = ~ ]; then echo "~/"; else echo "$(basename $(pwd))"; fi)"
}

preexec() {
    set_default_window ${1%% *}
}
chpwd() {
    set_default_window "cd"
}
set_default_window "login"

ssh() {
  if [ "$(ps -p $(ps -p $$ -o ppid=) -o comm=)" = "tmux" ]; then
    local window_name=$(tmux display -p '#{window_name}')
    tmux rename-window "ssh ${SSH_EMOJI} ${@: -1}"
    command ssh "$@"
    tmux rename-window $window_name
  else
    command ssh "$@"
  fi
}


## z
#
if [ -e /etc/profile.d/z.sh ]; then
    . `brew --prefix`/etc/profile.d/z.sh
    function precmd () {
       z --add "$(pwd -P)"
    }
fi


## Alias configuration
#
# expand aliases before completing
#
setopt complete_aliases # aliased ls needs if file/dir completions work

alias where="command -v"
alias j="jobs -l"

case "${OSTYPE}" in
freebsd*|darwin*)
  alias ls="ls -G -w"
  ;;
linux*)
  alias ls="ls --color"
  ;;
esac

alias la="ls -a"
alias lf="ls -F"
alias ll="ls -l"

alias du="du -h"
alias df="df -h"

alias su="su -l"

# global alias
alias -g G="| grep"
alias -g W="| wc"
alias -g H="| head"
alias -g T="| tail"
alias -g V="| vim"

# environment dependent aliases
if which gls > /dev/null 2>&1; then
    alias ls="gls --color=auto"
fi


## export configuration
#
export CPPFLAGS=-I/opt/X11/include
export JAVA_HOME=/Library/Java/Home
export PATH=$PATH:/Applications/Xcode.app/Contents/Developer/usr/bin/:/Applications/android-sdk-macosx/platform-tools:/Applications/android-ndk-r9b/:~/Library/Android/sdk/platform-tools/
export SVN_EDITOR=vim
export _JAVA_OPTIONS="-Dfile.encoding=UTF-8"
if [ $(uname -s) = Darwin ]; then
    export SCREENDIR=~/.screen
fi
# for grep
export GREP_COLOR='01;33'
export GREP_OPTIONS='--color=auto'
# for japanese
export WCWIDTH_CJK_LEGACY=yes


## terminal configuration
#
unset LSCOLORS
case "${TERM}" in
xterm)
  export TERM=xterm-color
  ;;
kterm)
  export TERM=kterm-color
  # set BackSpace control character
  stty erase
  ;;
cons25)
  unset LANG
  export LSCOLORS=ExFxCxdxBxegedabagacad
  export LS_COLORS='di=01;34:ln=01;35:so=01;32:ex=01;31:bd=46;34:cd=43;34:su=41;30:sg=46;30:tw=42;30:ow=43;30'
  zstyle ':completion:*' list-colors \
    'di=;34;1' 'ln=;35;1' 'so=;32;1' 'ex=31;1' 'bd=46;34' 'cd=43;34'
  ;;
*)
  export TERM=xterm-256color
  ;;
esac

# set terminal title including current directory
#
case "${TERM}" in
kterm*|xterm*)
  precmd() {
    echo -ne "\033]0;${USER}@${HOST%%.*}:${PWD}\007"
  }
  export LSCOLORS=exfxcxdxbxegedabagacad
  export LS_COLORS='di=34:ln=35:so=32:pi=33:ex=31:bd=46;34:cd=43;34:su=41;30:sg=46;30:tw=42;30:ow=43;30'
  zstyle ':completion:*' list-colors \
    'di=34' 'ln=35' 'so=32' 'ex=31' 'bd=46;34' 'cd=43;34'
  ;;
esac

if which gdircolors > /dev/null 2>&1; then
    eval $(gdircolors ~/.zsh/dircolors-solarized/dircolors.ansi-universal)
fi
if which dircolors > /dev/null 2>&1; then
    eval $(dircolors ~/.zsh/dircolors-solarized/dircolors.ansi-universal)
fi



# #load user .zshrc configuration file
#
[ -f ~/.zshrc.zplug ] && source ~/.zshrc.zplug
[ -f ~/.zshrc.mine ] && source ~/.zshrc.mine
[ -f ~/.zsh/func.zsh ] && source ~/.zsh/func.zsh

PATH=$PATH:$HOME/.rvm/bin # Add RVM to PATH for scripting

### Added by the Heroku Toolbelt
export PATH="/usr/local/heroku/bin:$PATH"
export PATH="/usr/local/bin:$PATH"

### Add for aws
export PATH="${HOME}/aws/AWS-ElasticBeanstalk-CLI-2.6.3/eb/macosx/python2.7:$PATH"

export PATH="${HOME}/google-cloud-sdk/bin:$PATH"
# The next line updates PATH for the Google Cloud SDK.
[ -f ~/google-cloud-sdk/path.zsh.inc ] && source ~/google-cloud-sdk/path.zsh.inc

if [ -e ${HOME}/.aws ]; then
    export AWS_ACCESS_KEY_ID=$(grep aws_access_key_id ${HOME}/.aws/credentials | sed -e 's/.*= *//')
    export AWS_SECRET_ACCESS_KEY=$(grep aws_secret_access_key ${HOME}/.aws/credentials | sed -e 's/.*= *//')
    export AWS_REGION=$(grep region ${HOME}/.aws/config | sed -e 's/.*= *//')
    export AWS_DEFAULT_REGION=$(grep region ${HOME}/.aws/config | sed -e 's/.*= *//')
fi

### Nodebrew
export PATH=$HOME/.nodebrew/current/bin:$PATH

# rbenv
eval "$(rbenv init -)"

# direnv
export EDITOR=vim
eval "$(direnv hook zsh)"

