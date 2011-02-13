###
# $Id: .zshenv,v 1.2 2006-01-12 13:25:16 ben Exp $
### everything goes in ~/.rc/zsh
export ZDOTDIR="$HOME/.rc/zsh"

if [[ -r $ZDOTDIR/.zshenv ]]; then
	. $ZDOTDIR/.zshenv
fi

