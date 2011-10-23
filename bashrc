# -*- mode: shell-script; -*-
#+DEST=$HOME/
#+FNAME=.bashrc

# If not running interactively, don't do anything
[ -z "$PS1" ] && return

# set PATH so it includes user's private bin if it exists
if [ -d "$HOME/bin" ] ; then
    PATH="$HOME/bin:$PATH"
fi

# Alias definitions.
if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

# system customization # SYSTEM DEPENDENT
if [ -f ~/.bash_custom ]; then
    . ~/.bash_custom
fi

# enable programmable completion features
if [ -f /etc/bash_completion ] && ! shopt -oq posix; then
    . /etc/bash_completion  > /dev/null
fi

#perlbrew
if [ -f ~/perl5/perlbrew/etc/bashrc  ]; then
    . ~/perl5/perlbrew/etc/bashrc
fi

# don't put duplicate lines in the history. See bash(1) for more options
# ... or force ignoredups and ignorespace
HISTCONTROL=ignoredups:ignorespace

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=1000
HISTFILESIZE=2000

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "$debian_chroot" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-color) color_prompt=yes;;
esac

# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
force_color_prompt=yes
if [ -n "$force_color_prompt" ]; then
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
    # We have color support; assume it's compliant with Ecma-48
    # (ISO/IEC-6429). (Lack of such support is extremely rare, and such
    # a case would tend to support setf rather than setaf.)
        color_prompt=yes
    else
        color_prompt=
    fi
fi

if [ "$color_prompt" = yes ]; then
    PS1='${debian_chroot:+($debian_chroot)}\[\033[33;1m\]\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '

else
    PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
fi
unset color_prompt force_color_prompt

# If this is an xterm set the title to user@host:dir
case "$TERM" in
    xterm*|rxvt*)
        PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
        ;;
    *)
        ;;
esac

#ADDING ENV VARS
# ---------------------

export PATH=$PATH:/bin:/usr/bin

#info path
export INFOPATH=$INFOPATH:"~/git/info"

# EDITOR thing
export ALTERNATE_EDITOR=emacs
export EDITOR=emacsclient
export VISUAL=emacsclient
export EDITOR

# if [ -x $HOME/bin/default_editor ]; then
#     export EDITOR=$HOME/bin/default_editor
# else
#     export EDITOR=`which vi`
# fi

# Sets the Mail Environment Variable
MAIL=/var/spool/mail/yagnesh && export MAIL

# ---------------------
#FUNCTIONS
# ---------------------

# CAT & MORE combined
function cm () { cat $1 | more; }

####
#-----------------------------------------------------------------
####

function _exit()        # Function to run upon exit of shell.
{
    echo -e "Well Done YAG baby"
}
trap _exit EXIT

function cuttail() # cut last n lines in file, 10 by default
{
    nlines=${2:-10}
    sed -n -e :a -e "1,${nlines}!{P;N;D;};N;ba" $1
}

s() { # do sudo, or sudo the last command if no argument given
    if [[ $# == 0 ]]; then
        sudo $(history -p '!!')
    else
        sudo "$@"
    fi
}

psgrep() {
    if [ ! -z $1 ] ; then
        echo "Grepping for processes matching $1..."
        ps aux | grep $1 | grep -v grep
    else
        echo "!! Need name to grep for"
    fi
}

grab() {
    sudo chown -R ${USER} ${1:-.}
}

# clock - A bash clock that can run in your terminal window.
clock ()
{
    while true;do clear;echo "===========";date +"%r";echo "===========";sleep 1;done
}

#-------------------------------------------------------------
# Misc utilities:
#-------------------------------------------------------------

function ask()          # See 'killps' for example of use.
{
    echo -n "$@" '[y/n] ' ; read ans
    case "$ans" in
        y*|Y*) return 0 ;;
        *) return 1 ;;
    esac
}

# Make the following commands run in background automatically:
#function firefox() { command firefox "$@" & }

if [ -f ~/.rvm/scripts/rvm ]; then
    source ~/.rvm/scripts/rvm
    rvm 1.9.2
fi

if  [ -f ~/.perlbrew/perl5/perlbrew/etc/bashrc ] ; then
    source ~/.perlbrew/perl5/perlbrew/etc/bashrc
fi



#+END