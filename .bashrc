# .bashrc -- interactive non-login shells
# should produce NO console output!

# bail out if shell is not interactive
[ -z "$PS1" ] && return

# if this is NOT a login shell, source .profile to get environment if we don't
# already have it (i.e., if we're not already in a shell that probably already
# sourced .profile)
shopt -q login_shell || source "$HOME/.profile"

_ssh_auth_save() {
	[[ -n "$SSH_AUTH_SOCK" ]] || return 0

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

_screen() {
	export HOST=$(hostname -s)
	_ssh_auth_save
	\screen $* # call real screen
}
alias screen=_screen

_git_prompt() {
	local ref="$(command git symbolic-ref HEAD 2>/dev/null)"
	[ -n "$ref" ] && echo $'\e[1;33m'":${ref#refs/heads/}"
}

_exit_code() {
	[ "$PIPESTATUS" -ne 0 ] && echo $'\e[1;31m'"$?!"
}

# shell options
[ "$BASH_VERSINFO" -eq 4 ] && shopt -s globstar # ** is like recursive *

# prompt
PS1='\[\e]0;\h:\W\a\]$(_exit_code)\[\e[42;30m\]\A\[\e[0m\] \h:\[\e[4;34m\]\W\[\e[0m\]$(_git_prompt)\[\e[0;36m\]\$\[\e[0m\] '
#    ^xterm title    ^exit code   ^time                   ^host:~                   ^git          ^$

uptime

# end on a happy note
true
