(*
Returns a tilde-based POSIX path if the specified path is part of the current user’s home folder.
*)

posixPathWithTilde(path to me)

on posixPathWithTilde(anyPath)
	
	set anyPath to anyPath as text
	
	if anyPath contains ":" then
		-- Convert HFS path to POSIX path
		set anyPath to POSIX path of anyPath
	end if
	
	set homePath to POSIX path of (path to home folder)
	
	if anyPath starts with homePath then
		return "~" & text (length of homePath) thru -1 of anyPath
	else
		return anyPath
	end if
	
end homePosixPath