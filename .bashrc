# ~/.bashrc: executed by bash(1) for non-login shells.

# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=1000
HISTFILESIZE=2000

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# Alias definitions.
if [ -f "~/aliases" ]; then
    source "~/aliases"
fi

# Environment setup
if [ -f ~/.env ]; then
	source ~/.env
fi

[ -f ~/.fzf.bash ] && source ~/.fzf.bash
