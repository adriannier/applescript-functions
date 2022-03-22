log filterList({"Alpha", "Bravo", "Charlie"}, "Alpha")
log filterList({"Alpha", "Bravo", "Charlie"}, "*l*")
log filterList({"Alpha", "Bravo", "Charlie"}, "b*")
log filterList({"Alpha", "Bravo", "Charlie"}, "*e")
log filterList({"Alpha", "Bravo", "Charlie"}, "A*a")
log filterList({"DeltaEchoFoxtrott", "Echo", "FoxtrottEcho", "EchoFoxtrott", "DeEcFox"}, "*Ec*Fo*")
log filterList({"Hello*World", "Hello**World"}, "*\\*\\**")

log "=========================== Testing negation"
log filterList({"Alpha", "Bravo", "Charlie"}, "!Alpha")
log filterList({"Alpha", "Bravo", "Charlie"}, "!*l*")
log filterList({"Alpha", "Bravo", "Charlie"}, "!b*")
log filterList({"Alpha", "Bravo", "Charlie"}, "!*e")
log filterList({"Alpha", "Bravo", "Charlie"}, "!A*a")
log filterList({"DeltaEchoFoxtrott", "Echo", "FoxtrottEcho", "EchoFoxtrott", "DeEcFox"}, "!*Ec*Fo*")
log filterList({"Hello*World", "Hello**World"}, "!*\\*\\**")

log "=========================== Testing multiple filters"
log filterList({"Alpha", "Bravo", "Charlie"}, {"!Alpha", "B*"})
log filterList({"Alpha", "Bravo", "Charlie"}, {"*a*", "*ie"})

log "=========================== Real world test"
log filterList({"ldns-1.8.1.tar.gz.sha256", "ldns-1.8.1.tar.gz.sha1", "ldns-1.8.1.tar.gz.asc", "ldns-1.8.1.tar.gz"}, {"ldns-*.tar.gz", "!ldns-snap*"})

on filterList(lst, filter)
	
	(* Filters a list by using the provided filter(s). *)
	
	(* Valid filter strings:
	
	"pattern": is pattern
	
	"*pattern*": contains pattern
	
	"pattern*": starts with pattern
	
	"*pattern": ends with pattern
	
	"pattern1*pattern2": starts with pattern 1 and ends with pattern 2
	
	"*pattern1*pattern2*": contains pattern 1 and pattern 2, pattern 2 must follow pattern 1
	
	¥ Negate filter string by prefixing with !: "!*pattern"
	¥ Escape regular asterisks using backslash: \\*
	¥ Filter can be a list of multiple filter strings
	
	*)
	
	try
		
		-- Special case: Empty list
		if lst is {} then return {}
		
		-- Handling multiple filters
		if class of filter is list then
			
			set buffer to lst
			
			repeat with i from 1 to count of filter
				
				if buffer is {} then exit repeat
				set buffer to filterList(buffer, item i of filter)
				
			end repeat
			
			return buffer
			
		end if
		
		
		-- Check for negation
		if filter is "!" then
			error "Invalid filter"
		else if filter starts with "!" then
			set filter to text 2 thru -1 of filter
			set filterNegation to true
		else
			set filterNegation to false
		end if
		
		-- Protect escaped asterisks
		set prvDlmt to text item delimiters
		set text item delimiters to "\\*"
		set filter to text items of filter
		set text item delimiters to "{{{PROTECTED_ASTERISK}}}"
		set filter to filter as text
		set text item delimiters to prvDlmt
		
		
		-- Special case: only asterisk
		if filter is "*" then
			if filterNegation then
				return {}
			else
				return lst
			end if
		end if
		
		-- Determine filter type and filter string(s)
		if filter starts with "*" and filter ends with "*" then
			set filterType to "contains"
			try
				set filter to text 2 thru -2 of filter
			on error
				error "Invalid filter"
			end try
			
		else if filter starts with "*" then
			set filterType to "ends"
			try
				set filter to text 2 thru -1 of filter
			on error
				error "Invalid filter"
			end try
			
		else if filter ends with "*" then
			set filterType to "starts"
			try
				set filter to text 1 thru -2 of filter
			on error
				error "Invalid filter"
			end try
			
		else
			set filterType to "is"
			
		end if
		
		-- Determine additional filter type
		set additionalFilterType to false
		if filter contains "*" then
			
			set additionalFilterType to "surrounded"
			
			set prvDlmt to text item delimiters
			set text item delimiters to "*"
			try
				if (count of text items in filter) is greater than 2 then
					error 1
				end if
				set filter2 to text item 2 of filter
				set filter to text item 1 of filter
			on error
				set filter to false
			end try
			set text item delimiters to prvDlmt
			
			if filter is false then
				error "Invalid filter; this function does not support more than one asterisk in the middle"
			end if
		end if
		
		-- Restore asterisks
		set prvDlmt to text item delimiters
		set text item delimiters to "{{{PROTECTED_ASTERISK}}}"
		set filter to text items of filter
		if additionalFilterType is not false then
			set filter2 to text items of filter2
		end if
		set text item delimiters to "*"
		set filter to filter as text
		if additionalFilterType is not false then
			set filter2 to filter2 as text
		end if
		set text item delimiters to prvDlmt
		
		-- Reset buffer
		set buffer to {}
		
		-- Perform filtering
		if filterType is "contains" then
			
			if additionalFilterType is false then
				
				if filterNegation then
					repeat with i from 1 to count of lst
						if item i of lst does not contain filter then set end of buffer to item i of lst
					end repeat
				else
					repeat with i from 1 to count of lst
						if item i of lst contains filter then set end of buffer to item i of lst
					end repeat
				end if
				
			else if additionalFilterType is "surrounded" then
				
				if filterNegation then
					
					repeat with i from 1 to count of lst
						
						set l to length of item i of lst
						set offset1 to offset of filter in (item i of lst)
						set offset2 to offset of filter2 in (item i of lst)
						
						if offset1 > 1 and offset2 < (l - (length of filter2) + 1) and (offset1 + (length of filter)) < offset2 then
							-- Do nothing; using negation
						else
							set end of buffer to item i of lst
						end if
						
					end repeat
					
				else
					
					repeat with i from 1 to count of lst
						
						set l to length of item i of lst
						set offset1 to offset of filter in (item i of lst)
						set offset2 to offset of filter2 in (item i of lst)
						
						if offset1 > 1 and offset2 < (l - (length of filter2) + 1) and (offset1 + (length of filter)) < offset2 then
							set end of buffer to item i of lst
						end if
						
					end repeat
					
				end if
				
			end if
			
		else if filterType is "starts" then
			
			if filterNegation then
				repeat with i from 1 to count of lst
					if item i of lst does not start with filter then set end of buffer to item i of lst
				end repeat
			else
				repeat with i from 1 to count of lst
					if item i of lst starts with filter then set end of buffer to item i of lst
				end repeat
			end if
			
		else if filterType is "ends" then
			
			if filterNegation then
				repeat with i from 1 to count of lst
					if item i of lst does not end with filter then set end of buffer to item i of lst
				end repeat
			else
				repeat with i from 1 to count of lst
					if item i of lst ends with filter then set end of buffer to item i of lst
				end repeat
			end if
			
		else if filterType is "is" and additionalFilterType is false then
			
			if filterNegation then
				repeat with i from 1 to count of lst
					if item i of lst is not filter then set end of buffer to item i of lst
				end repeat
			else
				repeat with i from 1 to count of lst
					if item i of lst is filter then set end of buffer to item i of lst
				end repeat
			end if
			
		else if additionalFilterType is "surrounded" then
			
			repeat with i from 1 to count of lst
				if item i of lst starts with filter and item i of lst ends with filter2 then
					set end of buffer to item i of lst
				end if
			end repeat
			
		end if
		
		return buffer
		
	on error eMsg number eNum
		
		error "filterList: " & eMsg number eNum
		
	end try
	
end filterList