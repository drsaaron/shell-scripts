setopt correctall  # enable spellcheck
setopt +o nomatch

# source my generic profile, common to both bash and zsh
. ~/.profile

# source bash aliases, which really should be common aliases
. ~/.bash_aliases

# override aliases for zsh specific versions
alias rstrt=". ~/.zshrc"

# directory stack my usual way
#unalias cd
DIRSTACKSIZE=8
alias dstack="dirs -v"

# turn off the awkward % at the end of partial lines
unsetopt prompt_cr prompt_sp

# set the prompt
PROMPT='%B%F{135}%n %1~%f%b %# '
