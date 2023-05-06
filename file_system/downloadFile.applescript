downloadFile("https://raw.githubusercontent.com/adriannier/applescript-functions/release/README.md", "~/Desktop/AppleScript Functions Readme.md")

on downloadFile(remoteURL, localPath)
	
	(* Downloads a file from the specified URL to the local path. *)
	
	-- Convert path to text
	set localPath to localPath as text
	
	if localPath starts with "'" and localPath ends with "'" then
		-- Remove quotes
		set localPath to text 2 thru -2 of anyPath
	end if
	
	if localPath does not contain "/" and localPath does not contain ":" then
		-- Only filename specified; treat as path relative to current directory
		set localPath to "./" & localPath
	end if
	
	if localPath starts with "~" then
		
		-- Expand tilde
		
		-- Get the path to the user’s home folder
		set userPath to POSIX path of (path to home folder)
		
		-- Remove trailing slash
		if userPath ends with "/" then set userPath to (text 1 thru -2 of userPath) as text
		
		if localPath is "~" then
			-- Simply use home folder path
			set localPath to userPath
		else
			-- Concatenate paths
			set localPath to userPath & (text 2 thru -1 of localPath)
		end if
		
	else if localPath starts with "./" then
		
		-- Convert reference to current directory to absolute path
		
		set localPath to text 3 thru -1 of localPath
		
		try
			set myPath to POSIX path of klocalPath
		on error
			set myPath to POSIX path of (path to me)
		end try
		
		set prvDlmt to text item delimiters
		set text item delimiters to "/"
		set parentDirectoryPath to (text items 1 thru -2 of myPath) & "" as text
		set text item delimiters to prvDlmt
		
		set localPath to parentDirectoryPath & localPath
		
	else if localPath starts with "../" then
		
		-- Convert reference to parent directories to absolute path
		
		try
			set myPath to POSIX path of klocalPath
		on error
			set myPath to POSIX path of (path to me)
		end try
		
		set prvDlmt to text item delimiters
		set text item delimiters to "../"
		set pathComponents to text items of localPath
		set parentDirectoryCount to (count of pathComponents)
		set text item delimiters to "/"
		set myPathComponents to text items of myPath
		set parentDirectoryPath to (items 1 thru ((count of items of myPathComponents) - parentDirectoryCount) of myPathComponents) & "" as text
		set text item delimiters to prvDlmt
		
		set localPath to parentDirectoryPath & item -1 of pathComponents
		
	end if
	
	if localPath does not contain ":" then
		set localPath to (POSIX file localPath) as text
	end if
	
	
	-- Add cache buster to URL
	set cacheBuster to random number from 1 to 99999999
	set cacheBustingURL to remoteURL & "?cacheBuster" & (cacheBuster as text) & "=" & (cacheBuster as text)
	
	try
		set userAgent to "Mozilla/5.0 (Macintosh; Intel Mac OS X 13_3_1) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/16.4 Safari/605.1.15"
		do shell script "curl --ssl-reqd --fail --no-progress-meter --connect-timeout 20 --retry 3 --retry-max-time 30 --location --user-agent " & quoted form of userAgent & " " & quoted form of cacheBustingURL & " -o " & quoted form of (POSIX path of localPath)
	on error eMsg number eNum
		error "downloadFile(): There was an error downloading " & remoteURL & " to " & localPath & ": " & eMsg number eNum
	end try
	
	return localPath
	
end downloadFile