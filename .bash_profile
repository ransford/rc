# .bash_profile -- interactive login shells

if [ -r /etc/profile ]; then
	source /etc/profile
fi

if [ -r .bashrc ]; then
	source .bashrc
fi

# environment variables
PATH="$HOME/bin/$(uname -s).$(uname -m):$HOME/bin:$PATH"
export EDITOR=vim

uptime
