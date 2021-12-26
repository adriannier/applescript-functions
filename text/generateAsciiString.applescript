generateAsciiString()

on generateAsciiString()

	(* Generates a string containing visible ASCII characters from 33 to 255 *)
	
	set buffer to ""
	
	repeat with i from 33 to 255
		set buffer to buffer & (ASCII character i)
	end repeat
	
	return buffer
	
end generateAsciiString