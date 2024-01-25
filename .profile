# ~/.profile: executed by the command interpreter for login shells.
# This file is not read by bash(1), if ~/.bash_profile or ~/.bash_login
# exists.
# see /usr/share/doc/bash/examples/startup-files for examples.
# the files are located in the bash-doc package.

# the default umask is set in /etc/profile; for setting the umask
# for ssh logins, install and configure the libpam-umask package.
#umask 022

# if running bash
if [ -n "$BASH_VERSION" ]; then
    # include .bashrc if it exists
    if [ -f "$HOME/.bashrc" ]; then
	. "$HOME/.bashrc"
    fi
fi

# set PATH so it includes user's private bin if it exists
if [ -d "$HOME/bin" ] ; then
    PATH="$HOME/bin:$PATH"
fi

# set PATH so it includes user's private bin if it exists
if [ -d "$HOME/.local/bin" ] ; then
    PATH="$HOME/.local/bin:$PATH"
fi

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    alias less='less -R'
    #alias dir='dir --color=auto'
    #alias vdir='vdir --color=auto'

    alias grep='grep --color=auto --exclude-dir={.bzr,CVS,.git,.hg,.svn,.idea,.tox}'
    alias fgrep='fgrep --color=auto --exclude-dir={.bzr,CVS,.git,.hg,.svn,.idea,.tox}'
    alias egrep='egrep --color=auto --exclude-dir={.bzr,CVS,.git,.hg,.svn,.idea,.tox}'
fi

# pager
export PAGER=less

# begin scott customization
export PATH=.:~/extJava/alternatives/maven/bin:~/extJava/alternatives/gradle/bin:~/shell:$PATH

# add python modules & python environment (see https://www.omgubuntu.co.uk/2023/04/pip-install-error-externally-managed-environment-fix)
export PYTHONPATH=~/shell/python_modules:$PYTHONPATH
export PATH=~/python-user/bin:$PATH

function ff {
    find . -name $* -print
}

# emacs setup
export ALTERNATE_EDITOR=emacs
export EDITOR=emacsclient
alias emacs=emacsclient

# box directory
export BOXDIR=/run/user/$UID/gvfs/dav:host=dav.box.com,ssl=true/dav

PATH="/home/scott/perl5/bin${PATH:+:${PATH}}"; export PATH;
PERL5LIB="/home/scott/perl5/lib/perl5${PERL5LIB:+:${PERL5LIB}}"; export PERL5LIB;
PERL_LOCAL_LIB_ROOT="/home/scott/perl5${PERL_LOCAL_LIB_ROOT:+:${PERL_LOCAL_LIB_ROOT}}"; export PERL_LOCAL_LIB_ROOT;
PERL_MB_OPT="--install_base \"/home/scott/perl5\""; export PERL_MB_OPT;
PERL_MM_OPT="INSTALL_BASE=/home/scott/perl5"; export PERL_MM_OPT;

# unique-ify the path
PATH=$(uniqueList.sh "$PATH")

# put the snap bin directory first in the list
export PATH=/snap/bin:$PATH

LAPTOP_IP=192.168.1.20
alias laptop="ssh $(whoami)@$LAPTOP_IP"
alias laptopx="laptop xterm -fg yellow -font 9x15"
LAPTOP_DIR=/run/user/1001/gvfs/smb-share:server=$LAPTOP_IP,share=$(whoami)

# convenience alias to mount the laptop filesystem
alias mntlaptop="gio mount smb://$LAPTOP_IP/scott"
