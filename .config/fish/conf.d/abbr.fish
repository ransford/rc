# aliases & abbreviations for all platforms
if ! status is-interactive; return 0; end

alias cd..='cd ..'
alias cpwd='cd "$(pwd -P)"'
alias gdiff='git diff --no-index'
alias lsa='ls -AFl --color=auto'

# abbr expands in place
abbr --add s sudo
