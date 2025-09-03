# some more ls aliases
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'
alias dir='ls -al'
alias dm='dir | $PAGER'
alias dirt='ls -altr'
alias dird='ls -al | grep ^d'

alias atip='ps -ef'
alias btip='atip | grep ^$(whoami)'

# some more ls aliases
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'

# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

# other aliases
alias rstrt='. ~/.bashrc'
alias pk='rm -f *~ .*~'
alias rm='rm -i'
alias dstack='dirs -v'
alias ddiff='diff -rq'  # directory difference

# history
alias h='history'
alias r='fc -e -'

# ssh
alias ssh='ssh -X'

# copy something to the xwindows clipboard, e.g. pass home | xc
alias xc='tr -d \\n | xclip -selection c'

# start netbeans.  Use the most recent version
alias nb="~/netbeans/$(ls ~/netbeans | sort | tail -1)/netbeans/bin/netbeans"
