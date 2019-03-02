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
	
	
	(*
	
	Copyright (C) 2014 by Adrian Nier (http://adriannier.de/code)
	
	Permission is hereby granted, free of charge, to any person obtaining a copy of 
	this software and associated documentation files (the "Software"), to deal in the
	Software without restriction, including without limitation the rights to use, copy, 
	modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, 
	and to permit persons to whom the Software is furnished to do so, subject to the 
	following conditions:
	
	The above copyright notice and this permission notice shall be included in all 
	copies or substantial portions of the Software.
	
	THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, 
	EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF 
	MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. 
	IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY 
	CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, 
	TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE 
	SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
	
	*)
	
end padWithSuffix
-- ### END ###