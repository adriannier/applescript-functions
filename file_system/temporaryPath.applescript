temporaryPath()

on temporaryPath()

	(* Generates a unique path for a file in the current user's temporary items folder. *)
	
	-- Generate pseudorandom numbers
	set rand1 to (round (random number from 100 to 999)) as text
	set rand2 to (round (random number from 100 to 999)) as text
	set randomText to rand1 & "-" & rand2
	
	-- Create file name
	set fileName to (("AppleScriptTempFile_" & randomText) as text)
	
	-- Get the path to the parent folder
	set parentFolderPath to (path to temporary items folder from user domain) as text
	
	-- Make sure the file does not exist
	set rNumber to 1
	
	repeat
		if rNumber is 1 then
			set tempFilePath to parentFolderPath & fileName
		else
			set tempFilePath to parentFolderPath & fileName & "_" & (rNumber as text)
		end if
		
		tell application "System Events" to if (exists file tempFilePath) is false then exit repeat
		set rNumber to rNumber + 1
	end repeat
	
	return tempFilePath
	
end temporaryPath