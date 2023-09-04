function path_prepend -a dir
	if not test -d $dir
		return 1
	end
	if not contains $dir $PATH
		set PATH $dir $PATH
	end
end

function path_append -a dir
	if not test -d $dir
		return 1
	end
	if not contains $dir $PATH
		set PATH $PATH $dir
	end
end

set -g OS (uname)
set -g ARCH (uname -m)
set -gx PAGER less

for editor in hx vim vi
	if hash $editor 2>/dev/null
		set -gx EDITOR $editor
		break
	end
end

set -gx LSCOLORS "CxfxcxdxBxegedabagacad"
set -gx FZF_DEFAULT_COMMAND fd
