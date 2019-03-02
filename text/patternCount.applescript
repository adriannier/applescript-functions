(*
	Counts the occurrences of a text in another.
*)

patternCount("abc", "abc, ABC, abc, abc", true)

on patternCount(aPattern, aText, caseSensitive)
	
	set theCount to 0
	
	if caseSensitive then
		
		considering case
			
			if aText contains aPattern then
				
				set prvDlmt to text item delimiters
				
				try
					set text item delimiters to aPattern
					set theCount to (count of text items of aText) - 1
				end try
				
				set text item delimiters to prvDlmt
				
			end if
			
		end considering
		
	else
		
		if aText contains aPattern then
			
			set prvDlmt to text item delimiters
			
			try
				set text item delimiters to aPattern
				set theCount to (count of text items of aText) - 1
			end try
			
			set text item delimiters to prvDlmt
			
		end if
		
	end if
	
	return theCount
	
end patternCount
