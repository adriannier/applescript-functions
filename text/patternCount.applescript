(*
	Counts the occurrences of a text in another.
*)

patternCount(",", "abc, abc, abc, abc")

on patternCount(aPattern, aText)
	
	if aText does not contain aPattern then
	
		return 0
		
	else
		
		set prvDlmt to text item delimiters
		
		try
			set text item delimiters to aPattern
			set aPatternCount to (count of text items of aText) - 1
		on error
			set aPatternCount to 0
		end try
		
		set text item delimiters to prvDlmt
		
		return aPatternCount
		
	end if
	
end patternCount
