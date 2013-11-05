# .profile -- interactive bash-ish shells

test -r /etc/profile && source /etc/profile

# $PATH munging
for x in \
	"$HOME/bin" \
	"$HOME/bin/noarch" \
	"$HOME/bin/$(uname -s)" \
	"$HOME/bin/$(uname -s).$(uname -m)" \
	; do
	test -d "$x" && PATH="$x:$PATH"
done

################################################################################
# environment variables
################################################################################
export CVS_RSH=ssh
export LSCOLORS="CxfxcxdxBxegedabagacad"
export PAGER=less
export WATCHFMT="%D %T: %B%n%b %a on %l from %M"

for x in vim vi emacs nano; do
    if test -n `whereis "$x"`; then
        export EDITOR="$x"
        break
    fi
done

if test -n `whereis svneditor`; then
    export SVN_EDITOR=svneditor
fi

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
