log pathToRelativeResource("test.txt")

log pathToRelativeResource("./test.txt")

log pathToRelativeResource("../../test.txt")

log pathToRelativeResource("~/test.txt")

on pathToRelativeResource(resourcePath)
	
	-- Convert path to text
	set resourcePath to resourcePath as text
	
	if resourcePath starts with "'" and resourcePath ends with "'" then
		-- Remove quotes
		set resourcePath to text 2 thru -2 of anyPath
	end if
	
	if resourcePath does not contain "/" and resourcePath does not contain ":" then
		-- Only filename specified; treat as path relative to current directory
		set resourcePath to "./" & resourcePath
	end if
	
	
	if resourcePath starts with "~" then
		
		-- Expand tilde
		
		-- Get the path to the user’s home folder
		set userPath to POSIX path of (path to home folder)
		
		-- Remove trailing slash
		if userPath ends with "/" then set userPath to (text 1 thru -2 of userPath) as text
		
		if resourcePath is "~" then
			-- Simply use home folder path
			set resourcePath to userPath
		else
			-- Concatenate paths
			set resourcePath to userPath & (text 2 thru -1 of resourcePath)
		end if
		
	else if resourcePath starts with "./" then
		
		-- Convert reference to current directory to absolute path
		
		set resourcePath to text 3 thru -1 of resourcePath
		
		try
			set myPath to POSIX path of kScriptPath
		on error
			set myPath to POSIX path of (path to me)
		end try
		
		set prvDlmt to text item delimiters
		set text item delimiters to "/"
		set parentDirectoryPath to (text items 1 thru -2 of myPath) & "" as text
		set text item delimiters to prvDlmt
		
		set resourcePath to parentDirectoryPath & resourcePath
		
	else if resourcePath starts with "../" then
		
		-- Convert reference to parent directories to absolute path
		
		try
			set myPath to POSIX path of kScriptPath
		on error
			set myPath to POSIX path of (path to me)
		end try
		
		set prvDlmt to text item delimiters
		set text item delimiters to "../"
		set pathComponents to text items of resourcePath
		set parentDirectoryCount to (count of pathComponents) - 1
		set text item delimiters to "/"
		set myPathComponents to text items of myPath
		set parentDirectoryPath to (items 1 thru ((count of items of myPathComponents) - parentDirectoryCount) of myPathComponents) & "" as text
		set text item delimiters to prvDlmt
		
		set resourcePath to parentDirectoryPath & item -1 of pathComponents
		
	end if
	
	if resourcePath does not contain ":" then
		set resourcePath to (POSIX file resourcePath) as text
	end if
	
	return resourcePath
	
end pathToRelativeResource
