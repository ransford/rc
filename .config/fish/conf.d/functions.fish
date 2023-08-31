if test (uname) = Darwin
	function f. -d "Open current directory in Finder"
		open -a Finder $PWD
	end
end
