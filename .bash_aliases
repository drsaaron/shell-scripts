alias dir='ls -al'
alias dm='dir | $PAGER'
alias dirt='ls -altr'
alias dird='ls -al | grep ^d'

alias atip='ps -ef'
alias btip='atip | grep ^$(whoami)'

# other aliases
alias rstrt='. ~/.bashrc'
alias pk='rm -f *~ .*~'
alias rm='rm -i'
alias dstack='dirs -v'

# history
alias h='history'
alias r='fc -e -'