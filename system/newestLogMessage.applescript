(*
	Filters the contents of a given log file with grep and returns the last occurrence of the result. If no match is found in the specified log file, archived versions, if any, are searched as well.
*)

log newestLogMessage("syslogd.*ASL Sender Statistics", "/var/log/system.log")

log newestLogMessage("backupd.*backup failed", "/var/log/system.log")

log newestLogMessage("backupd.*backup completed", "/var/log/system.log")

log newestLogMessage("kernel.*system.*wake", "/var/log/system.log")

on newestLogMessage(aPattern, logFilePath)
	
	-- Convert path to text
	set logFilePath to logFilePath as text
	
	-- Remove quotes
	if logFilePath starts with "'" and logFilePath ends with "'" then
		set logFilePath to text 2 thru -2 of logFilePath
	end if
	
	-- Expand tilde
	if logFilePath starts with "~" then
		
		-- Get the path to the user’s home folder
		set userPath to POSIX path of (path to home folder)
		
		-- Remove trailing slash
		if userPath ends with "/" then set userPath to text 1 thru -2 of userPath as text
		if logFilePath is "~" then
			set logFilePath to userPath
		else
			set logFilePath to userPath & text 2 thru -1 of logFilePath
		end if
		
	end if
	
	-- Convert to POSIX path if necessary
	if logFilePath contains ":" then set logFilePath to POSIX path of logFilePath
	
	set logLine to false
	
	try
		-- Return the last occurrence of the matching log message
		set logLine to last paragraph of (do shell script "grep -i " & quoted form of aPattern & " " & quoted form of logFilePath)
		
	on error eMsg number eNum
		
		try
			-- Check for bz2 archived log files
			set logFiles to (paragraphs of (do shell script "ls " & quoted form of logFilePath & ".*.bz2"))
			
		on error eMsg number eNum
			
			try
				-- Check for gz archived log files
				set logFiles to (paragraphs of (do shell script "ls " & quoted form of logFilePath & ".*.gz"))
				
			on error eMsg number eNum
				
				set logFiles to {}
			end try
			
		end try
		
		-- Try to find a matching message in the archived log files
		repeat with logFile in logFiles
			
			set logFileQPP to quoted form of (logFile as text)
			
			try
				
				if logFile ends with ".gz" then
					set logLine to (last paragraph of (do shell script "gzcat " & logFileQPP & " | grep -i " & quoted form of aPattern))
				else
					set logLine to (last paragraph of (do shell script "bzcat " & logFileQPP & " | grep -i " & quoted form of aPattern))
				end if
				
				exit repeat
				
			end try
			
		end repeat
		
	end try
	
	return logLine
	
end newestLogMessage