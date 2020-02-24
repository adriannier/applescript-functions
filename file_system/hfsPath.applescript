(*
	Converts any file reference even relative ones to a HFS-style path string.
*)

log hfsPath("test.txt")

log hfsPath("./test.txt")

log hfsPath("../../test.txt")

log hfsPath("~/test.txt")

log hfsPath("/Library")

on hfsPath(aPath)
	
	-- Convert path to text
	set aPath to aPath as text
	
	if aPath starts with "'" and aPath ends with "'" then
		-- Remove quotes
		set aPath to text 2 thru -2 of anyPath
	end if
	
	if aPath does not contain "/" and aPath does not contain ":" then
		-- Only filename specified; treat as path relative to current directory
		set aPath to "./" & aPath
	end if
	
	
	if aPath starts with "~" then
		
		-- Expand tilde
		
		-- Get the path to the user’s home folder
		set userPath to POSIX path of (path to home folder)
		
		-- Remove trailing slash
		if userPath ends with "/" then set userPath to (text 1 thru -2 of userPath) as text
		
		if aPath is "~" then
			-- Simply use home folder path
			set aPath to userPath
		else
			-- Concatenate paths
			set aPath to userPath & (text 2 thru -1 of aPath)
		end if
		
	else if aPath starts with "./" then
		
		-- Convert reference to current directory to absolute path
		
		set aPath to text 3 thru -1 of aPath
		
		try
			set myPath to POSIX path of kScriptPath
		on error
			set myPath to POSIX path of (path to me)
		end try
		
		set prvDlmt to text item delimiters
		set text item delimiters to "/"
		set parentDirectoryPath to (text items 1 thru -2 of myPath) & "" as text
		set text item delimiters to prvDlmt
		
		set aPath to parentDirectoryPath & aPath
		
	else if aPath starts with "../" then
		
		-- Convert reference to parent directories to absolute path
		
		try
			set myPath to POSIX path of kScriptPath
		on error
			set myPath to POSIX path of (path to me)
		end try
		
		set prvDlmt to text item delimiters
		set text item delimiters to "../"
		set pathComponents to text items of aPath
		set parentDirectoryCount to (count of pathComponents) - 1
		set text item delimiters to "/"
		set myPathComponents to text items of myPath
		set parentDirectoryPath to (items 1 thru ((count of items of myPathComponents) - parentDirectoryCount) of myPathComponents) & "" as text
		set text item delimiters to prvDlmt
		
		set aPath to parentDirectoryPath & item -1 of pathComponents
		
	end if
	
	if aPath does not contain ":" then
		set aPath to (POSIX file aPath) as text
	end if
	
	return aPath
	
end hfsPath