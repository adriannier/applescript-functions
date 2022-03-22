createDirectoryAtPath("~/Desktop/Test/A/B/C/")

on createDirectoryAtPath(dirPath)
	
	(*
		Creates a folder at the specified path (HFS-style or POSIX)
		with intermediate directories being created when necessary. 
	*)
	
	try
		
		-- Expand tilde in filePath
		if dirPath starts with "~" then
			
			-- Get the path to the user’s home folder
			set userPath to POSIX path of (path to home folder)
			
			-- Remove trailing slash
			if userPath ends with "/" then set userPath to text 1 thru -2 of userPath as text
			if dirPath is "~" then
				set dirPath to userPath
			else
				set dirPath to userPath & text 2 thru -1 of dirPath as text
			end if
			
		end if
		
		-- Convert to HFS style path if necessary
		if dirPath does not contain ":" then set dirPath to (POSIX file dirPath) as text
		if dirPath does not end with ":" then set dirPath to dirPath & ":"
		
		-- Exit early if directory already exists
		tell application "System Events" to if (exists folder dirPath) then return true
		
		-- Break path into components
		set prvDlmt to text item delimiters
		set text item delimiters to ":"
		set pathComponents to text items of dirPath
		set text item delimiters to prvDlmt
		
		-- Check directories at each level
		set parentDirectoryPath to (item 1 of pathComponents) & ":"
		
		repeat with i from 2 to ((count of pathComponents) - 1)
			
			-- Get the name and path for this directory	
			set currentName to item i of pathComponents
			set currentPath to parentDirectoryPath & currentName & ":"
			
			-- Create directory if necessary
			tell application "System Events"
				if (exists folder currentPath) is false then
					make new folder at end of folders of folder parentDirectoryPath with properties {name:currentName}
				end if
				
			end tell
			
			-- Save this directory as the next parent directory
			set parentDirectoryPath to currentPath
			
		end repeat
		
		return true
		
	on error eMsg number eNum
		
		return false
		
	end try
	
end createDirectoryAtPath