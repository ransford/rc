set -g OS (uname)
set -g ARCH (uname -m)
set -gx PAGER less
set -gx EDITOR vim

set -gx LSCOLORS "CxfxcxdxBxegedabagacad"
set -gx FZF_DEFAULT_COMMAND fd

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
