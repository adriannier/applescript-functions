(*
	Sorts a list.
*)

log sortList({5, 2, 1, 3, 50})

log sortList({"Z", "A", "R", "F", "M"})

on sortList(aList)
	
	set prvDlmt to text item delimiters
	set text item delimiters to ASCII character 10
	
	set tempText to aList as text
	
	set text item delimiters to prvDlmt
	
	try
		set sortedText to do shell script "/bin/echo " & quoted form of tempText & " | /usr/bin/sort"
	on error
		return aList
	end try
	
	set prvDlmt to text item delimiters
	set text item delimiters to ASCII character 13
	
	set sortedList to text items of sortedText
	
	set text item delimiters to prvDlmt
	
	return sortedList
	
end sortList