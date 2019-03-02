(*

Writes content to a file. Takes three arguments. The path, the content and a record with options. Returns true, if the operation was successful, otherwise an error is raised.

Options are:

overrideType (class)
- Class name for the data type to write the content as [e.g. text, list, etc.].
 
atomically (boolean) 
- Write atomically. First writes data to temporary file, then replaces original file with temporary file. Default: false

appendNewContent (boolean)
- Append the content to the file. Default: false

appendWithNewLine (boolean)
- Appends the content with a new line character. Ignored if appendNewContent is set to false. Default: false

newlineCharacter (text)
- Used as newline character. Default: ASCII character 10

*)


writeFile("Hello World", "~/Desktop/Demo 1.txt", false)

writeFile("Hello World", "~/Desktop/Demo 2.txt", {atomically:true})

writeFile("Hello World " & random number from 1000 to 9999, "~/Desktop/Demo 3.log", {appendNewContent:true, appendWithNewline:true})

on writeFile(content, filePath, options)
	
	try
		
		-- Convert path to text
		set filePath to filePath as text
		
		-- Remove quotes
		if filePath starts with "'" and filePath ends with "'" then
			set filePath to text 2 thru -2 of filePath
		end if
		
		-- Expand tilde
		if filePath starts with "~" then
			
			-- Get the path to the user�s home folder
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
		
		-- Set default options
		set overrideType to false
		set atomically to false
		set appendNewContent to false
		set appendWithNewline to false
		set newlineCharacter to ASCII character 10
		
		-- Get specified options
		try
			set overrideType to (overrideType of options)
		end try
		if overrideType is false then set overrideType to class of content
		try
			set atomically to (atomically of options)
		end try
		try
			set appendNewContent to (appendNewContent of options)
		end try
		try
			set appendWithNewline to (appendWithNewline of options)
		end try
		try
			set newlineCharacter to (newlineCharacter of options)
		end try
		
		
		set originalContent to "<-FileHadNoContent->"
		
		if atomically is false then
			
			set tempPath to filePath
			
		else
			
			(***** ATOMIC WRITING *****)
			
			-- Determine file name and directory
			-- Create file path for atomical writing  
			set prvDlmt to text item delimiters
			try
				set text item delimiters to ":"
				set fileName to text item -1 of filePath
				set parentFolderPath to (text items 1 thru -2 of filePath as text) & ":"
				set text item delimiters to prvDlmt
			on error errorMessage number errorNumber
				set text item delimiters to prvDlmt
				error "Error while determining file name and directory: " & errorMessage number errorNumber
			end try
			
			-- Initializes variables to split file name into base and suffix
			set baseName to fileName
			set suffix to ""
			
			if fileName contains "." then
				
				-- Set delimiters
				set prvDlmt to text item delimiters
				set text item delimiters to "."
				
				-- Get rid of everything 
				set baseName to (text items 1 thru -2 of fileName) as text
				
				-- Get the last text item; that should be the suffix
				set suffix to text item -1 of fileName
				
				-- Restore delimiters
				set text item delimiters to prvDlmt
				
				if suffix contains " " or baseName is "" or suffix is "" then
					set baseName to fileName
					set suffix to ""
				end if
				
			end if
			
			-- Create a unique temporary file path
			set i to 1
			repeat
				set tempPath to parentFolderPath & baseName & "_" & (i as text) & "." & suffix
				tell application "System Events" to if (exists file tempPath) is false then exit repeat
				set i to i + 1
			end repeat
			
			-- Read original file content if necessary
			if appendNewContent then
				
				tell application "System Events" to set fileExists to (exists file filePath)
				
				if fileExists then
					
					try
						open for access file filePath
					on error errorMessage number errorNumber
						error "Could not open file for reading: " & errorMessage number errorNumber
					end try
					
					try
						set originalContent to read file filePath as overrideType
					on error errorMessage number errorNumber
						try
							close access file filePath
						end try
						error "Could not read original file: " & errorMessage number errorNumber
					end try
					
					try
						close access file filePath
					end try
					
					
				end if
				
			end if
			
		end if
		
		-- Open file
		try
			open for access file tempPath with write permission
		on error errorMessage number errorNumber
			error "Could not open file with write permission: " & errorMessage number errorNumber
		end try
		
		-- Write to file
		try
			
			-- Determine end of file and data to write
			if appendNewContent is false then
				
				set eof of file tempPath to 0
				set fileEnd to 0
				set writeData to content
				
			else
				
				try
					set fileEnd to (get eof of file tempPath) + 1
				on error
					set fileEnd to 0
				end try
				
				if originalContent is not "<-FileHadNoContent->" then
					
					if appendWithNewline then
						set writeData to originalContent & content & newlineCharacter
					else
						set writeData to originalContent & content
					end if
					
				else
					
					if appendWithNewline then
						set writeData to content & newlineCharacter
					else
						set writeData to content
					end if
					
				end if
				
			end if
			
			
			write writeData to file tempPath starting at fileEnd as overrideType
			
		on error errorMessage number errorNumber
			try
				close access file tempPath
			end try
			error "Error while writing to file: " & errorMessage number errorNumber
		end try
		
		
		-- Close file
		try
			close access file tempPath
		end try
		
		
		-- Option: Atomically - Delete original file and rename backup file
		
		if tempPath is not filePath then
			
			
			try
				tell application "System Events"
					
					if (exists file filePath) then
						
						-- Try to delete the original file if it exists					
						try
							delete file filePath
						on error
							do shell script "rm -f " & quoted form of (POSIX path of filePath)
						end try
						
					end if
					
					-- Rename backup file
					try
						set name of file tempPath to fileName
					on error
						try
							do shell script "mv " & quoted form of (POSIX path of tempPath) & " " & quoted form of (POSIX path of filePath)
						on error errorMessage number errorNumber
							error "Error wile renaming backup file: " & errorMessage number errorNumber
						end try
						
					end try
				end tell
			end try
			
			
		end if
		
		
		return true
		
	on error errorMessage number errorNumber
		
		try
			if tempPath is not filePath then
				tell application "System Events" to delete file tempPath
			end if
		end try
		
		set errorMessage to "writeFile(): " & errorMessage
		error errorMessage number errorNumber
		
		return false
	end try
	
	
end writeFile