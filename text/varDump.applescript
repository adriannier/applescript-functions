log varDump({1, 2, 3})

log varDump({a:1, b:1, c:1})

log varDump(current date)

log varDump(path to home folder)

log varDump(0.3)

log varDump(true)

on varDump(var)

(* Returns the textual representation of a variable. *)
	
	try
		
		if class of var is list then
			item 0 of var
			
		else
			return var as text
			
		end if
		
	on error e
		
		if class of var is list then
			return text (offset of "{" in e) thru -2 of e
			
		else if class of var is record then
			return text (offset of "{" in e) thru -17 of e
			
		end if
		
		return missing value
		
	end try
	
end varDump
