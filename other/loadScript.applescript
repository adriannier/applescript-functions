on run
	
	set dictLibrary to loadScript("~/Projects/applescript-dictionary/Dictionary.applescript")
	
	set dict to dictLibrary's newDictionary()
	
	dict's addValueForKey("test", current date)
	
	return dict's recordRepresentation()
	
end run

on loadScript(scriptPath)
	
	(* 
		Loads an AppleScript file compiling it first if necessary. Specified path can be:
		- single file name 
		  --> file assumed in same directory as current script
		- single file name prefixed with ./ 
		  --> file assumed in same directory as current script
		- relative POSIX path prefixed with one or more ../ 
		  --> file assumed at relative path
		- relative POSIX path starting with ~/ 
		  --> file assumed relative to home directory
		- full HFS-style path
		- full POSIX path
	*)
	
	try
		
		script Util
			
			on q(str)
				
				(* Return quoted string *)
				
				return quoted form of str
			end q
			
			on pp(aPath)
				
				(* Return posix path for path *)
				
				try
					tell application "System Events" to return POSIX path of file (aPath as text)
				on error
					try
						tell application "System Events" to return POSIX path of folder (aPath as text) & "/"
					on error eMsg number eNum
						error "Util/pp(): " & eMsg number eNum
					end try
				end try
			end pp
			
			on qpp(aPath)
				
				(* Return quoted posix path for path *)
				
				return q(pp(aPath))
			end qpp
			
			on snr(str, search, replace)
				
				(* Search and replace *)
				
				return implode(explode(str, search), replace)
				
			end snr
			
			on explode(str, dlmt)
				
				(* Convert string to list *)
				
				set prvDlmt to AppleScript's text item delimiters
				set AppleScript's text item delimiters to dlmt
				set strComponents to text items of str
				set AppleScript's text item delimiters to prvDlmt
				
				return strComponents
				
			end explode
			
			on implode(strComponents, dlmt)
				
				(* Convert list to string *)
				
				set prvDlmt to AppleScript's text item delimiters
				set AppleScript's text item delimiters to dlmt
				set str to strComponents as text
				set AppleScript's text item delimiters to prvDlmt
				
				return str
				
			end implode
			
			on unwrap(str, char)
				
				(* Remove first and last character of `str` if both characters are `char` *)
				
				if str starts with char and str ends with char and str is not (char & char) then
					return text 2 thru -2 of str
				end if
				
				return str
				
			end unwrap
			
			on pathToString(aPath)
				
				(* Convert any path to a string *)
				
				try
					tell application "System Events" to return scriptPath as text
				on error
					tell application "System Events" to return path of scriptPath
				end try
				
			end pathToString
			
		end script
		
		-- Convert path to text
		tell Util
			set scriptPath to pathToString(scriptPath)
			set scriptPath to unwrap(scriptPath, "'")
		end tell
		
		if scriptPath does not contain "/" and scriptPath does not contain ":" then
			-- Only filename specified; treat as path relative to current directory
			set scriptPath to "./" & scriptPath
		end if
		
		-- Get the path to this script
		try
			set myPath to Util's pp(kScriptPath)
		on error
			set myPath to Util's pp(path to me)
		end try
		
		-- Get path to parent directory
		tell Util
			set myPathComponents to explode(myPath, "/")
			set myParentDirectoryPath to implode(items 1 thru -2 of myPathComponents, "/")
		end tell
		
		if scriptPath does not contain ":" then
			
			if scriptPath starts with "~" then
				
				(* Expand tilde *)
				
				-- Get the path to the userÕs home folder
				set userPath to Util's pp(path to home folder as text)
				
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
				
				log " Expanded tilde to " & scriptPath
				
			else if scriptPath starts with "./" then
				
				(* Convert current directory reference *)
				
				set scriptPath to myParentDirectoryPath & text 3 thru -1 of scriptPath
				
				log " Converted reference to current directory to " & scriptPath
				
			else if scriptPath starts with "../" then
				
				-- Convert reference to parent directories to absolute path
				
				tell Util
					set pathComponents to explode(scriptPath, "../")
					set parentDirectoryCount to (count of pathComponents) - 1
					set parentDirectoryPath to implode((items 1 thru ((count of items of myPathComponents) - parentDirectoryCount) of myPathComponents) & "", "/")
				end tell
				
				set scriptPath to parentDirectoryPath & item -1 of pathComponents
				
				log " Converted relative path to " & scriptPath
				
			else
				
				log " Normalized path to " & scriptPath & " "
				
			end if
			
			-- Turn POSIX path to HFS path
			set scriptPath to POSIX file scriptPath as text
			
		end if
		
		-- Get information on existing script file
		try
			tell application "System Events"
				set scriptModDate to modification date of file scriptPath
			end tell
		on error
			error "Could not find script file at \"" & scriptPath & "\""
		end try
		
		if scriptPath ends with ".applescript" then
			
			log " Plain-text AppleScript specified "
			
			-- Plain text version of script; look for compiled version
			
			-- Turn script path into a string we can use for identification
			tell Util to set scriptId to implode(explode(scriptPath, {":", " ", "/"}), "_")
			-- Remove the .applescript suffix from the id
			set scriptId to text 1 thru -13 of scriptId
			
			-- Generate temporary path
			set compiledScriptParent to (path to temporary items folder from user domain) as text
			set compiledScriptPath to compiledScriptParent & scriptId & ".scpt"
			
			-- Get information on possibly existing compiled script		
			try
				tell application "System Events"
					set compiledModDate to modification date of file compiledScriptPath
				end tell
			on error
				set compiledModDate to false
			end try
			
			if compiledModDate is false or scriptModDate > compiledModDate then
				
				log " Script changed or was never compiled "
				
				set compileCommand to "/usr/bin/osacompile -o " & Util's q(Util's pp(compiledScriptParent) & scriptId & ".scpt") & " " & Util's qpp(scriptPath)
				
				try
					do shell script compileCommand
				on error eMsg number eNum
					error "Failed to compile script file at \"" & scriptPath & "\". " & eMsg number eNum
				end try
				
			end if
			
		else
			
			log " Compiled AppleScript specified "
			
			set compiledScriptPath to scriptPath
			
		end if
		
		-- Load the script			
		try
			log " Loading script from \"" & compiledScriptPath & "\" "
			set loadedScript to load script file compiledScriptPath
		on error eMsg number eNum
			error "Could not load script file at \"" & compiledScriptPath & "\". " & eMsg number eNum
		end try
		
		-- Try to set script's own path property
		try
			set loadedScript's kScriptPath to scriptPath
			log " Property kScriptPath set \"" & scriptPath & "\" in loaded script "
		on error eMsg number eNum
			log " Warning! Could not set script path in loaded script: " & eMsg & " "
		end try
		
		return loadedScript
		
	on error eMsg number eNum
		
		log " " & eMsg & " (" & (eNum as string) & ")"
		error "loadScript(): " & eMsg number eNum
		
	end try
	
end loadScript