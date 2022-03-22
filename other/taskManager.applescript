(* 

TEST 1
Run a simple task that outputs text

*)

set task to newTask("test 1", "printf " & quoted form of "hello world")
if task's startAndWait() is not "hello world" then error "Test 1 failed"

(*

TEST 2
Run a lengthy task until:
A. Output is of desired length OR
B. Task no longer runs OR
C. User canceled

*)

set task to newTask("test 2", "while :; do printf '1'; sleep 1; done")
task's start()
repeat
	
	-- Wait until output has a minimum length of 3 characters
	
	try
		
		if not task's isRunning() then exit repeat
		
		set output to task's standardOut()
		
		if length of output ≥ 3 then exit repeat
		
		delay 0.1
		
	on error eMsg number eNum
		-- Handle user cancellation gracefully; clean up task
		if eNum = -128 then task's userCanceled(false)
	end try
	
end repeat

if task's standardOut() is not "111" then error "Test 2 failed"

-- Clean up if loop exited cleanly (reached minimum of 3 characters)
task's cleanup()

(*

TEST 3
Check if chained of commands are handled properly (positive case)

*)

set task to newTask("test 3", "test -d /Library && printf " & quoted form of "Directory exists" & " || printf " & quoted form of "Directory missing")
if task's startAndWait() is not "Directory exists" then error "Test 3 failed"

(*

TEST 4
Check if chained of commands are handled properly (negative case)

*)

set task to newTask("test 4", "test -d /F4738565-C234-4570-BEDE-44ED77A85B48 && printf " & quoted form of "Directory exists" & " || printf " & quoted form of "Directory missing")
if task's startAndWait() is not "Directory missing" then error "Test 4 failed"

(* 

TEST 5
Check if error is raised

*)

set task to newTask("test 5", "test -d /F4738565-C234-4570-BEDE-44ED77A85B48")
try
	task's startAndWait()
	error "Test 5 failed because no error was raised"
on error eMsg number eNum
	if eNum is not 1 then error "Test 5 failed due to wrong error number"
end try

(* 

TEST 6
Check if error is silenced

*)

set task to newTask("test 6", "test -d /F4738565-C234-4570-BEDE-44ED77A85B48")
task's setSilenceError(true)
try
	task's startAndWait()
on error eMsg number eNum
	error "Test 6 failed because error was not silenced"
end try

(* 

TEST 7
Check if timeout raises error

*)

set task to newTask("test 7", "sleep 10")
try
	task's startAndWaitSeconds(2)
	error "Test 7 failed because timeout was not reported"
on error eMsg number eNum
	if eNum is not -2 then error "Test 7 failed because wrong error number was returned"
end try

(* 

TEST 8
Check if timeout error is silenced

*)

set task to newTask("test 8", "sleep 10")
task's setSilenceError(true)
try
	task's startAndWaitSeconds(2)
	if task's exitCode() is not -2 then error "Test 8 failed because exit code is not -2"
on error eMsg number eNum
	error "Test 8 failed because error was not silenced"
end try

(*************************************************************)

on newTask(taskName, src)
	
	script TaskManager
		
		property kName : taskName
		property kIdentifier : missing value
		property kType : "bash"
		property kUser : "current"
		
		property pSilenceError : false
		property pDebugMode : true
		property kWorkDirectory : missing value
		
		property kCommandPath : missing value
		property kStandardOutPath : missing value
		property kStandardErrorPath : missing value
		property kPidPath : missing value
		property kExitCodePath : missing value
		
		property pIsAutoWorkDirectory : true
		property pIsAutoCommandPath : true
		property pIsAutoStandardOutPath : true
		property pIsAutoStandardErrorPath : true
		property pIsAutoPidPath : true
		property pIsAutoExitCodePath : true
		
		property pAutoCleanUp : true
		
		property kSource : src
		
		property kPID : missing value
		property pExitCode : missing value
		property pStandardOut : missing value
		property pStandardError : missing value
		
		property pInitialized : false
		property kNL : ASCII character 10
		
		on setSilenceError(aBoolean)
			set pSilenceError to aBoolean
			return
		end setSilenceError
		
		on silenceError()
			return pSilenceError
		end silenceError
		
		on setDebugMode(aBoolean)
			set pDebugMode to aBoolean
			return
		end setDebugMode
		
		on debugMode()
			return pDebugMode
		end debugMode
		
		on setWorkDirectory(aPath)
			set kWorkDirectory to hfsPath(aPath)
			if kWorkDirectory does not end with ":" then set kWorkDirectory to kWorkDirectory & ":"
			set pIsAutoWorkDirectory to false
			return
		end setWorkDirectory
		
		on workDirectory()
			return kWorkDirectory
		end workDirectory
		
		on setCommandPath(aPath)
			set kCommandPath to hfsPath(aPath)
			set pIsAutoCommandPath to false
			return
		end setCommandPath
		
		on commandPath(aPath)
			return kCommandPath
		end commandPath
		
		on setStandardOutPath(aPath)
			set kStandardOutPath to hfsPath(aPath)
			set pIsAutoStandardOutPath to false
			return
		end setStandardOutPath
		
		on standardOutPath(aPath)
			return kStandardOutPath
		end standardOutPath
		
		on standardOut()
			
			if pStandardOut is not missing value then
				return pStandardOut
			end if
			
			if existsFile(kStandardOutPath) is false then
				return missing value
			end if
			
			return readStandardOut()
			
		end standardOut
		
		on setStandardErrorPath(aPath)
			set kStandardErrorPath to hfsPath(aPath)
			set pIsAutoStandardErrorPath to false
			return
		end setStandardErrorPath
		
		on standardErrorPath(aPath)
			return kStandardErrorPath
		end standardErrorPath
		
		on standardError()
			
			if pStandardError is not missing value then
				return pStandardError
			end if
			
			if existsFile(kStandardErrorPath) is false then
				return missing value
			end if
			
			return readStandardError()
			
		end standardError
		
		on setPidPath(aPath)
			set kPidPath to hfsPath(aPath)
			set pIsAutoPidPath to false
			return
		end setPidPath
		
		on pidPath(aPath)
			return kPidPath
		end pidPath
		
		on pid()
			return kPID
		end pid
		
		on setExitCodePath(aPath)
			set kExitCodePath to hfsPath(aPath)
			set pIsAutoExitCodePath to false
			return
		end setExitCodePath
		
		on exitCodePath(aPath)
			return kExitCodePath
		end exitCodePath
		
		on exitCode()
			
			if pExitCode is not missing value then
				return pExitCode as integer
			end if
			
			set pExitCode to readExitCode()
			
			return pExitCode
			
		end exitCode
		
		on init()
			
			set kIdentifier to _generateIdentifier()
			
			debugLog("Initializing")
			
			-- Work directory
			if kWorkDirectory is missing value then
				set pIsAutoWorkDirectory to true
				set kWorkDirectory to temporaryPathWithPrefixAndFolderName(kIdentifier & "_", "AppleScriptTaskManager")
			end if
			if kWorkDirectory does not end with ":" then set kWorkDirectory to kWorkDirectory & ":"
			
			-- Command file
			if kCommandPath is missing value then
				
				set pIsAutoCommandPath to true
				
				if kType is "bash" then
					set kCommandPath to kWorkDirectory & "command.sh"
				else
					error "Unknown task type: " & kType
				end if
				
			end if
			
			-- Standard out
			if kStandardOutPath is missing value then
				set pIsAutoStandardOutPath to true
				set kStandardOutPath to kWorkDirectory & "out.txt"
			end if
			
			-- Standard error
			if kStandardErrorPath is missing value then
				set pIsAutoStandardErrorPath to true
				set kStandardErrorPath to kWorkDirectory & "error.txt"
			end if
			
			-- PID
			if kPidPath is missing value then
				set pIsAutoPidPath to true
				set kPidPath to kWorkDirectory & "pid.txt"
			end if
			
			-- Exit code
			if kExitCodePath is missing value then
				set pIsAutoExitCodePath to true
				set kExitCodePath to kWorkDirectory & "exit_code.txt"
			end if
			
			if createDirectoryAtPath(kWorkDirectory) is false then
				error "Could not create work directory at " & kWorkDirectory
			end if
			
			set pInitialized to true
			
		end init
		
		on cleanup()
			
			debugLog("Cleaning up")
			
			kill()
			
			if pIsAutoWorkDirectory then shell("rm -rf " & qpp(kWorkDirectory))
			if pIsAutoCommandPath then shell("rm -rf " & qpp(kCommandPath))
			if pIsAutoStandardOutPath then shell("rm -rf " & qpp(kStandardOutPath))
			if pIsAutoStandardErrorPath then shell("rm -rf " & qpp(kStandardErrorPath))
			if pIsAutoPidPath then shell("rm -rf " & qpp(kPidPath))
			if pIsAutoExitCodePath then shell("rm -rf " & qpp(kExitCodePath))
			
		end cleanup
		
		on startAndWait()
			
			start()
			wait()
			if pAutoCleanUp then cleanup()
			
			return pStandardOut
			
		end startAndWait
		
		on startAndWaitSeconds(aTimeout)
			
			start()
			waitSeconds(aTimeout)
			if pAutoCleanUp then cleanup()
			
			return pStandardOut
			
		end startAndWaitSeconds
		
		on start()
			
			if not pInitialized then init()
			
			debugLog("Starting")
			
			try
				
				if kType is "bash" then
					
					simpleWriteFile(bashSource(), kCommandPath, «class utf8»)
					
					shell("chmod +x " & qpp(kCommandPath))
					set kPID to shell(qpp(kCommandPath) & " >> " & qpp(kStandardOutPath) & " 2>> " & qpp(kStandardErrorPath) & " & echo $!")
					
					simpleWriteFile(kPID, kPidPath, «class utf8»)
					
					return kPID
					
				else
					
					error "Unknown task type: " & kType
					
				end if
				
			on error eMsg number eNum
				raiseError("start", eMsg, eNum)
			end try
			
		end start
		
		on isRunning()
			
			set theResult to shell("ps -p " & quoted form of kPID & " > /dev/null ; echo $?")
			if theResult is not "0" then
				return false
			else
				return true
			end if
			
		end isRunning
		
		on wait()
			
			debugLog("Waiting")
			
			try
				
				repeat
					
					if not isRunning() then
						
						readData()
						
						if not silenceError() and exitCode() is missing value then
							
							error "Failed to determine exit code of task" number -1
							
						else if not silenceError() and exitCode() is not 0 then
							
							set errorMsg to "Task ended with exit code " & (exitCode() as text) & "."
							set stdError to standardError()
							if stdError is not missing value and stdError is not "" then
								set errorMsg to errorMsg & " " & stdError
							end if
							
							error errorMsg number exitCode()
							
						else
							
							return
							
						end if
						
					end if
					
					delay 0.3
					
				end repeat
				
			on error eMsg number eNum
				
				if eNum = -128 then
					kill()
					userCanceled("wait")
				else
					raiseError("wait", eMsg, eNum)
				end if
				
			end try
			
		end wait
		
		on waitSeconds(aTimeout)
			
			debugLog("Waiting with timeout of " & (aTimeout as text) & " seconds")
			
			try
				
				set maxDate to (current date) + aTimeout
				
				repeat
					
					if (current date) ≥ maxDate then
						
						set errorMsg to "Task timed out after " & (aTimeout as text) & " seconds"
						
						if silenceError() then
							set pExitCode to -2
							set pStandardOut to ""
							set pStandardError to errorMsg
							return
						else
							error errorMsg number -2
						end if
						
					end if
					
					set theResult to shell("ps -p " & quoted form of kPID & " > /dev/null ; echo $?")
					
					if theResult is not "0" then
						
						readData()
						return
						
					end if
					
					delay 0.3
					
				end repeat
				
			on error eMsg number eNum
				
				if eNum = -128 then
					kill()
					userCanceled("waitSeconds")
				else
					raiseError("waitSeconds", eMsg, eNum)
				end if
				
			end try
			
		end waitSeconds
		
		on readExitCode()
			
			if existsFile(kExitCodePath) is false then
				return missing value
			end if
			
			set currentExitCode to readFile(kExitCodePath, «class utf8»)
			
			if currentExitCode is "" then
				set currentExitCode to missing value
			end if
			
			if class of currentExitCode is text then
				set currentExitCode to currentExitCode as integer
			end if
			
			return currentExitCode
			
		end readExitCode
		
		on readStandardError()
			
			if not existsFile(kStandardErrorPath) then
				return missing value
			end if
			
			return readFile(kStandardErrorPath, «class utf8»)
			
		end readStandardError
		
		on readStandardOut()
			
			if not existsFile(kStandardOutPath) then
				return missing value
			end if
			
			return readFile(kStandardOutPath, «class utf8»)
			
		end readStandardOut
		
		on readData()
			
			set pExitCode to readExitCode()
			set pStandardOut to readStandardOut()
			set pStandardError to readStandardError()
			
			return
			
		end readData
		
		on kill()
			
			repeat
				try
					shell("kill " & quoted form of kPID)
					debugLog("Terminated process")
				on error
					exit repeat
				end try
			end repeat
			
			repeat
				try
					shell("pkill -P " & quoted form of kPID)
					debugLog("Terminated child processes")
				on error
					exit repeat
				end try
			end repeat
			
		end kill
		
		on raiseError(fnc, msg, num)
			
			errorLog(fnc, msg, num)
			
			if pAutoCleanUp then cleanup()
			
			set msg to searchAndReplace(msg, POSIX path of kCommandPath, "command.sh")
			
			error fnc & "(): " & msg number num
			
		end raiseError
		
		on userCanceled(fnc)
			
			errorLog(fnc, "User canceled task.", -128)
			
			if pAutoCleanUp then cleanup()
			
			error "User canceled task." number -128
			
		end userCanceled
		
		
		on bashSource()
			
			return "#!/bin/bash
	
function _finish() {
	exit_code=$?
    printf \"$exit_code\" > " & qpp(kExitCodePath) & "
   	exit \"$exit_code\"
}
	
trap _finish EXIT
	
" & kSource
			
		end bashSource
		
		on shell(cmd)
			
			if kUser is "root" then
				do shell script cmd with administrator privileges
			else
				do shell script cmd
			end if
			
		end shell
		
		on _generateIdentifier()
			
			set str to searchAndReplace(kName, {" ", ":", "/", "\\"}, {"_", "-", "-", "-"})
			set str to filterString(str, "_-abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789")
			
			return str
			
		end _generateIdentifier
		
		on temporaryPathWithPrefixAndFolderName(prefix, folderName)
			
			(*
				Generates a unique path for a file or folder in the 
				current user's temporary items folder. 
		
				Takes a single argument that can be set to the
				name of a subfolder or false to create no subfolder.
			*)
			
			-- Create file name
			set fileName to ((prefix & timestamp(current date, 2)) as text)
			
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
					set tempPath to parentFolderPath & fileName
				else
					set tempPath to parentFolderPath & fileName & "_" & (rNumber as text)
				end if
				
				tell application "System Events"
					try
						if (exists file tempPath) is false then
							if (exists folder tempPath) is false then
								exit repeat
							end if
						end if
					end try
				end tell
				
				set rNumber to rNumber + 1
			end repeat
			
			return tempPath
			
		end temporaryPathWithPrefixAndFolderName
		
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
		
		on createDirectoryAtPath(dirPath)
			
			(*
				Creates a folder at the specified path (HFS-style or POSIX)
				with intermediate directories being created when necessary.
			*)
			
			
			try
				
				set dirPath to hfsPath(dirPath)
				
				if dirPath does not end with ":" then set dirPath to dirPath & ":"
				
				-- Exit early if directory already exists
				tell application "System Events" to if (exists folder dirPath) then return true
				
				-- Break path into components
				set prvDlmt to text item delimiters
				set text item delimiters to ":"
				set pathComponents to text items of dirPath
				set text item delimiters to prvDlmt
				
				-- Check directories at each level
				set parentDirectoryPath to (item 1 of pathComponents) & ":"
				
				repeat with i from 2 to ((count of pathComponents) - 1)
					
					-- Get the name and path for this directory	
					set currentName to item i of pathComponents
					set currentPath to parentDirectoryPath & currentName & ":"
					
					-- Create directory if necessary
					tell application "System Events"
						if (exists folder currentPath) is false then
							make new folder at end of folders of folder parentDirectoryPath with properties {name:currentName}
						end if
						
					end tell
					
					-- Save this directory as the next parent directory
					set parentDirectoryPath to currentPath
					
				end repeat
				
				return true
				
			on error eMsg number eNum
				
				return false
				
			end try
			
		end createDirectoryAtPath
		
		on qpp(aPath)
			
			return quoted form of (POSIX path of aPath)
			
		end qpp
		
		on hfsPath(aPath)
			
			(* Converts any file reference even relative ones to a HFS-style path string. *)
			
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
				set parentDirectoryCount to (count of pathComponents)
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
		
		on searchAndReplace(aText, aPattern, aReplacement)
			
			(*	Search for a pattern and replace it in a string. Pattern and replacement can be a list of multiple values. *)
			
			if (class of aPattern) is list and (class of aReplacement) is list then
				
				-- Replace multiple patterns with a corresponding replacement
				
				-- Check patterns and replacements count
				if (count of aPattern) is not (count of aReplacement) then
					error "The count of patterns and replacements needs to match."
				end if
				
				-- Process matching list of patterns and replacements
				repeat with i from 1 to count of aPattern
					set aText to searchAndReplace(aText, item i of aPattern, item i of aReplacement)
				end repeat
				
				return aText
				
			else if class of aPattern is list then
				
				-- Replace multiple patterns with the same text
				
				repeat with i from 1 to count of aPattern
					set aText to searchAndReplace(aText, item i of aPattern, aReplacement)
				end repeat
				
				return aText
				
			else
				
				
				if aText does not contain aPattern then
					
					return aText
					
				else
					
					set prvDlmt to text item delimiters
					
					-- considering case
					
					try
						set text item delimiters to aPattern
						set tempList to text items of aText
						set text item delimiters to aReplacement
						set aText to tempList as text
					end try
					
					--	end considering
					
					set text item delimiters to prvDlmt
					
					return aText
					
				end if
				
			end if
			
		end searchAndReplace
		
		on filterString(str, filterCharacters)
			
			try
				
				(* Filters the specified characters from a string. *)
				
				if str is "" then
					return ""
					
				else
					
					if class of filterCharacters is text then
						set filterCharacters to characters of filterCharacters
					end if
					
					if class of filterCharacters is not list then
						error "Please specify either a string or a list of characters to filter"
					end if
					
					set filteredString to ""
					repeat with i from 1 to length of str
						if character i of str is in filterCharacters then
							set filteredString to filteredString & character i of str
						end if
					end repeat
					
					
					return filteredString
					
				end if
				
			on error eMsg number eNum
				
				error "filter: " & eMsg number eNum
				
			end try
			
		end filterString
		
		on existsFile(aPath)
			tell application "System Events"
				try
					return (exists file aPath)
				on error
					return false
				end try
			end tell
		end existsFile
		
		on simpleWriteFile(content, filePath, contentType)
			
			try
				
				-- Convert path to text
				set filePath to hfsPath(filePath)
				
				-- Set content type if not already set
				if contentType is false then
					set contentType to class of content
				end if
				
				-- Open file
				try
					open for access file filePath with write permission
				on error eMsg number eNum
					error "Could not open file at \"" & filePath & "\" with write permission: " & eMsg number eNum
				end try
				
				-- Write to file
				try
					
					set eof of file filePath to 0
					write content to file filePath starting at 0 as contentType
					
				on error eMsg number eNum
					
					try
						close access file filePath
					end try
					
					error "Error while writing to file at \"" & filePath & "\": " & eMsg number eNum
					
				end try
				
				
				-- Close file
				try
					close access file filePath
				end try
				
				
				return true
				
			on error eMsg number eNum
				
				raiseError("simpleWriteFile", eMsg, eNum)
				
			end try
			
			
		end simpleWriteFile
		
		on readFile(filePath, contentClass)
			
			try
				
				(*
					Reads contents of a file at the specified path. Second 
					parameter is content type [e.g. text, record, «class utf8», etc.]
				*)
				
				set filePath to hfsPath(filePath)
				
				if contentClass is missing value or contentClass is in {false, 0, "", "utf8", "utf-8"} then
					-- Set default content class
					set contentClass to «class utf8»
				end if
				
				-- Check if the file exists
				tell application "System Events" to if (exists file filePath) is false then error "File not found."
				
				-- Open file for reading
				try
					open for access file filePath
				on error eMsg number eNum
					error "Could not open file at \"" & filePath & "\": " & eMsg number eNum
				end try
				
				-- Read
				try
					set fileContents to read file filePath as contentClass
				on error eMsg number eNum
					try
						close access file filePath
					end try
					error "Error while trying to read file at \"" & filePath & "\": " & eMsg number eNum
				end try
				
				-- Close
				try
					close access file filePath
				end try
				
				return fileContents
				
			on error eMsg number eNum
				
				if eNum is -39 then return ""
				
				raiseError("readFile", eMsg, eNum)
				
			end try
			
		end readFile
		
		on debugLog(msg)
			if pDebugMode then
				log " " & kName & ": " & msg & " "
			end if
		end debugLog
		
		on errorLog(fnc, msg, num)
			if fnc is not false and fnc is not missing value then
				log " " & kName & ": Error in " & fnc & "(): " & msg & " (" & (num as text) & ")"
			else
				log " " & kName & ": Error: " & msg & " (" & (num as text) & ")"
			end if
		end errorLog
		
	end script
	
	return TaskManager
	
end newTask