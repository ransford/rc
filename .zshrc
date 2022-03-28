# vim:et ts=4 sw=4
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

# source .profile to get environment
[[ -o login ]] || source "$HOME/.profile"

################################################################################
# modules
################################################################################
autoload -U colors
autoload -U select-word-style
autoload -U zmv
autoload -U zsh/terminfo
autoload -Uz vcs_info
autoload -Uz edit-command-line
zle -N edit-command-line

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
unsetopt SHARE_HISTORY

HISTFILE="$ZDOTDIR/.zhistory.local"
SAVEHIST=1000
HISTSIZE=1000

select-word-style bash          # bash-style word selection ('/' word boundary)

# keybindings!
bindkey -e                      # emacs keybindings
bindkey "[3~" backward-kill-word        # alt-backspace
bindkey "^[[5~" history-search-backward # page up
bindkey "^[[6~" history-search-forward  # page down
bindkey "^x^e" edit-command-line        # full-screen command editing

# are we on a color terminal?
if [[ "$terminfo[colors]" -ge 8 ]]; then
    export COLORTERM=1
    colors
fi

################################################################################
# functions
################################################################################

_ssh_auth_save() {
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

_screen() {
    _ssh_auth_save || return 1
    HOST=$HOST \screen $*
}

# run before each prompt
precmd() {
    vcs_info
    case $TERM in
        screen*) print -n "\ek${ZSH_NAME}\e\\"
    esac
}

# run after each command is read but before it's executed
preexec() {
    case $TERM in
        screen*) print -n "\ek${1%%[[:space:]]*}\e\\" ;;
    esac
}

# emulate chpwd_functions hook for zsh < 4.3.5
# http://ruderich.org/simon/config/zshrc
if [[ $ZSH_VERSION < '4.3' ]]; then
    chpwd() {
        for function in $chpwd_functions; do
            $function $@
        done
    }
fi

# prompt stuff -- eww.
setprompt () {
    case $TERM in
        xterm*)     _PR_TITLEPART=$'%{\e]0;%m:%1~\a%}' ;;
        screen*)    _PR_TITLEPART=$'%{\e_:\005 (\005t)    %m    %~\e\\%}' ;;
        *)          _PR_TITLEPART='' ;;
    esac
    _PR_HOSTPART="%m:"
    if [[ $COLORTERM -eq 1 ]]; then
        # https://www.ditig.com/256-colors-cheat-sheet
        _PR_TIMEPART='%F{242}%T%f '
        _PR_ECODEPART="%(?..%B%F{red}%?!%f%b)"
        _PR_DIRPART="%$(expr $COLUMNS / 2 - 6)<...<%U%F{blue}%1~%f%u%<<"
        _PR_INDICATORPART="%F{cyan}%#%f "
    else
        _PR_TIMEPART='%B%T%b '
        _PR_ECODEPART='%(?..%B%?%b!)'
        _PR_DIRPART="%$(expr $COLUMNS / 2 - 6)<...<%U%1~%u%<<"
        _PR_INDICATORPART='%B%#%b '
    fi
    PROMPT='${_PR_TITLEPART}${_PR_TIMEPART}${_PR_ECODEPART}${_PR_HOSTPART}${_PR_DIRPART}${_PR_INDICATORPART}'
    RPROMPT='${vcs_info_msg_0_}'
}

# gpg-decrypt a file
gpgd () {
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

# git commit browser adapted from https://github.com/junegunn/fzf/wiki/examples
gitbrowse() {
  logfmt='%h %C(magenta)%an%C(cyan)%d%C(white) %s %Creset- %ar'
  git log --color=always --pretty="format:$logfmt" "$@" |
  fzf --ansi --no-sort --reverse --tiebreak=index --bind "enter:execute(git show -m {1})"
}

zstyle ':completion:*' completer _expand _complete
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
autoload -U compinit && compinit

zstyle ':vcs_info:*' enable git
zstyle ':vcs_info:*' check-for-staged-changes true # enable %c
zstyle ':vcs_info:*' stagedstr ' +'
# zstyle ':vcs_info:*' unstagedstr ' *'
zstyle ':vcs_info:*' formats '%F{170}(%b%c)%m'
zstyle ':vcs_info:*' actionformats '%F{162}(%b|%a%c)%m'

setprompt

OS="$(uname -s)"
MACHINE="$(uname -m)"
test -r "$ZDOTDIR/.zshrc.$OS" && source "$ZDOTDIR/.zshrc.$OS"
test -r "$ZDOTDIR/.zshrc.$OS.$MACHINE" && source "$ZDOTDIR/.zshrc.$OS.$MACHINE"
unset MACHINE
unset OS

uptime

test -r "$ZDOTDIR/.zshrc.local" && source "$ZDOTDIR/.zshrc.local"

true
