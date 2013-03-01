# .bash_profile -- interactive login shells

if [ -r /etc/profile ]; then
	source /etc/profile
fi

if [ -r .bashrc ]; then
	source .bashrc
fi

uptime
