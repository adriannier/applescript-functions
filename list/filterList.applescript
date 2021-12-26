log filterList({"Alpha", "Bravo", "Charlie"}, "Alpha")
log filterList({"Alpha", "Bravo", "Charlie"}, "*l*")
log filterList({"Alpha", "Bravo", "Charlie"}, "b*")
log filterList({"Alpha", "Bravo", "Charlie"}, "*e")

on filterList(lst, filterString)
	
	(* Filters the specified list using the the filter string. *)
	
	try
		
		if filterString is "*" then
			return lst
			
		else if filterString starts with "*" and filterString ends with "*" then
			set filterType to "contains"
			try
				set filterString to text 2 thru -2 of filterString
			on error
				error "Invalid filter"
			end try
			
		else if filterString starts with "*" then
			set filterType to "ends"
			try
				set filterString to text 2 thru -1 of filterString
			on error
				error "Invalid filter"
			end try
			
		else if filterString ends with "*" then
			set filterType to "starts"
			try
				set filterString to text 1 thru -2 of filterString
			on error
				error "Invalid filter"
			end try
			
		else
			set filterType to "is"
			
		end if
		
		set buffer to {}
		
		if filterType is "contains" then
			
			repeat with i from 1 to count of lst
				if item i of lst contains filterString then set end of buffer to item i of lst
			end repeat
			
		else if filterType is "starts" then
			
			repeat with i from 1 to count of lst
				if item i of lst starts with filterString then set end of buffer to item i of lst
			end repeat
			
		else if filterType is "ends" then
			
			repeat with i from 1 to count of lst
				if item i of lst ends with filterString then set end of buffer to item i of lst
			end repeat
			
		else if filterType is "is" then
			
			repeat with i from 1 to count of lst
				if item i of lst is filterString then set end of buffer to item i of lst
			end repeat
			
		end if
		
		return buffer
		
	on error eMsg number eNum
		
		error "filterList: " & eMsg number eNum
		
	end try
	
end filterList