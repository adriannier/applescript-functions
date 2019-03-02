(*
Converts text to lower case.
*)

lowercaseText("Hello World!")

on lowercaseText(aText)
	
	-- Define character sets
	set lowercaseCharacters to "abcdefghijklmnopqrstuvwxyz"
	set uppercaseCharacters to "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
	set lowercaseSpecialCharacters to {138, 140, 136, 139, 135, 137, 190, 141, 142, 144, 145, 143, 146, 148, 149, 147, 150, 154, 155, 151, 153, 152, 207, 159, 156, 158, 157, 216}
	set uppercaseSpecialCharacters to {128, 129, 203, 204, 231, 229, 174, 130, 131, 230, 232, 233, 234, 235, 236, 237, 132, 133, 205, 238, 239, 241, 206, 134, 242, 243, 244, 217}
	
	-- Convert comma seperated strings into a list
	set lowercaseCharacters to characters of lowercaseCharacters
	set uppercaseCharacters to characters of uppercaseCharacters
	
	-- Add special characters to the character lists
	repeat with i from 1 to count of lowercaseSpecialCharacters
		set end of lowercaseCharacters to ASCII character (item i of lowercaseSpecialCharacters)
	end repeat
	repeat with i from 1 to count of uppercaseSpecialCharacters
		set end of uppercaseCharacters to ASCII character (item i of uppercaseSpecialCharacters)
	end repeat
	
	set prvDlmt to text item delimiters
	
	-- Loop through every upper case character
	repeat with i from 1 to count of uppercaseCharacters
	
		considering case
		
			if aText contains (item i of uppercaseCharacters) then
			
				-- Delimit string by upper case character
				set text item delimiters to (item i of uppercaseCharacters)
				set tempList to text items of aText
				-- Join list by lower case character
				set text item delimiters to (item i of lowercaseCharacters)
				set aText to tempList as text
				
			end if
			
		end considering
		
	end repeat
	
	set text item delimiters to prvDlmt
	
	return aText
	
end lowercaseText