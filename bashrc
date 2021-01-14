# -*- mode: shell-script; -*-
#+DEST=$HOME/
#+FNAME=.bashrc

# If not running interactively, don't do anything
[ -z "$PS1" ] && return

# set PATH so it includes user's private bin if it exists
if [ -d "$HOME/bin" ] ; then
    PATH="$HOME/bin:$PATH"
fi

# enable programmable completion features
if [ -f /etc/bash_completion ] && ! shopt -oq posix; then
    . /etc/bash_completion  > /dev/null
fi

if [ -d "~/.bash_completion.d/" ] ; then
    for bcfile in ~/.bash_completion.d/* ; do
        . $bcfile
    done
fi

# for supporting completion in emacs
if [[ $INSIDE_EMACS ]]; then
    set completion-display-width 0
    set horizontal-scroll-mode on
    set page-completions off
fi

# don't put duplicate lines in the history. See bash(1) for more options
# ... or force ignoredups and ignorespace
HISTCONTROL="ignoredups:ignorespace:erasedups"

# append to the history file, don't overwrite it
shopt -s histappend
shopt -s cmdhist

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=100000
HISTFILESIZE=500000

# Eternal bash history.
# ---------------------
# Undocumented feature which sets the size to "unlimited".
# http://stackoverflow.com/questions/9457233/unlimited-bash-history
export HISTFILESIZE=
export HISTSIZE=
export HISTTIMEFORMAT="[%F %T] "
# Change the file location because certain bash sessions truncate .bash_history file upon close.
# http://superuser.com/questions/575479/bash-history-truncated-to-500-lines-on-each-login
export HISTFILE=~/.bash_eternal_history
# Force prompt to write history after every command.
# http://superuser.com/questions/20900/bash-history-loss
PROMPT_COMMAND="history -a; $PROMPT_COMMAND"


# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

export ALTERNATE_EDITOR=emacs
export EDITOR=emacsclient
export VISUAL=emacsclient
export EDITOR

# PS1
function my_prompt {
    case ${TERM} in
	    xterm*|rxvt*|Eterm|aterm|kterm|gnome*)
            # user@host:workdir \n $ with fancy unicode.
            # PS1="\[\033[0;37m\]\342\224\214\342\224\200\$([[ \$? != 0 ]] && echo \"[\[\033[0;31m\]\342\234\227\[\033[0;37m\]]\342\224\200\")[$(if [[ ${EUID} == 0 ]]; then echo '\[\033[0;31m\]\h'; else echo '\[\033[0;33m\]\u\[\033[0;37m\]@\[\033[0;96m\]\h'; fi)\[\033[0;37m\]]\342\224\200[\[\033[0;32m\]\w\[\033[0;37m\]]\n\[\033[0;37m\]\342\224\224\342\224\200\342\224\200\342\225\274 \[\033[0m\]"
            # user@host:workdir \n $
            # PS1="\[\033[0;37m\]\$([[ \$? != 0 ]] && echo \"\[\033[0;31m\]\342\234\227\[\033[0;37m\] \")$(if [[ ${EUID} == 0 ]]; then echo '\[\033[0;31m\]\h'; else echo '\[\033[0;33m\]\u\[\033[0;37m\]@\[\033[0;96m\]\h'; fi):\[\033[0;32m\]\w\n\[\033[0;37m\]\[\033[0m\]$ "
            # host:workdir \n $
            PS1="\[\033[0;37m\]\$([[ \$? != 0 ]] && echo \"\[\033[0;31m\]\342\234\227\[\033[0;37m\] \")$(if [[ ${EUID} == 0 ]]; then echo '\[\033[0;31m\]\h'; else echo '\[\033[0;96m\]\h'; fi):\[\033[0;32m\]\w\n\[\033[0;37m\]\[\033[0m\]$ "
		    ;;
        *)
            PS1="\u@\h:\w$ "
            ;;
    esac

}

PROMPT_COMMAND=my_prompt
PS2='    '

#
function _exit()        # Function to run upon exit of shell.
{
    echo -e "Well done yag, see you soon :)"
}
trap _exit EXIT

s() { # do sudo, or sudo the last command if no argument given
    if [[ $# == 0 ]]; then
        sudo $(history -p '!!')
    else
        sudo "$@"
    fi
}

# load splitted files
if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

if [ -f ~/.bash_plugins ]; then
    . ~/.bash_plugins
fi

if [ -f ~/.bash_custom ]; then
    . ~/.bash_custom            # system specific
fi

# .bashrc ends here
