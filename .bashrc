#!/usr/bin/env bash

# If not running interactively, don't do anything
case $- in
  *i*) ;;
    *) return;;
esac

# Path to the bash it configuration
INSTALL_DIR=$HOME/bash-customization

if [[ ! -d $INSTALL_DIR ]]; then
    echo It is expected that bash-customization is under your HOME directiry, i.e. $INSTALL_DIR
    return
fi

export BASH_IT="$INSTALL_DIR/bash-it"

# Lock and Load a custom theme file.
# Leave empty to disable theming.
# location /.bash_it/themes/
export BASH_IT_THEME='powerline-plain'

# (Advanced): Change this to the name of your remote repo if you
# cloned bash-it with a remote other than origin such as `bash-it`.
# export BASH_IT_REMOTE='bash-it'

# (Advanced): Change this to the name of the main development branch if
# you renamed it or if it was changed for some reason
# export BASH_IT_DEVELOPMENT_BRANCH='master'

# Your place for hosting Git repos. I use this for private repos.
export GIT_HOSTING='git@git.domain.com'

# Don't check mail when opening terminal.
unset MAILCHECK

# Change this to your console based IRC client of choice.
export IRC_CLIENT='irssi'

# Set this to the command you use for todo.txt-cli
export TODO="t"

# Set this to false to turn off version control status checking within the prompt for all themes
export SCM_CHECK=true
# Set to actual location of gitstatus directory if installed
#export SCM_GIT_GITSTATUS_DIR="$HOME/gitstatus"
# per default gitstatus uses 2 times as many threads as CPU cores, you can change this here if you must
#export GITSTATUS_NUM_THREADS=8

# Set Xterm/screen/Tmux title with only a short hostname.
# Uncomment this (or set SHORT_HOSTNAME to something else),
# Will otherwise fall back on $HOSTNAME.
#export SHORT_HOSTNAME=$(hostname -s)

# Set Xterm/screen/Tmux title with only a short username.
# Uncomment this (or set SHORT_USER to something else),
# Will otherwise fall back on $USER.
#export SHORT_USER=${USER:0:8}

# If your theme use command duration, uncomment this to
# enable display of last command duration.
#export BASH_IT_COMMAND_DURATION=true
# You can choose the minimum time in seconds before
# command duration is displayed.
#export COMMAND_DURATION_MIN_SECONDS=1

# Set Xterm/screen/Tmux title with shortened command and directory.
# Uncomment this to set.
#export SHORT_TERM_LINE=true

# Set vcprompt executable path for scm advance info in prompt (demula theme)
# https://github.com/djl/vcprompt
#export VCPROMPT_EXECUTABLE=~/.vcprompt/bin/vcprompt

# (Advanced): Uncomment this to make Bash-it reload itself automatically
# after enabling or disabling aliases, plugins, and completions.
# export BASH_IT_AUTOMATIC_RELOAD_AFTER_CONFIG_CHANGE=1

# Uncomment this to make Bash-it create alias reload.
# export BASH_IT_RELOAD_LEGACY=1

PROMPT_COMMAND='echo -ne "\033]0;${USER}@${HOSTNAME}: ${PWD}\007"'

export POWERLINE_PROMPT="hostname user_info scm python_venv ruby node k8s_context k8s_namespace cwd"
export POWERLINE_PROMPT="hostname user_info scm python_venv ruby node k8s_namespace cwd"
# Load Bash It
source "$BASH_IT"/bash_it.sh
if ! which fzf > /dev/null 2>&1; then
	export PATH=$INSTALL_DIR/bin:$PATH
fi

# Load ble.sh
source $INSTALL_DIR/ble.sh/ble.sh 
# Integrage ble.sh with bash-it fzf
_ble_contrib_fzf_base=$INSTALL_DIR/fzf
ble-import -d contrib/fzf-completion
ble-import -d contrib/fzf-key-bindings

ble-color-setface command_file fg=40
ble-color-setface filename_directory fg=12
ble-color-setface auto_complete fg=white
ble-color-setface region_insert fg=26,bg=252
ble-color-setface syntax_error fg=0,bg=203
ble-color-setface filename_other fg=white

alias kns=$'NAMESPACE=$(kubectl get ns | grep -v NAME | awk \'{print $1}\' | fzf ); [[ -n ${NAMESPACE} ]] && kubectl config set-context --current --namespace=${NAMESPACE}'
alias k=kubectl

