(*
Examines two posix paths and returns the relative path that leads from the first path to the second.
*)

relativePosixPath("/Library/Desktop Pictures/", "/Library/Application Support/")

on relativePosixPath(origin, destination)
	
	-- Break paths into components
	set prvDlmt to text item delimiters
	set text item delimiters to "/"
	set originPathComponents to text items of origin
	set destinationPathComponents to text items of destination
	set text item delimiters to prvDlmt
	
	-- Compare components of both paths and determine at which point they differ
	repeat with i from 1 to count of originPathComponents
		try
			if item i of originPathComponents is not item i of destinationPathComponents then exit repeat
		on error
			exit repeat
		end try
	end repeat
	
	-- If necessary, create a path prefix to go up the hierarchy
	set pathPrefix to ""
	repeat ((count of originPathComponents) - i) times
		set pathPrefix to pathPrefix & "../"
	end repeat
	
	if i > (count of destinationPathComponents) then
		-- Make sure we’re not out of bounds
		set i to count of destinationPathComponents
	end if
	
	-- Combine components
	set prvDlmt to text item delimiters
	set text item delimiters to "/"
	set relativePath to items i thru -1 of destinationPathComponents as text
	set text item delimiters to prvDlmt
	
	-- Return relative path	
	return pathPrefix & relativePath
	
end relativePosixPath