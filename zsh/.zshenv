# vim:et ts=4 sw=4
# $Id: .zshenv,v 1.14 2008-03-20 16:08:36 ben Exp $
#
# this file is sourced before zprofile, zshrc, and zlogin, regardless of
# whether the current invocation of zsh is a login shell.
#

# useful variables
export PLATFORM=`uname -s`
export ARCH="`uname -s`.`uname -m`"

# load local path settings from $HOME/.pathrc
function loadpathrcs () {
    local PATHRC="$HOME/.pathrc"
    [[ -e "$PATHRC" ]] || return

    typeset -a pathpfx
    while read pline; do
        eval pline=\""$pline"\" # "
        [[ -d "$pline" ]] && pathpfx=($pathpfx $pline)
    done < "$PATHRC"

    path=($pathpfx $path)
    typeset -U path
    export PATHRC_LOADED=1
}
if [[ -z "${PATHRC_LOADED}" ]]; then
  loadpathrcs
fi

[[ -n `whence manpath` ]] && export MANPATH=`manpath`

# environment variables (my own preferences)
for x in vim emacs vi; do
    if [[ -n `whence "$x"` ]]; then
        export EDITOR="$x"
        break
    fi
done

# prefer ssh to rsh for cvs stuff
export CVS_RSH=ssh

if [[ -n `whence less` ]]; then
    export PAGER='less -i'
fi

# web stuff
for x in elinks links lynx GET; do
    if [[ -n `whence "$x"` ]]; then
        export BROWSER="$x"
        break
    fi
done

# history
export HISTSIZE=500

# readable colors for ls
export LSCOLORS="CxfxcxdxBxegedabagacad"

# local mods
if [[ -r $ZDOTDIR/.zshenv.local ]]; then
    . $ZDOTDIR/.zshenv.local
fi
