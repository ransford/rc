# .bash_profile -- interactive login shells

if [ -r /etc/profile ]; then
	source /etc/profile
fi

if [ -r .bashrc ]; then
	source .bashrc
fi

# environment variables
## build up PATH backwards -- increasing specificity
PATH="$HOME/bin:$PATH"
PATH="$HOME/bin/noarch:$PATH"
PATH="$HOME/bin/$(uname -s):$PATH"
PATH="$HOME/bin/$(uname -s).$(uname -m):$PATH"

export EDITOR=vim

if [ -r .bash_profile.local ]; then
	source .bash_profile.local
fi

uptime
