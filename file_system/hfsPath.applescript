(*
Converts any file reference to a HFS-style path string.
*)

hfsPath("~/")

on hfsPath(anyPath)
	
	-- Convert to text
	set anyPath to anyPath as text
	
	-- Remove quotes
	if anyPath starts with "'" and anyPath ends with "'" then
		set anyPath to text 2 thru -2 of anyPath
	end if
	
	-- Expand tilde
	if anyPath starts with "~" then
		
		-- Get the path to the user’s home folder
		set userPath to POSIX path of (path to home folder)
		
		-- Remove trailing slash
		if userPath ends with "/" then set userPath to text 1 thru -2 of userPath as text
		if anyPath is "~" then
			set anyPath to userPath
		else
			set anyPath to userPath & text 2 thru -1 of anyPath
		end if
		
	end if
	
	-- Convert to HFS style path if necessary
	if anyPath does not contain ":" then set anyPath to (POSIX file anyPath) as text
	
	return anyPath
	
end hfsPath