(*
Returns the week number of the specified date.
*)

weekNumberForDate(current date)

on weekNumberForDate(aDate)
	
	script weekNumberForDateHelper
		
		property targetDate : aDate
		
		on run
			
			-- Make a copy of the passed date object to avoid changes to the original
			copy targetDate to d
			
			-- Reset the time and go back to Monday
			set time of d to 0
			repeat until weekday of d is Monday
				set d to d - (24 * 60 * 60)
			end repeat
			
			-- Get the date of the first week for the current year and the next one
			set matchDate to dateOfFirstWeekForYear(year of d)
			set nextYearsFirstWeekDate to dateOfFirstWeekForYear((year of d) + 1)
			
			-- Exit early, if the current week is the first one of next year
			if d = nextYearsFirstWeekDate then return 1
			
			-- Count up until the target date is reached
			set weekNumber to 1
			repeat until d = matchDate
				set matchDate to matchDate + 604800 -- Add one week worth of seconds
				set weekNumber to weekNumber + 1
			end repeat
			
			return weekNumber
			
		end run
		
		on dateOfFirstWeekForYear(y)
			
			(*
				Returns the date of the Monday of the first week for the specified year
			*)
			
			-- Get start of year
			set d to current date
			set year of d to y
			set month of d to 1
			set day of d to 1
			set time of d to 0
			
			-- Get the first Thursday of this year
			repeat until weekday of d is Thursday
				set d to d + 86400 -- Add one day worth of seconds
			end repeat
			
			-- Return the Monday before
			set d to d - 259200 -- Subtract 3 days worth of seconds
			
			return d
			
		end dateOfFirstWeekForYear
		
	end script
	
	tell weekNumberForDateHelper to return run
	
end weekNumberForDate
