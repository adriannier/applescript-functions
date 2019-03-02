(*
	Returns the specified date and time as a string suitable for either log files or file names.
*)

log timestampWithFormat(current date, 1)

log timestampWithFormat(current date, 2)

log timestampWithFormat(current date, 3)

on timestampWithFormat(aDate, aFormat)

	(*
		Returns the specified date and time as a string suitable for either log files or file names.
		
		Formats:
		
		1: 2000-01-28 23:15:59
		2: 2000-01-28_23-15-59
		3: Jan 28 23:15:59
		
	*)
	
	if aDate is false then set aDate to current date
	if aFormat is false then set aFormat to 1
	
	-- Get the month and day as integer
	set m to month of aDate as integer
	set d to day of aDate
	
	-- Get the year
	set y to year of aDate as text
	
	-- Get the seconds since midnight
	set theTime to (time of aDate)
	
	-- Get hours, minutes, and seconds
	set h to theTime div (60 * 60)
	set min to theTime mod (60 * 60) div 60
	set s to theTime mod 60
	
	if aFormat is not 3 then
		-- Zeropad month value
		set m to m as text
		if (count of m) is less than 2 then set m to "0" & m
	end if
	
	-- Zeropad day value
	set d to d as text
	if (count of d) is less than 2 then
		if aFormat is 3 then
			set d to " " & d
		else
			set d to "0" & d
		end if
	end if
	
	-- Zeropad hours value
	set h to h as text
	if (count of h) is less than 2 then set h to "0" & h
	
	-- Zeropad minutes value
	set min to min as text
	if (count of min) is less than 2 then set min to "0" & min
	
	-- Zeropad seconds value
	set s to s as text
	if (count of s) is less than 2 then set s to "0" & s
	
	if aFormat is 1 then
		-- Return in a format suitable for log files (e.g. 2000-01-28 23:15:59)
		return y & "-" & m & "-" & d & " " & h & ":" & min & ":" & s
	else if aFormat is 2 then
		-- Return in a format suitable for file names (e.g. 2000-01-28_23-15-59)
		return y & "-" & m & "-" & d & "_" & h & "-" & min & "-" & s
	else if aFormat is 3 then
		-- Return in an alternative log file format (e.g. Jan 28 23:15:59)
		set shortMonths to {"Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"}
		return (item m of shortMonths) & " " & d & " " & h & ":" & min & ":" & s
	else
		return ""
	end if
	
end timestamp
