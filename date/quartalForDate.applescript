(*
Return an integer respresenting the quartal number for the given date.
*)

quartalForDate(current date)

on quartalForDate(aDate)
	
	set monthNumber to month of aDate as integer
	
	return ((monthNumber - 1) div 3) + 1
	
end quartalForDate