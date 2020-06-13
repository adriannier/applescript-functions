repeat with y from 1900 to 2099
	
	log easterDate(y, 0)
	
end repeat

on easterDate(yearNumber, dayOffset)
	
	(*
	    Calculate a date relative to Easter Sunday
	    
	    1. Parameter: Integer: 4-digit year number from 1900 to 2099
	    2. Parameter: - Integer: representing the day offset from Easter Sunday
	                  - String: One of the following strings
	                    - "Ash Wednesday"
						- "Good Friday"
						- "Easter Sunday"
	                    - "Easter Monday"
						- "Ascension Day"
						- "Whit Monday"
						- "Corpus Christi"
						
		Disclaimer: The purpose of this function is to calculate holidays
		            in respect to commercial opening hours. This is in no
					way an endorsement for any religion or condoning of
					crimes committed by any religion.
		
	*)
	
	if yearNumber < 1900 or yearNumber > 2099 then
		
		error "This function can only calculate easter dates for years 1900 through 2099."
		
	else
		
		if dayOffset is "Easter Sunday" then
			set dayOffset to 0
		else if dayOffset is "Ash Wednesday" then
			set dayOffset to -46
		else if dayOffset is "Good Friday" then
			set dayOffset to -2
		else if dayOffset is "Easter Monday" then
			set dayOffset to 1
		else if dayOffset is "Ascension Day" then
			set dayOffset to 39
		else if dayOffset is "Whit Monday" then
			set dayOffset to 50
		else if dayOffset is "Corpus Christi" then
			set dayOffset to 60
		end if
		
		-- Source: http://www.maa.clell.de/StarDate/feiertage.html
		
		set a to yearNumber mod 19
		set b to yearNumber mod 4
		set c to yearNumber mod 7
		
		set d to (19 * a + 24) mod 30
		set e to (2 * b + 4 * c + 6 * d + 5) mod 7
		
		set easterDay to 22 + d + e
		set easterMonth to 3
		
		if easterDay > 31 then
			set easterDay to d + e - 9
			set easterMonth to 4
		end if
		
		if easterDay = 26 and easterMonth = 4 then
			set easterDay to 19
		end if
		
		if easterDay = 25 and easterMonth = 4 and d = 28 and e = 6 and a > 10 then
			set easterDay to 18
		end if
		
		set newDate to current date
		set year of newDate to yearNumber
		set day of newDate to 1
		set month of newDate to easterMonth
		set day of newDate to easterDay
		set time of newDate to 0
		
		if dayOffset is not 0 then
			set dateOffset to dayOffset * 24 * 60 * 60
			set newDate to newDate + dateOffset
		end if
		
		return newDate
		
	end if
	
end easterDate
