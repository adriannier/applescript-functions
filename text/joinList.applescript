(*
	Joins a list using the specified delimiter
*)

log joinList({1, 2, 3, 4, 5}, ASCII character 10)

log joinList({1, 2, 3, 4, 5}, false)

on joinList(aList, aDelimiter)
	
	if aDelimiter is false then set aDelimiter to ""
	
	set prvDlmt to text item delimiters
	set text item delimiters to aDelimiter
	
	set aList to aList as text
	
	set text item delimiters to prvDlmt
	
	return aList
	
end joinList