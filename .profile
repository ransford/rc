# .profile -- interactive bash-ish shells

test -r /etc/profile && source /etc/profile

function path_prepend() {
	if [ -d "$1" ] && [[ ":$PATH:" != *":$1:"* ]]; then
		PATH="$1${PATH:+":$PATH"}"
	fi
}

function path_append() {
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
export CVS_RSH=ssh
export LSCOLORS="CxfxcxdxBxegedabagacad"
export PAGER=less
export WATCHFMT="%D %T: %B%n%b %a on %l from %M"

for x in vim vi emacs nano; do
    type "$x" >/dev/null 2>&1 && {
        export EDITOR="$x"
        break
    }
done

type svneditor >/dev/null 2>&1 && export SVN_EDITOR=svneditor

# color grep if available
if echo x | grep --color=auto x >/dev/null 2>/dev/null; then
    export GREP_OPTIONS="--color=auto" GREP_COLOR="0;35" # yellow
fi

################################################################################
# aliases
################################################################################
alias cd..='cd ..'
alias cpwd='cd "$(pwd -P)"'
alias elcc="emacs -batch -eval '(setq load-path (cons \".\" load-path))' -q -f batch-byte-compile"
alias lpreven='lpr -o page-set=even'
alias lprodd='lpr -o page-set=odd'
alias lsa="ls -AFl --color=auto"
alias nl='nl -ba'
alias muttg='mutt -F ~/.rc/.muttrc.gmail'
alias httpsrvpwd='python -m SimpleHTTPServer'
alias gpge='gpg --encrypt'
alias s='sudo'
alias rmbr='remember'
alias gdiff='git diff --no-index'

test -r "$HOME/.profile.local" && source "$HOME/.profile.local"

# is this bash?  if so, load .bashrc
test -n "$BASH_VERSION" && shopt -q login_shell && source "$HOME/.bashrc"

uptime
