(*
	Hides the application defined by the name provided as the parameter.
*)

hideApplication("Finder")

hideApplication("VMware Fusion")

on hideApplication(appName)
	
	(* Hides the application defined by the name provided as the parameter. *)
	
	tell application "System Events"
		
		if (exists process appName) is false then
			
			-- Find out the application's process name,	
			-- If there's no process that has the same name as the application.
			set foundProcess to false
			
			-- Go through the displayed name, title and short name properties
			try
				-- Is there a process with the displayed name set to the app name?
				set foundProcess to first process whose displayed name is appName
			on error
				try
					-- Is there a process with the title set to the app name?
					set foundProcess to first process whose title is appName
				on error
					try
						-- Is there a process with the short name set to the app name?
						set foundProcess to first process whose short name is appName
					end try
				end try
			end try
			
			
			if foundProcess is not false then
				
				-- Matching process name found; use it instead of the application name
				set appName to name of foundProcess
				
			end if
			
		end if
		
		-- Hide the process
		set visible of process appName to false
		
		
	end tell
	
end hideApplicationByName