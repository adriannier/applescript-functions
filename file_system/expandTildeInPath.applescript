(*
Expands a possible tilde in the specified path.
*)

expandTildeInPath("~/Desktop/")

on expandTildeInPath(aPath)
	
	-- Exit early, if the posix path does not start with a tilde character	
	if aPath does not start with "~" then
		
		set filePath to aPath
		
	else
		
		-- Get the path to the user’s home folder
		set homeFolderPath to POSIX path of (path to home folder)
		
		if homeFolderPath ends with "/" then
			-- Remove trailing slash
			set homeFolderPath to text 1 thru -2 of homeFolderPath as text
		end if
		
		if aPath is "~" then
			set filePath to homeFolderPath
		else
			set filePath to homeFolderPath & text 2 thru -1 of aPath as text
		end if
		
	end if
	
	return filePath
	
end expandTildeInPath