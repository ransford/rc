# vim:et ts=4 sw=4
# $Id: .zshrc,v 1.34 2008-06-18 16:13:24 ben Exp $
#
# order of execution:
#   zshenv
#   if login: zprofile
#   if interactive: zshrc
#   if login: zlogin
#   [...]
#   zlogout
#
# this file is sourced *only* for an interactive shell, regardless of whether
# it's a login shell.
#

################################################################################
# modules
################################################################################
autoload -U colors
autoload -U select-word-style
autoload -U zmv
autoload -U zsh/terminfo

################################################################################
# set various options
################################################################################
setopt BARE_GLOB_QUAL           # extended globbing: e.g. ls (.)
setopt EXTENDED_GLOB            # extended globbing: e.g. ls *.txt~tmp*
setopt COMPLETE_IN_WORD         # /foo/bar|/baz -> /foo/barrel/baz (| cursor)
setopt GLOB_DOTS                # * includes .*
setopt LONG_LIST_JOBS           # jobs -l
setopt MULT_IOS                 # foo >bar >baz
setopt NO_PROMPT_CR             # no \r before prompt; breaks MLE, fixes echo -n
setopt PROMPT_SUBST             # PROMPT="$foo"

# history-related stuff
setopt HIST_IGNORE_DUPS         # don't save duplicates to history
setopt HIST_IGNORE_SPACE        # don't save ' cmd' to history
setopt HIST_NO_STORE            # don't save history commands to history
HISTFILE="$ZDOTDIR/history.local"
SAVEHIST=500

select-word-style bash          # bash-style word selection ('/' word boundary)

# keybindings!
bindkey -e                      # emacs keybindings
bindkey "[3~" backward-kill-word        # alt-backspace
bindkey "^[[5~" history-search-backward # page up
bindkey "^[[6~" history-search-forward  # page down

# are we on a color terminal?
if [[ "$terminfo[colors]" -ge 8 ]]; then
    export COLORTERM=1
    colors
fi

# color grep if available
if echo x | grep --color=auto x >/dev/null 2>/dev/null; then
    export GREP_OPTIONS="--color=auto" GREP_COLOR="0;35" # yellow
fi

# watch login/logout
# add 'export WATCH=notme' to .zshrc.local to turn this on
export WATCHFMT="%D %T: %B%n%b %a on %l from %M"

################################################################################
# functions
################################################################################
if [ -n "$BROWSER" ]; then
    function google() {
        local SAFE_QUERY_STRING
        SAFE_QUERY_STRING=`echo -n "$*" | python -c 'import urllib,sys; print urllib.quote_plus(sys.stdin.read())'`
        $BROWSER "http://www.google.com/search?q=${SAFE_QUERY_STRING}"
    }
fi

if [[ $COLORTERM -eq 1 && -n `which colordiff` ]]; then
    function svndiff() {
        svn diff $@ | colordiff
    }
fi

function cloak() {
    if [[ ! -z "$HISTFILE" ]]; then
        FOO_HISTFILE="$HISTFILE"
        FOO_SAVEHIST="$SAVEHIST"
        unset HISTFILE
        unset SAVEHIST
    fi
}

function uncloak() {
    if [[ ! -z "$FOO_HISTFILE" ]]; then
        HISTFILE="$FOO_HISTFILE"
        SAVEHIST="$FOO_SAVEHIST"
        unset FOO_HISTFILE
        unset FOO_SAVEHIST
    fi
}

function _ssh_auth_save() {
    if [[ -n "$SSH_AUTH_SOCK" ]] ; then
        # avoid loops
        [[ "$SSH_AUTH_SOCK" = "$HOME/.screen/sasock.$HOST" ]] && return 0

        if [[ -S "$SSH_AUTH_SOCK" && -O "$SSH_AUTH_SOCK" ]] ; then
            if [[ ! -d "$HOME/.screen" ]] ; then
                mkdir -p "$HOME/.screen"  || return 1
                chmod 700 "$HOME/.screen" || return 1
            fi
            ln -sf "$SSH_AUTH_SOCK" "$HOME/.screen/sasock.$HOST" || return 1
        else
            echo "$SSH_AUTH_SOCK is set but weird -- investigate!"
            sleep 1
            return 1
        fi
    fi

    return 0
}

function _screen() {
    _ssh_auth_save || return 1
    HOST=$HOST \screen $*
}

function _getgitbranch() {
    local GB; GB=$(git branch --no-color 2>/dev/null)
    export __GITBRANCH=`echo ${${${(f)GB}:#  *}/\* /}`
}
typeset -ga chpwd_functions
chpwd_functions+=_getgitbranch

function _getgitbranchprompt() {
    [[ -n "${__GITBRANCH}" ]] && \
        print -n "%{$fg[blue]%}[${__GITBRANCH}]%{$terminfo[sgr0]%}"
}

# run before each prompt
function precmd() {
    local _H; _H="$(history $(( $HISTCMD - 1 )))"
    case "${_H/ ##[[:digit:]]## ##/}" in
        git*) _getgitbranch ;;
    esac
    case $TERM in
        screen*) print -n "\ek${ZSH_NAME}\e\\"
    esac
}

# run after each command is read but before it's executed
function preexec() {
    case $TERM in
        screen*) print -n "\ek${1%%[[:space:]]*}\e\\" ;;
    esac
}

# prompt stuff -- eww.
function setprompt () {
    case $TERM in
        xterm*)     _PR_TITLEPART=$'%{\e]0;%n@%m:%~\a%}' ;;
        screen*)    _PR_TITLEPART=$'%{\e_:\005 (\005t)    %n@%m    %~\e\\%}' ;;
        *)          _PR_TITLEPART='' ;;
    esac
    _PR_USERPART="%n@%m"
    if [[ $COLORTERM -eq 1 ]]; then
        _PR_TIMEPART="%{$fg[green]%}%T%{$terminfo[sgr0]%} "
    else
        _PR_TIMEPART="%B%T%b "
    fi
    _PR_DIRPART="%$(expr $COLUMNS / 2 - 6)<...<%~%<<"
    _PR_ECODEPART='%(?..%B%?%b!)'
    PROMPT='${_PR_TITLEPART}${_PR_TIMEPART}${_PR_ECODEPART}${_PR_USERPART}:%U${_PR_DIRPART}%u%B%#%b '
    RPROMPT='$(_getgitbranchprompt)'
}

# gpg-decrypt a file
function gpgd () {
    FNAME=$1
    if [[ -z "$FNAME" || "$FNAME" = "${FNAME%.gpg}" ]]; then
        echo "Usage: gpgd <filename.gpg>"
        return
    fi
    if [[ -e "${FNAME%.gpg}" ]]; then
        echo "ERROR: Output file ${FNAME%.gpg} already exists"
        return
    fi
    gpg --decrypt --output "${FNAME%.gpg}" "${FNAME}"
}

################################################################################
# aliases
################################################################################
alias cpwd='cd "`pwd -P`"'
alias elcc="emacs -batch -eval '(setq load-path (cons \".\" load-path))' -q -f batch-byte-compile"
alias lpreven='lpr -o page-set=even'
alias lprodd='lpr -o page-set=odd'
alias lsa="ls -AFl --color=auto"
alias nl='nl -ba'
alias screen='_screen'
alias muttg='mutt -F ~/.rc/.muttrc.gmail'
alias httpsrvpwd='python -m SimpleHTTPServer'
alias gpge='gpg --encrypt'
alias s=sudo
alias rmbr=remember

################################################################################
# completion
################################################################################
# The following lines were added by compinstall

zstyle ':completion:*' completer _expand _complete
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}

# case-insensitive matching on mac
if [[ $PLATFORM = "Darwin" ]]; then
    zstyle ':completion:*' matcher-list '' 'm:{a-zA-Z}={A-Za-z}'
fi

autoload -U compinit && compinit
# End of lines added by compinstall

################################################################################
# miscellany
################################################################################

# do some stuff only for login shells
if [[ -o LOGIN ]]; then
    uptime
fi

setprompt

if [[ -r "$ZDOTDIR/.zshrc.$PLATFORM" ]]; then
    . "$ZDOTDIR/.zshrc.$PLATFORM"
fi

# load local modifications
if [[ -r $ZDOTDIR/.zshrc.local ]]; then
    . $ZDOTDIR/.zshrc.local
fi
