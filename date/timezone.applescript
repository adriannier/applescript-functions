return timezone()

on timezone()
	
	(* Returns the system’s current timezone as tz database name *)
	
	tell (do shell script "/usr/bin/readlink /etc/localtime")
		tell contents
			return word -2 & "/" & word -1
		end tell
	end tell
	
end timezone