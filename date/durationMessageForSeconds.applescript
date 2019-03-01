(*
The specified number of seconds is converted to a string like "30 minutes" or "1 day"
*)

durationMessageForSeconds(3)

on durationMessageForSeconds(theSeconds)
	
	-- Check input
	if theSeconds = 0 then return "just now"
	
	-- Set the name of the units
	set singleUnits to {"second", "minute", "hour", "day", "week", "month", "year", "century", "millennium"}
	set pluralUnits to {"seconds", "minutes", "hours", "days", "weeks", "months", "years", "centuries", "millennia"}
	
	-- Setup multiplicators
	set multiplicators to {1, 60, 60, 24, 7, 4, 12, 100, 100, 100}
	
	-- Initialize variables
	set max to 1
	set v to theSeconds
	
	
	repeat with i from 1 to count of singleUnits
		
		-- Determine the maximum value covered by this unit
		set max to max * (item i of multiplicators)
		
		-- Is the duration within the limits for this unit?
		if theSeconds < max then exit repeat
		
		-- Reduce the value for the next unit
		set v to v div (item i of multiplicators)
		
	end repeat
	
	
	-- Choose the appropriate version of the unit
	if v > 1 then
		set theUnit to item (i - 1) of pluralUnits
	else
		set theUnit to item (i - 1) of singleUnits
	end if
	
	-- Return the string
	set durationText to ((v as string) & " " & theUnit) as string
	
	return durationText
		
end durationMessageForSeconds
