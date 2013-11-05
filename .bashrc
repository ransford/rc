# .bashrc -- interactive non-login shells

shopt -q login_shell || source "$HOME/.profile"

# prompt
PS1=$'\[\e]0;\h:\W\a\]'			# xterm title
PS1=$PS1$'\[\e[1;31m\]$??'		# exit code $?
PS1=$PS1$'\[\e[0;32m\]\A '		# current time (24h)
PS1=$PS1$'\[\e[1;35m\]\u@\h:\W\$ '	# user@host:~$<space>
PS1=$PS1$'\[\e[0m\]'			# end colors

function _ssh_auth_save() {
	[[ -n "$SSH_AUTH_SOCK" ]] || return 1

	# avoid loops
	[[ "$SSH_AUTH_SOCK" = "$HOME/.screen/sasock.$HOST" ]] && return 0

	if [[ -S "$SSH_AUTH_SOCK" && -O "$SSH_AUTH_SOCK" ]] ; then
		if [[ ! -d "$HOME/.screen" ]] ; then
			mkdir -p "$HOME/.screen"  || return 1
			chmod 700 "$HOME/.screen" || return 1
		fi
		ln -sf "$SSH_AUTH_SOCK" "$HOME/.screen/sasock.$HOST" || return 1
	else
		echo "$SSH_AUTH_SOCK is set but weird -- investigate!"
		sleep 1
		return 1
	fi

	return 0
}

function _screen() {
	export HOST=$(hostname -s)
	_ssh_auth_save || return 1
	\screen $* # call real screen
}
alias screen=_screen

# shell options
test "$BASH_VERSINFO" == 4 && shopt -s globstar # ** is like recursive *

# end on a happy note
true