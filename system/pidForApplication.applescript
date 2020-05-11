log pidForApplication("Finder", "/System/Library/CoreServices/Finder.app")

log pidForApplication("System Events", "/System/Library/CoreServices/System Events.app")

log pidForApplication("FileMaker", "/Users/adrian/Applications/FileMaker Pro 18 Advanced/FileMaker Pro 18 Advanced.app")

on pidForApplication(appNameFilter, appPath)
	
	-- Convert path to text
	set appPath to appPath as text
	
	if appPath starts with "'" and appPath ends with "'" then
		-- Remove quotes
		set appPath to text 2 thru -2 of anyPath
	end if
	
	if appPath does not contain "/" and appPath does not contain ":" then
		-- Only filename specified; treat as path relative to current directory
		set appPath to "./" & appPath
	end if
	
	
	if appPath starts with "~" then
		
		-- Expand tilde
		
		-- Get the path to the user’s home folder
		set userPath to POSIX path of (path to home folder)
		
		-- Remove trailing slash
		if userPath ends with "/" then set userPath to (text 1 thru -2 of userPath) as text
		
		if appPath is "~" then
			-- Simply use home folder path
			set appPath to userPath
		else
			-- Concatenate paths
			set appPath to userPath & (text 2 thru -1 of appPath)
		end if
		
	else if appPath starts with "./" then
		
		-- Convert reference to current directory to absolute path
		
		set appPath to text 3 thru -1 of appPath
		
		try
			set myPath to POSIX path of kScriptPath
		on error
			set myPath to POSIX path of (path to me)
		end try
		
		set prvDlmt to text item delimiters
		set text item delimiters to "/"
		set parentDirectoryPath to (text items 1 thru -2 of myPath) & "" as text
		set text item delimiters to prvDlmt
		
		set appPath to parentDirectoryPath & appPath
		
	else if appPath starts with "../" then
		
		-- Convert reference to parent directories to absolute path
		
		try
			set myPath to POSIX path of kScriptPath
		on error
			set myPath to POSIX path of (path to me)
		end try
		
		set prvDlmt to text item delimiters
		set text item delimiters to "../"
		set pathComponents to text items of appPath
		set parentDirectoryCount to (count of pathComponents) - 1
		set text item delimiters to "/"
		set myPathComponents to text items of myPath
		set parentDirectoryPath to (items 1 thru ((count of items of myPathComponents) - parentDirectoryCount) of myPathComponents) & "" as text
		set text item delimiters to prvDlmt
		
		set appPath to parentDirectoryPath & item -1 of pathComponents
		
	end if
	
	if appPath does not contain ":" then
		set appPath to (POSIX file appPath) as text
	end if
	
	if appPath does not end with ":" then
		set appPath to appPath & ":"
	end if
	
	tell application "System Events"
		
		set foundProcesses to processes whose name contains appNameFilter
		
		repeat with thisProcess in foundProcesses
			
			-- Get the path to the process
			try
				
				set thisPath to (file of thisProcess) as text
				
			on error eMsg number eNum
				
				-- Try to get path from error message
				set quoteOffset to offset of "\"" in eMsg
				if quoteOffset is 0 then
					error eMsg number eNum
				else
					set eMsg to text (quoteOffset + 1) thru -1 of eMsg
					set quoteOffset to offset of "\"" in eMsg
					if quoteOffset is 0 then
						error eMsg number eNum
					else
						set thisPath to text 1 thru (quoteOffset - 1) of eMsg
					end if
				end if
				
			end try
			
			if thisPath does not end with ":" then
				set thisPath to thisPath & ":"
			end if
			
			if thisPath is appPath then
				return unix id of thisProcess
			end if
			
		end repeat
		
	end tell
	
	return false
	
end pidForApplication