(*
	Sets the desktop picture.
*)

setDesktopPicture("/Library/Desktop Pictures/Solid Colors/Black.png")

on setDesktopPicture(filePath)
	
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
	
	-- Check wether the image file exists
	tell application "System Events"
		if (exists file filePath) is false then error "No file exists at path \"" & filePath & "\""
	end tell
	
	-- Set the desktop picture
	tell application "System Events"
		set picture of desktops to alias filePath
	end tell
	
end setDesktopPicture