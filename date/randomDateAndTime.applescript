log randomDateAndTimeInRange((current date) - 10 * 365 * 24 * 60 * 60, (current date), 9 * 60 * 60, 17 * 60 * 60)

on randomDateAndTimeInRange(minDate, maxDate, minSeconds, maxSeconds)
	
	if minDate is false then set minDate to current date
	if maxDate is false then set maxDate to current date
	
	if minDate > maxDate then
		error "randomDate(): Minimum date needs to be the same as or later than maximum date"
	end if
	
	set secondSpan to maxDate - minDate
	set daySpan to secondSpan div 60 / 60 / 24
	set randomDays to random number from 0 to daySpan
	
	set randomDate to minDate + randomDays * 24 * 60 * 60
	
	set time of randomDate to random number from minSeconds to maxSeconds
	
	return randomDate
	
end randomDateAndTimeInRange