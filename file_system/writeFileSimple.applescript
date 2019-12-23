(*

Writes content to a file. Takes three arguments. The path, the content and the content type [e.g. text, list, «class utf8», etc.]. Returns true, if the operation was successful, otherwise an error is raised.

Options are:

contentType (class)
- Class name for the data type to write the content as [e.g. text, list, etc.].
 
*)

simpleWriteFile("Hello World", "~/Desktop/Demo 1.txt", «class utf8»)

on simpleWriteFile(content, filePath, contentType)
	
	try
		
		-- Convert path to text
		set filePath to filePath as text
		
		-- Remove quotes
		if filePath starts with "'" and filePath ends with "'" then
			set filePath to text 2 thru -2 of filePath
		end if
		
		-- Expand tilde
		if filePath starts with "~" then
			
			-- Get the path to the user’s home folder
			set userPath to POSIX path of (path to home folder)
			
			-- Remove trailing slash
			if userPath ends with "/" then set userPath to text 1 thru -2 of userPath as text
			if filePath is "~" then
				set filePath to userPath
			else
				set filePath to userPath & text 2 thru -1 of filePath
			end if
			
		end if
		
		-- Convert to HFS style path if necessary
		if filePath does not contain ":" then set filePath to (POSIX file filePath) as text
		
		-- Set content type if not already set
		if contentType is false then
			set contentType to class of content
		end if
		
		-- Open file
		try
			open for access file filePath with write permission
		on error errorMessage number errorNumber
			error "Could not open file with write permission: " & errorMessage number errorNumber
		end try
		
		-- Write to file
		try
			
			write content to file filePath starting at 0 as contentType
			
		on error errorMessage number errorNumber
		
			try
				close access file filePath
			end try
			
			error "Error while writing to file: " & errorMessage number errorNumber
			
		end try
		
		
		-- Close file
		try
			close access file filePath
		end try
		
		
		return true
		
	on error errorMessage number errorNumber
		
		set errorMessage to "simpleWriteFile(): " & errorMessage
		error errorMessage number errorNumber
		
		return false
		
	end try
	
	
end simpleWriteFile