# vim:et ts=4 sw=4
# $Id: .zprofile,v 1.6 2007-02-09 15:21:23 ben Exp $
#
# order of execution:
#   zshenv
#   if login: zprofile
#   if interactive: zshrc
#   if login: zlogin
#   [...]
#   zlogout
#
# this file is sourced *before* zshrc and zlogin.  it is sourced *only* if zsh
# is being launched as a login shell.
#

# load local modifications
if [[ -r $ZDOTDIR/.zprofile.local ]]; then
    . $ZDOTDIR/.zprofile.local
fi
