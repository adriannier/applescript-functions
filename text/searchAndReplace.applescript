searchAndReplace("Wello world?", {"W", "w", "?"}, {"H", "W", "!"})

searchAndReplace("A valid file/directory name contains no :", {":", "/", "\\"}, {"-", "-", "-"})

on searchAndReplace(aText, aPattern, aReplacement)
	
	(*	Search for a pattern and replace it in a string. Pattern and replacement can be a list of multiple values. *)
	
	if (class of aPattern) is list and (class of aReplacement) is list then
		
		-- Replace multiple patterns with a corresponding replacement
		
		-- Check patterns and replacements count
		if (count of aPattern) is not (count of aReplacement) then
			error "The count of patterns and replacements needs to match."
		end if
		
		-- Process matching list of patterns and replacements
		repeat with i from 1 to count of aPattern
			set aText to searchAndReplace(aText, item i of aPattern, item i of aReplacement)
		end repeat
		
		return aText
		
	else if class of aPattern is list then
		
		-- Replace multiple patterns with the same text
		
		repeat with i from 1 to count of aPattern
			set aText to searchAndReplace(aText, item i of aPattern, aReplacement)
		end repeat
		
		return aText
		
	else
		
		
		if aText does not contain aPattern then
			
			return aText
			
		else
			
			set prvDlmt to text item delimiters
			
			-- considering case
			
			try
				set text item delimiters to aPattern
				set tempList to text items of aText
				set text item delimiters to aReplacement
				set aText to tempList as text
			end try
			
			--	end considering
			
			set text item delimiters to prvDlmt
			
			return aText
			
		end if
		
	end if
	
end searchAndReplace
