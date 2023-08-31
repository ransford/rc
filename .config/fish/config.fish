if status is-interactive
    # Commands to run in interactive sessions can go here
    uptime
end

# local overrides
if test -f $__fish_config_dir/local.fish
	source $__fish_config_dir/local.fish
end
