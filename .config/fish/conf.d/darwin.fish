# macOS-specific configuration
test (uname) = Darwin; or exit 0

if status is-interactive
	eval (/opt/homebrew/bin/brew shellenv)

	abbr --add locate 'mdfind -name'
	abbr --add fin 'mdfind -onlyin . -name'
end

