#!/bin/bash
WHEREAMI=`dirname "$0"`
RC=`cd "$WHEREAMI" && pwd -P | sed -e "s,^$HOME/,,"`

function dbg() {
	echo "$1" 1>&2
}

cd "$HOME"
for x in \
	.bashrc \
	.bash_profile \
	.emacs \
	.gitconfig \
	.profile \
	.screenrc \
	.subversion \
	.tmux.conf \
	.vim \
	.vimrc \
	.Xresources \
	.zshenv \
	; do
	if [ -L "$x" ]; then
		LTARGET=`readlink "$x"`
		INODE1=`ls -id "$LTARGET" | cut -d' ' -f1`
		INODE2=`ls -id "$RC/$x" | cut -d' ' -f1`
		if [ "$INODE1" = "$INODE2" ]; then
			dbg "$x: Already symlinked; doing nothing"
		fi
		continue
	elif [ -e "$x" ]; then
		dbg "$x: File or directory exists; doing nothing"
		continue
	fi

	# make a symlink
	ln -s "$RC/$x" .
done
