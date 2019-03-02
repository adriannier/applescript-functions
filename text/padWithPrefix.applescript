(*
Pads a text to the desired width by using the specified prefix. Should the text contain lines, each line will be padded separately.
*)

padWithPrefix("Hello
World
This
is
a
test", 30, " ")

on padWithPrefix(aText, newWidth, aPrefix)
	
	if (count of paragraphs of aText) > 1 then
		
		set nl to ASCII character 10
		
		-- Pad lines individually
		set newParagraphs to {}
		repeat with i from 1 to count of paragraphs of aText
			set end of newParagraphs to padWithPrefix(paragraph i of aText, newWidth, aPrefix)
		end repeat
		
		-- Join lines
		set prvDlmt to text item delimiters
		set text item delimiters to nl
		set aText to newParagraphs as text
		set text item delimiters to prvDlmt
		
	else
		
		-- Pad text to new width
		repeat newWidth - (count of aText) times
			set aText to aPrefix & aText
		end repeat
		
	end if
	
	return aText
	
end padWithPrefix
