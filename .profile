# .profile
# bash: executed in login shell
# zsh: manually executed from .zprofile in login shell
# should produce NO console output!

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

# unset these later
RC="$HOME/.rc"
OS="$(uname -s)"
MACHINE="$(uname -m)"

path_prepend "$HOME/bin"
path_prepend "$HOME/bin/noarch"
path_prepend "$HOME/bin/$(uname -s)"
path_prepend "$HOME/bin/$(uname -s).$(uname -m)"

################################################################################
# environment variables
################################################################################
export CVS_RSH=ssh
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

type svneditor >/dev/null 2>&1 && export SVN_EDITOR=svneditor

# color grep if available
if echo x | grep --color=auto x >/dev/null 2>/dev/null; then
    alias grep='grep --color=auto'
    export GREP_COLOR="0;35" # yellow
fi

################################################################################
# aliases
################################################################################
alias ag="ag --pager='less -R'"
alias cd..='cd ..'
alias cpwd='cd "$(pwd -P)"'
alias elcc="emacs -batch -eval '(setq load-path (cons \".\" load-path))' -q -f batch-byte-compile"
alias lpreven='lpr -o page-set=even'
alias lprodd='lpr -o page-set=odd'
alias nl='nl -ba'
alias mutt-gro="mutt -F $RC/.muttrc.gro"
alias mutt-uwcse="mutt -F $RC/.muttrc.uwcse"
alias mutt-virta="mutt -F $RC/.muttrc.virta"
alias httpsrvpwd='python -m SimpleHTTPServer'
alias gpge='gpg --encrypt'
alias s='sudo'
alias rmbr='remember'
alias gdiff='git diff --no-index'
alias ve='source venv/bin/activate'

# fat fingers maek for lots of typos
alias maek='make'

if hash gvim >/dev/null 2>/dev/null; then
	alias gvimt='gvim --remote-tab-silent'
fi

test -r "$RC/.profile.$OS" && source "$RC/.profile.$OS"
test -r "$RC/.profile.$OS.$MACHINE" && source "$RC/.profile.$OS.$MACHINE"
test -r "$RC/.profile.local" && source "$RC/.profile.local"

# clean up local vars
unset MACHINE
unset OS
unset RC
