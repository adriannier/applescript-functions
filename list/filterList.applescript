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

on filterList(lst, filterString)
	
	(* Filters the specified list using the filter string. *)
	
	-- Valid filter strings:
	-- "*pattern*": contains pattern
	-- "pattern*": starts with pattern
	-- "*pattern": ends with pattern
	-- "pattern1*pattern2": starts with pattern 1 and ends with pattern 2
	-- "*pattern1*pattern2*": contains pattern 1 and pattern 2, pattern 2 must follow pattern 1
	
	-- Negate filter string by prefixing with !: "!*pattern"
	-- Escape regular asterisks using backslash: \\*
	
	try
		
		-- Check for negation
		if filterString is "!" then
			error "Invalid filter"
		else if filterString starts with "!" then
			set filterString to text 2 thru -1 of filterString
			set filterNegation to true
		else
			set filterNegation to false
		end if
		
		-- Protect escaped asterisks
		set prvDlmt to text item delimiters
		set text item delimiters to "\\*"
		set filterString to text items of filterString
		set text item delimiters to "{{{PROTECTED_ASTERISK}}}"
		set filterString to filterString as text
		set text item delimiters to prvDlmt
		
		
		-- Special case: only asterisk
		if filterString is "*" then
			if filterNegation then
				return {}
			else
				return lst
			end if
		end if
		
		-- Determine filter type and filter string(s)
		if filterString starts with "*" and filterString ends with "*" then
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
		
		-- Determine additional filter type
		set additionalFilterType to false
		if filterString contains "*" then
			
			set additionalFilterType to "surrounded"
			
			set prvDlmt to text item delimiters
			set text item delimiters to "*"
			try
				if (count of text items in filterString) is greater than 2 then
					error 1
				end if
				set filterString2 to text item 2 of filterString
				set filterString to text item 1 of filterString
			on error
				set filterString to false
			end try
			set text item delimiters to prvDlmt
			
			if filterString is false then
				error "Invalid filter; this function does not support more than one asterisk in the middle"
			end if
		end if
		
		-- Restore asterisks
		set prvDlmt to text item delimiters
		set text item delimiters to "{{{PROTECTED_ASTERISK}}}"
		set filterString to text items of filterString
		if additionalFilterType is not false then
			set filterString2 to text items of filterString2
		end if
		set text item delimiters to "*"
		set filterString to filterString as text
		if additionalFilterType is not false then
			set filterString2 to filterString2 as text
		end if
		set text item delimiters to prvDlmt
		
		-- Reset buffer
		set buffer to {}
		
		-- Perform filtering
		if filterType is "contains" then
			
			if additionalFilterType is false then
				
				if filterNegation then
					repeat with i from 1 to count of lst
						if item i of lst does not contain filterString then set end of buffer to item i of lst
					end repeat
				else
					repeat with i from 1 to count of lst
						if item i of lst contains filterString then set end of buffer to item i of lst
					end repeat
				end if
				
			else if additionalFilterType is "surrounded" then
				
				if filterNegation then
					
					repeat with i from 1 to count of lst
						
						set l to length of item i of lst
						set offset1 to offset of filterString in (item i of lst)
						set offset2 to offset of filterString2 in (item i of lst)
						
						if offset1 > 1 and offset2 < (l - (length of filterString2) + 1) and (offset1 + (length of filterString)) < offset2 then
							-- Do nothing; using negation
						else
							set end of buffer to item i of lst
						end if
						
					end repeat
					
				else
					
					repeat with i from 1 to count of lst
						
						set l to length of item i of lst
						set offset1 to offset of filterString in (item i of lst)
						set offset2 to offset of filterString2 in (item i of lst)
						
						if offset1 > 1 and offset2 < (l - (length of filterString2) + 1) and (offset1 + (length of filterString)) < offset2 then
							set end of buffer to item i of lst
						end if
						
					end repeat
					
				end if
				
			end if
			
		else if filterType is "starts" then
			
			if filterNegation then
				repeat with i from 1 to count of lst
					if item i of lst does not start with filterString then set end of buffer to item i of lst
				end repeat
			else
				repeat with i from 1 to count of lst
					if item i of lst starts with filterString then set end of buffer to item i of lst
				end repeat
			end if
			
		else if filterType is "ends" then
			
			if filterNegation then
				repeat with i from 1 to count of lst
					if item i of lst does not end with filterString then set end of buffer to item i of lst
				end repeat
			else
				repeat with i from 1 to count of lst
					if item i of lst ends with filterString then set end of buffer to item i of lst
				end repeat
			end if
			
		else if filterType is "is" and additionalFilterType is false then
			
			if filterNegation then
				repeat with i from 1 to count of lst
					if item i of lst is not filterString then set end of buffer to item i of lst
				end repeat
			else
				repeat with i from 1 to count of lst
					if item i of lst is filterString then set end of buffer to item i of lst
				end repeat
			end if
			
		else if additionalFilterType is "surrounded" then
			
			repeat with i from 1 to count of lst
				if item i of lst starts with filterString and item i of lst ends with filterString2 then
					set end of buffer to item i of lst
				end if
			end repeat
			
		end if
		
		return buffer
		
	on error eMsg number eNum
		
		error "filterList: " & eMsg number eNum
		
	end try
	
end filterList