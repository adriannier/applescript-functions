(*
	Pings a network address one time. Returns true if answer came inside specified timeout. False otherwise.
*)

log pingNetworkAddress("8.8.8.8", 3)

log pingNetworkAddress("apple.com", 3)

on pingNetworkAddress(anAddress, aTimeout)
	
	script NetworkPinger
		
		property networkAddress : anAddress
		property theTimeout : aTimeout
		
		property pingToolPID : false
		property pingOutputFilePath : false
		
		on ping()
			
			runPingTool()
			set pingResult to checkResult()
			
			cleanUp()
			
			return pingResult
			
		end ping
		
		on runPingTool()
			
			set pingOutputFilePath to temporaryPath()
			
			-- Run ping tool
			set pid to do shell script "/sbin/ping -c 1 " & networkAddress & " > " & quoted form of (POSIX path of pingOutputFilePath) & " 2>&1 & echo $!"
			
			-- Make sure the pid is an integer
			try
				set pingToolPID to pid as integer
			on error
				set pingToolPID to false
			end try
			
		end runPingTool
		
		on checkResult()
			
			-- Check for result
			set timeTaken to 0.0
			set pingResult to false
			
			repeat
				try
					set pingOutput to readFile(pingOutputFilePath, text)
					
					if pingOutput contains " 0% packet loss" or pingOutput contains " 0.0% packet loss" then
						
						set pingResult to true
						exit repeat
						
					end if
				end try
				
				
				delay 0.1
				set timeTaken to timeTaken + 0.1
				if timeTaken is greater than or equal to theTimeout then exit repeat
				
			end repeat
			
			return pingResult
			
		end checkResult
		
		on cleanUp()
			
			try
				if pingToolPID is not false then do shell script "/bin/kill " & (pingToolPID as text)
			end try
			tell application "System Events" to delete file pingOutputFilePath
			
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
					
					-- Get the path to the userÕs home folder
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
					set contentClass to Çclass utf8È
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
				
				set errorMessage to "readFile(\"" & filePath & "\", " & (contentClass as text) & "): " & Â
					errorMessage
				error errorMessage number errorNumber
				
			end try
			
		end readFile
		
	end script
	
	tell NetworkPinger to return ping()
	
end pingNetworkAddress