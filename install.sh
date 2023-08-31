#!/bin/bash -eu

WHEREAMI=$(dirname "$0")
RC=$(cd "$WHEREAMI" && pwd -P | sed -e "s,^${HOME}/,,")

cd "$HOME"
for x in \
	.config \
	.gitconfig \
	.profile \
	.tmux.conf \
	.vim \
	.vimrc \
	.zshenv \
	; do
	if [ -L "$x" ]; then
		LTARGET=$(readlink "$x")
		INODE1=$(ls -id "$LTARGET" | cut -d' ' -f1)
		INODE2=$(ls -id "$RC/$x" | cut -d' ' -f1)
		if [ "$INODE1" = "$INODE2" ]; then
			echo "$x: Already symlinked; doing nothing" >&2
		fi
		continue
	elif [ -e "$x" ]; then
		echo "$x: File or directory exists; doing nothing" >&2
		continue
	fi

	# make a symlink
	ln -s "$RC/$x" .
done
