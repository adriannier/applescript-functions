log splitString("1,2,3,4,5", ",")

log splitString("-a-b-c-d-e-f-g-h-", "-")

on splitString(aText, aDelimiter)
	
	(* Splits a string the specified delimiter *)
	
	if class of aText is not text then
		error "splitString(): Wrong data type" number 1
	end if
	
	set prvDlmt to text item delimiters
	set text item delimiters to aDelimiter
	
	set anOutput to text items of aText
	
	set text item delimiters to prvDlmt
	
	return anOutput
	
end splitString