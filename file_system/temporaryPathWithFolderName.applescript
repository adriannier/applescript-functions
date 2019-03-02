(*
	Generates a unique path for a file in the current user's temporary items folder. Takes a single argument that can be set to the name of a subfolder or false to create no subfolder.
*)
	
temporaryPathWithFolderName("Test")

on temporaryPathWithFolderName(folderName)
	
	(*
Generates a unique path for a file in the current user's temporary items folder. Takes a single argument that can be set to the name of a subfolder or false to create no subfolder.
*)
	
	-- Generate pseudorandom numbers
	set rand1 to (round (random number from 100 to 999)) as text
	set rand2 to (round (random number from 100 to 999)) as text
	set randomText to rand1 & "-" & rand2
	
	-- Create file name
	set fileName to (("AppleScriptTempFile_" & randomText) as text)
	
	-- Get the path to the parent folder
	set temporaryFolderPath to (path to temporary items folder from user domain) as text
	if folderName is false then
		set parentFolderPath to temporaryFolderPath
	else
		-- Create parent folder if necessary
		set parentFolderPath to temporaryFolderPath & folderName & ":"
		tell application "System Events"
			if (exists folder parentFolderPath) is false then
				make new folder at the end of folders of folder temporaryFolderPath with properties {name:folderName}
			end if
		end tell
	end if
	
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
	
end temporaryPathWithFolderName