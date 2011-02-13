# vim:et ts=4 sw=4
# $Id: .zlogin,v 1.9 2007-02-09 15:21:23 ben Exp $
#
# order of execution:
#   zshenv
#   if login: zprofile
#   if interactive: zshrc
#   if login: zlogin
#   [...]
#   zlogout
#
# this file is sourced *only* if zsh is being launched as a login shell.  so,
# for example, a new zsh running inside a new xterm or screen session will
# *not* source this file.
#

# load local modifications
if [[ -r $ZDOTDIR/.zlogin.local ]]; then
    . $ZDOTDIR/.zlogin.local
fi
