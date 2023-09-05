# macOS-specific configuration
test (uname) = Darwin; or exit 0

if status is-interactive
	/opt/homebrew/bin/brew shellenv | source

	abbr --add locate 'mdfind -name'
	abbr --add fin 'mdfind -onlyin . -name'
end

