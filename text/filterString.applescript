log filterString("†ber einem schšnen BŠchlein", "abcdefghijklmnopqrstuvwxyz_ 0123456789")

on filterString(str, filterCharacters)
	
	(* Filters the specified characters from a string. *)
	
	try
		
		if str is "" then
			return ""
			
		else
			
			if class of filterCharacters is text then
				set filterCharacters to characters of filterCharacters
			end if
			
			if class of filterCharacters is not list then
				error "Please specify either a string or a list of characters to filter"
			end if
			
			set filteredString to ""
			repeat with i from 1 to length of str
				if character i of str is in filterCharacters then
					set filteredString to filteredString & character i of str
				end if
			end repeat
			
			
			return filteredString
			
		end if
		
	on error eMsg number eNum
		
		error "filter: " & eMsg number eNum
		
	end try
	
end filter