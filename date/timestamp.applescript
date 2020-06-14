set exampleDate to current date
copy {1993, 4, 10, 10 * 60 * 60 + 120 + 42} to {year of exampleDate, day of exampleDate, month of exampleDate, time of exampleDate}

-- 1993-10-04 10:02:42
log timestamp(exampleDate, 1)

-- 1993-10-04_10-02-42
log timestamp(exampleDate, 2)

-- Oct 4 10:02:42
log timestamp(exampleDate, 3)

-- 19931004T100242
log timestamp(exampleDate, 4)

-- 19931004100242
log timestamp(exampleDate, 5)

on timestamp(aDate as date, aFormat)
	
	(*
	
		With big thanks to CK (twitter.com/AppleScriptive) for pointing out «class isot»
		
		Returns the specified date and time as a string
		
		Formats:
		
		1: 2000-01-28 23:15:59 -- For log files
		
		2: 2000-01-28_23-15-59 -- For file names
		
		3: Jan 28 23:15:59 -- For log files (shorter)
		
		4: 20000128T231559 -- RFC3339 / iCalendar local time
		
		5: 20000128231559 -- Digits only
			
	*)
	
	tell aDate as «class isot» as string
		
		tell contents
			
			if aFormat is 1 then
				
				return text 1 thru 10 & " " & text 12 thru -1
				
			else if aFormat is 2 then
				
				return text 1 thru 4 & "-" & text 6 thru 7 & "-" & text 9 thru 10 & "_" & text 12 thru 13 & "-" & text 15 thru 16 & "-" & text 18 thru 19
				
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