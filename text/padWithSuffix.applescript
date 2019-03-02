(* ### DESCRIPTION ###
Pads a text to the desired width by using the specified suffix. Should the text contain multiple paragraphs, each paragraph will be padded separately.

# Required parameters
Parameter 1 (text)
:-- The text to be padded.

Parameter 2 (integer)
:-- The new width of the text.

Parameter 3 (text)
:-- The suffix to use as padding.

*)

log padWithSuffix("@", 7, "-")

log padWithSuffix("Lots of" & return & "space to" & return & "the right", 20, " ")

on padWithSuffix(aText, newWidth, aSuffix)
	
	if (count of paragraphs of aText) > 1 then
		
		set nl to ASCII character 10
		
		-- Pad lines individually
		set newParagraphs to {}
		
		repeat with i from 1 to count of paragraphs of aText
			set end of newParagraphs to padWithSuffix(paragraph i of aText, newWidth, aSuffix)
		end repeat
		
				-- Join lines
		set prvDlmt to text item delimiters
		set text item delimiters to nl
		set aText to newParagraphs as text
		set text item delimiters to prvDlmt
		
	else
		
		-- Pad text to new width
		repeat newWidth - (count of aText) times
			set aText to aText & aSuffix
		end repeat
		
	end if
	
	return aText
		
end padWithSuffix