# .bash_profile -- interactive login shells

if [ -r /etc/profile ]; then
	source /etc/profile
fi

if [ -r "$HOME/.bashrc" ]; then
	source "$HOME/.bashrc"
fi

# environment variables
## build up PATH backwards -- increasing specificity
PATH="$HOME/bin:$PATH"
PATH="$HOME/bin/noarch:$PATH"
PATH="$HOME/bin/$(uname -s):$PATH"
PATH="$HOME/bin/$(uname -s).$(uname -m):$PATH"

export EDITOR=vim

if [ -r "$HOME/.bash_profile.local" ]; then
	source "$HOME/.bash_profile.local"
fi

uptime
