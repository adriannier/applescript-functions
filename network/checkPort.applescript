(*
	Checks if a network port is open.
*)

log checkPort(80, "www.apple.com", 3)

log checkPort(80, "swscan.apple.com", 3)

log checkPort(80, "google.com", 3)

on checkPort(aPort, anAddress, aTimeout)
	
	script PortChecker
		
		property portNumber : aPort
		property networkAddress : anAddress
		property theTimeout : aTimeout
		
		property quotedStrokeToolPath : false
		property strokeToolPID : false
		property strokeFilePath : false
		
		on init()
			
			set sv to systemVersion()
			
			if major of sv ≥ 10 and minor of sv ≥ 9 then
				set quotedStrokeToolPath to quoted form of "/System/Library/CoreServices/Applications/Network Utility.app/Contents/Resources/stroke"
			else
				set quotedStrokeToolPath to quoted form of "/Applications/Utilities/Network Utility.app/Contents/Resources/stroke"
			end if
			
		end init
		
		on check()
			
			stroke()
			
			set strokeResult to checkResult()
			
			cleanUp()
			
			return strokeResult
			
		end check
		
		on stroke()
			
			if quotedStrokeToolPath is false then error "Path to stroke tool not set. Did you first call init()?"
			
			set strokeFilePath to temporaryPath()
			set quotedStrokeFilePath to quoted form of (POSIX path of strokeFilePath)
			
			-- Run stroke tool
			set pid to do shell script quotedStrokeToolPath & " " & quoted form of networkAddress & " " & quoted form of (portNumber as text) & " " & quoted form of (portNumber as text) & " > " & quotedStrokeFilePath & " 2>&1 & echo $!"
			
			-- Make sure the pid is an integer
			try
				set strokeToolPID to pid as integer
			on error
				set strokeToolPID to false
			end try
			
		end stroke
		
		on checkResult()
			
			-- Check for result
			set timeTaken to 0.0
			set strokeResult to false
			
			repeat
				
				try
					set strokeOutput to readFile(strokeFilePath, text)

					if strokeOutput contains "Open TCP Port" or strokeOutput contains "Open UDP Port" then
						set strokeResult to true
						exit repeat
					end if
					
				end try
				
				
				delay 0.1
				set timeTaken to timeTaken + 0.1
				if timeTaken is greater than or equal to theTimeout then exit repeat
				
			end repeat
			
			return strokeResult
			
		end checkResult
		
		on cleanUp()
			
			try
				if strokeToolPID is not false then do shell script "/bin/kill " & (strokeToolPID as text)
			end try
			
			tell application "System Events" to delete file strokeFilePath
			
		end cleanUp
		
		on temporaryPath()
			
			-- Generate pseudorandom numbers
			set rand1 to (round (random number from 100 to 999)) as text
			set rand2 to (round (random number from 100 to 999)) as text
			set randomText to rand1 & "-" & rand2
			
			-- Create file name
			set fileName to (("AppleScriptTempFile_" & randomText) as text)
			
			-- Get the path to the parent folder
			set parentFolderPath to (path to temporary items folder from user domain) as text
			
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
			
		end temporaryPath
		
		on readFile(filePath, contentClass)
			
			try
				
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
				
				if contentClass is missing value or contentClass is in {false, 0, "", "utf8", "utf-8"} then
					-- Set default content class
					set contentClass to «class utf8»
				end if
				
				-- Check if the file exists
				tell application "System Events" to if (exists file filePath) is false then error "File not found."
				
				-- Open file for reading
				try
					open for access file filePath
				on error errorMessage number errorNumber
					error "Could not open file: " & errorMessage number errorNumber
				end try
				
				-- Read
				try
					set fileContents to read file filePath as contentClass
				on error errorMessage number errorNumber
					try
						close access file filePath
					end try
					error "Error while trying to read file: " & errorMessage number errorNumber
				end try
				
				-- Close
				try
					close access file filePath
				end try
				
				return fileContents
				
			on error errorMessage number errorNumber
				
				set errorMessage to "readFile(\"" & filePath & "\", " & (contentClass as text) & "): " & ¬
					errorMessage
				error errorMessage number errorNumber
				
			end try
			
		end readFile
		
		
		on systemVersion()
			
			set hex to system attribute "sysv"
			
			-- Get the revision
			set revision to hex mod 16
			set hex to hex div 16
			
			-- Get the minor version
			set minor to hex mod 16
			set hex to hex div 16
			
			-- Get the major version
			set major1 to hex mod 16 as text
			set hex to hex div 16
			set major2 to hex mod 16 as text
			set hex to hex div 16
			set major to (major2 & major1 as text) as integer
			
			-- Concatenate the version string
			set versionString to (major as text) & "." & (minor as text) & "." & (revision as text)
			
			return {major:major, minor:minor, revision:revision, versionString:versionString}
			
		end systemVersion
		
	end script
	
	tell PortChecker
		
		init()
		set checkResult to check()
		
	end tell
	
	return checkResult
	
end checkPort