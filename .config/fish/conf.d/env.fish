set -g OS (uname)
set -g ARCH (uname -m)
set -gx PAGER less

for editor in nvim vim vi
	if which $editor &>/dev/null
		set -gx EDITOR $editor
		break
	end
end

set -gx LSCOLORS "CxfxcxdxBxegedabagacad"
set -gx FZF_DEFAULT_COMMAND fd
