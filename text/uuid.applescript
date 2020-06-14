repeat 10 times
	log uuid()
end repeat

on uuid()
	
	(* Generate a UUID compliant with RFC 4122v4 *)
	
	set buffer to ""
	set chars to "0123456789ABCDEF"
	set charCount to length of chars
	
	repeat with i from 1 to 36
		
		if i is in {9, 14, 19, 24} then
			set buffer to buffer & "-"
		else if i is 15 then
			set buffer to buffer & "4"
		else if i is 20 then
			set buffer to buffer & character (random number from 1 to 4) of "89AB"
		else
			set buffer to buffer & character (random number from 1 to charCount) of chars
		end if
		
	end repeat
	
	return buffer
	
end uuid