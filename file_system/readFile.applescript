(*
Reads contents of a file at the specified path. Second parameter is content type [e.g. text, record, Çclass utf8È, etc.]
*)

log readFile("/etc/hosts", false)

log readFile("~/Library/Preferences/com.apple.finder.plist", text)

on readFile(filePath, contentClass)
	
	try
		
		-- Convert to text
		set filePath to filePath as text
		
		-- Remove quotes
		if filePath starts with "'" and filePath ends with "'" then
			set filePath to text 2 thru -2 of filePath
		end if
		
		-- Expand tilde
		if filePath starts with "~" then
			
			-- Get the path to the userÕs home folder
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
		
		if contentClass is missing value or contentClass is in {false, 0, "", "utf8", "utf-8"} then
			-- Set default content class
			set contentClass to Çclass utf8È
		end if
		
		-- Check if the file exists
		tell application "System Events" to if (exists file filePath) is false then error "File not found."
		
		-- Open file for reading
		try
			open for access file filePath
		on error errorMessage number errorNumber
			error "Could not open file: " & errorMessage number errorNumber
		end try
		
		-- Read
		try
			set fileContents to read file filePath as contentClass
		on error errorMessage number errorNumber
			try
				close access file filePath
			end try
			error "Error while trying to read file: " & errorMessage number errorNumber
		end try
		
		-- Close
		try
			close access file filePath
		end try
		
		return fileContents
		
	on error errorMessage number errorNumber
		
		set errorMessage to "readFile(\"" & filePath & "\", " & (contentClass as text) & "): " & Â
			errorMessage
		error errorMessage number errorNumber
		
	end try
	
end readFile