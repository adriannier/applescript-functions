(*
	Generates a unique path for a file with the specified name and suffix in a folder located at the specified path.
*)

uniqueFileHFSPath(path to home folder, "test", "txt")

on uniqueFileHFSPath(parentFolderPath, fileName, suffix)
	
	(*
	Generates a unique path for a file with the specified name and suffix in a folder located at the specified path.
*)
	
	-- Convert to text
	set parentFolderPath to parentFolderPath as text
	
	-- Remove quotes
	if parentFolderPath starts with "'" and parentFolderPath ends with "'" then
		set parentFolderPath to text 2 thru -2 of parentFolderPath
	end if
	
	-- Expand tilde
	if parentFolderPath starts with "~" then
		
		-- Get the path to the user’s home folder
		set userPath to POSIX path of (path to home folder)
		
		-- Remove trailing slash
		if userPath ends with "/" then set userPath to text 1 thru -2 of userPath as text
		if parentFolderPath is "~" then
			set parentFolderPath to userPath
		else
			set parentFolderPath to userPath & text 2 thru -1 of parentFolderPath
		end if
		
	end if
	
	-- Convert to HFS style path if necessary
	if parentFolderPath does not contain ":" then set parentFolderPath to (POSIX file parentFolderPath) as text
	
	-- Add trailing colon
	if parentFolderPath does not end with ":" then set parentFolderPath to parentFolderPath & ":"
	
	-- Make sure the file does not exist
	set loopNumber to 1
	
	repeat
		
		if loopNumber is 1 then
			set tempFilePath to parentFolderPath & fileName & "." & suffix
		else
			set tempFilePath to parentFolderPath & fileName & " " & (loopNumber as text) & "." & suffix
		end if
		
		tell application "System Events" to if (exists file tempFilePath) is false then exit repeat
		set loopNumber to loopNumber + 1
		
	end repeat
	
	return tempFilePath
	
end uniqueFilePath