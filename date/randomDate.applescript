log randomDateInRange((current date) - 10 * 365 * 24 * 60 * 60, (current date))

on randomDateInRange(minDate, maxDate)
	
	if minDate is false then set minDate to current date
	if maxDate is false then set maxDate to current date
	
	if minDate > maxDate then
		error "randomDate(): Minimum date needs to be the same as or later than maximum date"
	end if
	
	set secondSpan to maxDate - minDate
	set daySpan to secondSpan div 60 / 60 / 24
	set randomDays to random number from 0 to daySpan
	
	set randomDate to minDate + randomDays * 24 * 60 * 60
	set time of randomDate to 0
	
	return randomDate
	
end randomDateInRange