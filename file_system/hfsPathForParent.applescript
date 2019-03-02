(*
	Returns the HFS path of the parent for the specified path
*)

hfsPathForParent(path to me as text)

on hfsPathForParent(anyPath)
	
	-- Convert path to text
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
	
	-- For simplification make sure every path ends with a colon
	if anyPath does not end with ":" then set anyPath to anyPath & ":"
	
	-- Get rid of the last path component
	set prvDlmt to text item delimiters
	set text item delimiters to ":"
	set parentPath to (text items 1 thru -3 of anyPath as text) & ":"
	set text item delimiters to prvDlmt
	
	return parentPath
	
end hfsPathForParent