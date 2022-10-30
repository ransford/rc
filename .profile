# .profile
# bash: executed in login shell
# zsh: manually executed from .zprofile in login shell
# should produce NO console output!

# unset these later
RC="$HOME/.rc"
OS="$(uname -s)"
ARCH="$(uname -m)"

path_prepend() {
	if [ -d "$1" ] && [[ ":$PATH:" != *":$1:"* ]]; then
		PATH="$1${PATH:+":$PATH"}"
	fi
}

path_append() {
	if [ -d "$1" ] && [[ ":$PATH:" != *":$1:"* ]]; then
		PATH="${PATH:+"$PATH:"}$1"
	fi
}

path_prepend "$HOME/bin"
path_prepend "$HOME/bin/noarch"
path_prepend "$HOME/bin/$(uname -s)"
path_prepend "$HOME/bin/$(uname -s).$(uname -m)"

################################################################################
# environment variables
################################################################################
export LSCOLORS="CxfxcxdxBxegedabagacad"
export PAGER=less
export WATCHFMT="%D %T: %B%n%b %a on %l from %M"
export PYTHONSTARTUP="${RC}/.pythonrc"

for x in vim vi emacs nano; do
    type "$x" >/dev/null 2>&1 && {
        export EDITOR="$x"
        break
    }
done

if hash gvim >&/dev/null; then
    alias gvimt='gvim --remote-tab-silent'
fi

# color grep if available
if echo x | grep --color=auto x >/dev/null 2>/dev/null; then
    alias grep='grep --color=auto'
    export GREP_COLOR="0;35" # yellow
fi

################################################################################
# aliases
################################################################################
alias cd..='cd ..'
alias cpwd='cd "$(pwd -P)"'
alias nl='nl -ba'
alias httpsrvpwd='python3 -m http.server'
alias s='sudo'
alias gdiff='git diff --no-index'
alias ve='source .venv/bin/activate'

# fat fingers maek for lots of typos
alias maek='make'

test -r "$RC/.profile.$OS" && source "$RC/.profile.$OS"
test -r "$RC/.profile.$OS.$ARCH" && source "$RC/.profile.$OS.$ARCH"
test -r "$RC/.profile.local" && source "$RC/.profile.local"
