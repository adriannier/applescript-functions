on run
	
	set Logger to newLogManager("~/Desktop/AppleScript Log Manager Demo.log")
	
	tell Logger
		
		repeat 50 times
			
			logMessage("Hello World " & (random number from 1000 to 9999))
			logError("on run", "Some error message", 1234)
			logWarning("This is an urgent message")
			
		end repeat
		
	end tell
	
end run

on newLogManager(aLogFilePath)
	
	script LogManager
		
		property logFilePath : missing value
		property parentFolderPath : missing value
		property logFileName : missing value
		property maxSize : 1048576
		
		on initWithPath(aPath)
			
			set logFilePath to hfsPath(aPath)
			set parentFolderPath to hfsPathForParent(logFilePath)
			
			set prvDlmt to AppleScript's text item delimiters
			set AppleScript's text item delimiters to ":"
			set logFileName to text item -1 of logFilePath
			set AppleScript's text item delimiters to "."
			set logFileName to text item 1 of logFileName
			set AppleScript's text item delimiters to prvDlmt
			
		end initWithPath
		
		on logMessage(msg)
			
			set ts to timestamp(current date, 1)
			set fullMessage to ts & " " & msg
			_logToFile(fullMessage)
			
		end logMessage
		
		on logError(fnc, msg, num)
			
			set ts to timestamp(current date, 1)
			set fullMessage to ts & " [Error] " & fnc & ": " & msg & " (" & (num as text) & ")"
			_logToFile(fullMessage)
			
		end logError
		
		on logWarning(msg)
			
			set ts to timestamp(current date, 1)
			set fullMessage to ts & " Warning! " & msg
			_logToFile(fullMessage)
			
		end logWarning
		
		on _logToFile(msg)
			
			try
				set fileSize to size of (info for file logFilePath)
			on error eMsg number eNum
				set fileSize to 0
			end try
			
			if fileSize ≥ maxSize then archive()
			
			if writeToFile(msg) is false then
				log msg
			end if
			
		end _logToFile
		
		on archive()
			
			set i to 9
			
			repeat
				
				if i < 0 then exit repeat
				
				set archivePath to parentFolderPath & logFileName & ".log." & (i as text) & ".gz"
				
				try
					get info for file archivePath
					set archiveExists to true
				on error errorMessage
					set archiveExists to false
				end try
				
				if archiveExists then
					
					if i is 9 then
						do shell script "rm -f " & quoted form of (POSIX path of archivePath)
					else
						do shell script "mv " & quoted form of (POSIX path of archivePath) & " " & quoted form of (POSIX path of previousArchivePath)
					end if
					
				end if
				
				set i to i - 1
				
				set previousArchivePath to archivePath
				
			end repeat
			
			do shell script "gzip --suffix '.0.gz' " & quoted form of (POSIX path of logFilePath)
			
		end archive
		
		on timestamp(aDate as date, aFormat)
			
			(*
	
		With big thanks to CK (twitter.com/AppleScriptive) for pointing out «class isot»
		
		Returns the specified date and time as a string
		
		Formats:
		
		1: 1993-10-04 10:02:42 -- For log files
		
		2: 1993-10-04_10-02-42 -- For file names
		
		3: Oct 4 10:02:42 -- For log files (shorter)
		
		4: 19931004T100242 -- RFC3339 / iCalendar local time
		
		5: 19931004100242 -- Digits only
			
	*)
			
			tell aDate as «class isot» as string
				
				tell contents
					
					if aFormat is 1 then
						
						return text 1 thru 10 & " " & text 12 thru -1
						
					else if aFormat is 2 then
						
						return text 1 thru 10 & "_" & text 12 thru 13 & "-" & text 15 thru 16 & "-" & text 18 thru 19
						
					else if aFormat is 3 then
						
						set shortMonths to {"Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"}
						
						return item (month of aDate) of shortMonths & " " & (day of aDate as text) & " " & text 12 thru -1
						
					else if aFormat is 4 then
						
						return text 1 thru 4 & text 6 thru 7 & text 9 thru 13 & text 15 thru 16 & text 18 thru 19
						
					else if aFormat is 5 then
						
						return text 1 thru 4 & text 6 thru 7 & text 9 thru 10 & text 12 thru 13 & text 15 thru 16 & text 18 thru 19
						
					else
						
						error "timestamp(): Unknown time format: " & (aFormat as text) number 1
						
					end if
					
				end tell
				
			end tell
			
		end timestamp
		
		on hfsPath(aPath)
			
			-- Convert path to text
			set aPath to aPath as text
			
			if aPath starts with "'" and aPath ends with "'" then
				-- Remove quotes
				set aPath to text 2 thru -2 of anyPath
			end if
			
			if aPath does not contain "/" and aPath does not contain ":" then
				-- Only filename specified; treat as path relative to current directory
				set aPath to "./" & aPath
			end if
			
			
			if aPath starts with "~" then
				
				-- Expand tilde
				
				-- Get the path to the user’s home folder
				set userPath to POSIX path of (path to home folder)
				
				-- Remove trailing slash
				if userPath ends with "/" then set userPath to (text 1 thru -2 of userPath) as text
				
				if aPath is "~" then
					-- Simply use home folder path
					set aPath to userPath
				else
					-- Concatenate paths
					set aPath to userPath & (text 2 thru -1 of aPath)
				end if
				
			else if aPath starts with "./" then
				
				-- Convert reference to current directory to absolute path
				
				set aPath to text 3 thru -1 of aPath
				
				try
					set myPath to POSIX path of kScriptPath
				on error
					set myPath to POSIX path of (path to me)
				end try
				
				set prvDlmt to text item delimiters
				set text item delimiters to "/"
				set parentDirectoryPath to (text items 1 thru -2 of myPath) & "" as text
				set text item delimiters to prvDlmt
				
				set aPath to parentDirectoryPath & aPath
				
			else if aPath starts with "../" then
				
				-- Convert reference to parent directories to absolute path
				
				try
					set myPath to POSIX path of kScriptPath
				on error
					set myPath to POSIX path of (path to me)
				end try
				
				set prvDlmt to text item delimiters
				set text item delimiters to "../"
				set pathComponents to text items of aPath
				set parentDirectoryCount to (count of pathComponents) - 1
				set text item delimiters to "/"
				set myPathComponents to text items of myPath
				set parentDirectoryPath to (items 1 thru ((count of items of myPathComponents) - parentDirectoryCount) of myPathComponents) & "" as text
				set text item delimiters to prvDlmt
				
				set aPath to parentDirectoryPath & item -1 of pathComponents
				
			end if
			
			if aPath does not contain ":" then
				set aPath to (POSIX file aPath) as text
			end if
			
			return aPath
			
		end hfsPath
		
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
		
		on writeToFile(content)
			
			try
				
				-- Open file
				try
					open for access file logFilePath with write permission
				on error errorMessage number errorNumber
					error "Could not open file with write permission: " & errorMessage number errorNumber
				end try
				
				-- Write to file
				try
					
					-- Determine end of file and data to write
					
					set fileEnd to 0
					
					try
						set fileEnd to (get eof of file logFilePath) + 1
					on error
						set fileEnd to 0
					end try
					
					write (content & (ASCII character 10)) to file logFilePath starting at fileEnd as «class utf8»
					
				on error errorMessage number errorNumber
					
					try
						close access file logFilePath
					end try
					
					error "Error while writing to file: " & errorMessage number errorNumber
					
				end try
				
				
				-- Close file
				try
					close access file logFilePath
				end try
				
				return true
				
			on error errorMessage number errorNumber
				
				set errorMessage to "writeToFile(): " & errorMessage
				error errorMessage number errorNumber
				
				return false
				
			end try
			
		end writeToFile
		
	end script
	
	tell LogManager
		
		initWithPath(aLogFilePath)
		
	end tell
	
	return LogManager
	
end newLogManager