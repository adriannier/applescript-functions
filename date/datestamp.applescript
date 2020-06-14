set exampleDate to current date
copy {1993, 4, 10, 0} to {year of exampleDate, day of exampleDate, month of exampleDate, time of exampleDate}

-- 1993-10-04
log datestamp(exampleDate, 1)

-- Oct 4
log datestamp(exampleDate, 3)

-- 19931004
log datestamp(exampleDate, 4)

on datestamp(aDate as date, aFormat)
	
	(*
	
		With big thanks to CK (twitter.com/AppleScriptive) for pointing out «class isot»
		
		Returns the specified date and time as a string
		
		Formats:
		
		1: 2000-01-28 -- ISO 8601
		
		2: Same as 1 -- Compatibility to timestamp() function
		
		3: Jan 28 -- Short month and day
		
		4: 20000128 -- Digits only
		
		5: Same as 4 -- Compatibility to timestamp() function
			
	*)
	
	tell aDate as «class isot» as string
		
		tell contents
			
			if aFormat is 1 or aFormat is 2 then
				
				return text 1 thru 10
				
			else if aFormat is 3 then
				
				set shortMonths to {"Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"}
				
				return item (month of aDate) of shortMonths & " " & (day of aDate as text) 
				
			else if aFormat is 4 or aFormat is 5 then
				
				return text 1 thru 4 & text 6 thru 7 & text 9 thru 10 
							
			else
				
				error "datestamp(): Unknown time format: " & (aFormat as text) number 1
				
			end if
			
		end tell
		
	end tell
	
end timestamp