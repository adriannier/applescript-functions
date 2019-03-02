(*
	Returns the AppleScript month constant for a text like "Jan", "January", "Oct", or "October."
*)

stringToMonthConstant("Dec")

stringToMonthConstant("Mar")

on stringToMonthConstant(str)
	
	set shortMonthNames to {"Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"}
	set longMonthNames to {"January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"}
	
	if str is in shortMonthNames or str is in longMonthNames then
		
		repeat with monthNumber from 1 to 12
			
			if str is (item monthNumber of shortMonthNames) or str is (item monthNumber of longMonthNames) then
				
				set theDate to current date
				set month of theDate to monthNumber
				return month of theDate
				
			end if
			
		end repeat
		
	end if
	
	return false
	
end stringToMonthConstant