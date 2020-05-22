loadScript("~/Projects/applescript-libraries/CodaAutomator/CodaAutomator.applescript")

on loadScript(scriptPath)
	
	tell application "System Events"
		
		try
			
			(* 
		Loads an AppleScript file compiling it first if necessary. Specified path can be:
		- single file name 
		  --> file assumed in same directory as main script
		- single file name prefixed with ./ 
		  --> file assumed in same directory as main script
		- relative POSIX path prefixed with one or more ../ 
		  --> file assumed at relative path
		- relative POSIX path starting with ~/ 
		  --> file assumed relative to home directory
		- full HFS-style path
		- full POSIX path
	*)
			
			log " asdf to load script from " & scriptPath & " "
			
			-- Convert path to text
			try
				set scriptPath to scriptPath as text
			on error
				set scriptPath to path of scriptPath
			end try
			
			if scriptPath starts with "'" and scriptPath ends with "'" then
				-- Remove quotes
				set scriptPath to text 2 thru -2 of anyPath
			end if
			
			if scriptPath does not contain "/" and scriptPath does not contain ":" then
				-- Only filename specified; treat as path relative to current directory
				set scriptPath to "./" & scriptPath
			end if
			
			log " Normalized path to " & scriptPath & " "
			
			if scriptPath starts with "~" then
				
				-- Expand tilde
				
				log " Expanding tilde "
				
				-- Get the path to the userÕs home folder
				set userPath to POSIX path of (path to home folder)
				
				-- Remove trailing slash
				if userPath ends with "/" then set userPath to (text 1 thru -2 of userPath) as text
				
				log " Found userÕs home folder at " & userPath & " "
				
				if scriptPath is "~" then
					-- Simply use home folder path
					set scriptPath to userPath
				else
					-- Concatenate paths
					set scriptPath to userPath & (text 2 thru -1 of scriptPath)
				end if
				
			else if scriptPath starts with "./" then
				
				-- Convert reference to current directory to absolute path
				
				set scriptPath to text 3 thru -1 of scriptPath
				
				try
					set myPath to POSIX path of file kScriptPath
				on error
					set myPath to POSIX path of (path to me)
				end try
				
				set prvDlmt to AppleScript's text item delimiters
				set AppleScript's text item delimiters to "/"
				set parentDirectoryPath to (text items 1 thru -2 of myPath) & "" as text
				set AppleScript's text item delimiters to prvDlmt
				
				set scriptPath to parentDirectoryPath & scriptPath
				
			else if scriptPath starts with "../" then
				
				-- Convert reference to parent directories to absolute path
				
				try
					set myPath to POSIX path of file kScriptPath
				on error
					set myPath to POSIX path of (path to me)
				end try
				
				set prvDlmt to AppleScript's text item delimiters
				set AppleScript's text item delimiters to "../"
				set pathComponents to text items of scriptPath
				set parentDirectoryCount to (count of pathComponents) - 1
				set AppleScript's text item delimiters to "/"
				set myPathComponents to text items of myPath
				set parentDirectoryPath to (items 1 thru ((count of items of myPathComponents) - parentDirectoryCount) of myPathComponents) & "" as text
				set AppleScript's text item delimiters to prvDlmt
				
				set scriptPath to parentDirectoryPath & item -1 of pathComponents
				
			end if
			
			try
				set scriptPath to file scriptPath
			on error eMsg number eNum
				log " Script file not found at " & scriptPath & " "
				error "Script file not found at \"" & scriptPath & "\""
			end try
			
			try
				set scriptPath to path of scriptPath
			on error
				set scriptPath to scriptPath as text
			end try
			
			log " Script path after transformations is " & scriptPath
			
			-- Get information on existing script file
			try
				set scriptInfo to get info for file scriptPath
			on error
				error "Could not find script file at \"" & scriptPath & "\""
			end try
			
			if scriptPath ends with ".applescript" then
				
				log " Plain-text AppleScript specified "
				
				-- Plain text version of script; look for compiled version
				
				-- Create id for this script based on its path
				set prvDlmt to AppleScript's text item delimiters
				set AppleScript's text item delimiters to {":", " ", "/"}
				set scriptId to text items of scriptPath
				set AppleScript's text item delimiters to "_"
				set scriptId to scriptId as text
				set AppleScript's text item delimiters to prvDlmt
				
				-- Remove the .applescript suffix from the id
				set scriptId to text 1 thru -13 of scriptId
				
				-- Generate temporary path
				set tempScriptPath to ((path to temporary items folder from user domain) as text) & scriptId & ".scpt"
				
				-- Get information on existing compiled script		
				try
					set tempScriptInfo to get info for file tempScriptPath
				on error
					set tempScriptInfo to false
				end try
				
				
				if tempScriptInfo is false or (modification date of scriptInfo) > (modification date of tempScriptInfo) then
					
					log " Preparing paths for shell script "
					
					set scriptPathPP to (POSIX path of file scriptPath)
					set tempScriptPathPP to (POSIX path of (path to temporary items folder from user domain)) & "/" & scriptId & ".scpt"
					
					tell AppleScript
						set scriptPathQPP to quoted form of scriptPathPP
						set tempScriptPathQPP to quoted form of tempScriptPathPP
					end tell
					
					
					log " Compiling script at " & scriptPathQPP & " to " & tempScriptPathQPP & " "
					
					-- Compiled version does not exist or is out-dated; re-compile script
					
					set compileCommand to "/usr/bin/osacompile -o " & tempScriptPathQPP & " " & scriptPathQPP
					
					log " " & compileCommand & " "
					try
						do shell script compileCommand
					on error eMsg number eNum
						error "loadScript: Failed to compile script file at \"" & scriptPathPP & "\". " & eMsg number eNum
					end try
					
				end if
				
				
				
				set useTempScript to true
				
			else
				
				log " Compiled AppleScript specified "
				
				set useTempScript to false
				
			end if
			
			-- Determine which path to load from
			if useTempScript then
				set scriptToLoad to tempScriptPath
			else
				set scriptToLoad to scriptPath
			end if
			
			-- Load the script			
			try
				log " Loading script from " & scriptToLoad & " "
				
				set loadedScript to load script file scriptToLoad
			on error eMsg number eNum
				error "loadScript: Could not load script file at \"" & scriptToLoad & "\". " & eMsg number eNum
			end try
			
			-- Set the script's own path property
			try
				set loadedScript's kScriptPath to scriptPath
				log " Set kScriptPath property in loaded script to " & scriptPath & " "
			on error eMsg number eNum
				log " Warning! Could not set script path in loaded script: " & eMsg & " "
			end try
			
			return loadedScript
			
		on error eMsg number eNum
			
			log " " & eMsg & " (" & (eNum as string) & ")"
			error "loadScript(): " & eMsg number eNum
			
		end try
		
	end tell
	
end loadScript