alias cd..='cd ..'
alias cpwd='cd "$(pwd -P)"'
alias gdiff='git diff --no-index'
alias lsa='ls -AFl --color=auto'

if test (uname) = Darwin
	abbr --add locate 'mdfind -name'
	abbr --add fin 'mdfind -onlyin . -name'
end

# abbr expands in place
abbr --add s sudo
