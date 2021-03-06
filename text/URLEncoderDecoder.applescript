(*
	Uses PHP to encode/decode a URL.
*)

tell URLEncoderDecoder
	
	set s to urlencode("😝 Hello World! 😝  \"\\'; http://www.apple.com  \"asdf\" \\'\\\\()")
	log s
	
	log urldecode(s)
	
end tell

script URLEncoderDecoder
	
	property ASCII_NUMBERS_OF_SPECIAL_CHARACTERS : {92, 39} -- backslash, single quote
	property ASCII_NUMBERS_OF_UNWANTED_CHARACTERS : {0, 1, 2, 3, 4, 5, 6, 7, 8, 11, 12, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 127}
	
	on urlencode(s)
		
		try
			
			set s to removeUnwantedASCIICharacters(s)
			set s to protectSpecialCharacters(s)
			set phpScript to "echo urlencode(" & quoted form of s & ");"
			set s to do shell script "/usr/bin/php -r " & quoted form of phpScript
			return s
			
		on error eMsg number eNum
			error "Error while trying to urlencode: \"" & s & "\": " & eMsg number eNum
		end try
		
	end urlencode
	
	on urldecode(s)
		
		try
			
			set phpScript to "echo urldecode(" & quoted form of s & ");"
			set s to do shell script "/usr/bin/php -r " & quoted form of phpScript
			set s to restoreSpecialCharacters(s)
			return s
			
		on error eMsg number eNum
			error "Error while trying to urldecode: \"" & s & "\": " & eMsg number eNum
		end try
		
	end urldecode
	
	
	on protectSpecialCharacters(s)
		
		repeat with i from 1 to count of my ASCII_NUMBERS_OF_SPECIAL_CHARACTERS
			set s to snr(s, ASCII character (item i of my ASCII_NUMBERS_OF_SPECIAL_CHARACTERS), "\\a" & pad(item i of my ASCII_NUMBERS_OF_SPECIAL_CHARACTERS as text, 3, "0"))
		end repeat
		return s
		
	end protectSpecialCharacters
	
	on restoreSpecialCharacters(s)
		
		repeat with i from 1 to count of my ASCII_NUMBERS_OF_SPECIAL_CHARACTERS
			set s to snr(s, "\\a" & pad(item i of my ASCII_NUMBERS_OF_SPECIAL_CHARACTERS as text, 3, "0"), ASCII character (item i of my ASCII_NUMBERS_OF_SPECIAL_CHARACTERS))
		end repeat
		return s
		
	end restoreSpecialCharacters
	
	on removeUnwantedASCIICharacters(s)
		
		repeat with i from 1 to count of my ASCII_NUMBERS_OF_UNWANTED_CHARACTERS
			if s contains (ASCII character (item i of my ASCII_NUMBERS_OF_UNWANTED_CHARACTERS)) then
				set s to snr(s, ASCII character (item i of my ASCII_NUMBERS_OF_UNWANTED_CHARACTERS), "")
			end if
			
		end repeat
		
		return s
		
	end removeUnwantedASCIICharacters
	
	on pad(aText, newWidth, aPrefix)
		
		repeat newWidth - (count of aText) times
			set aText to aPrefix & aText
		end repeat
		
		return aText
		
	end pad
	
	on snr(aText, pattern, replacement)
		
		set replacement to replacement as text
		
		if class of pattern is list then
			repeat with i from 1 to count of pattern
				set aText to snr(aText, item i of pattern, replacement)
			end repeat
			
			return aText
		end if
		
		if aText does not contain pattern then return aText
		
		set prvDlmt to text item delimiters
		try
			set text item delimiters to pattern
			set aTextItems to text items of aText
			set text item delimiters to replacement
			set aText to aTextItems as text
		end try
		set text item delimiters to prvDlmt
		
		return aText
		
	end snr
	
end script