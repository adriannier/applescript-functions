set str to randomString(64)

set the clipboard to str

on randomString(stringSize)
	
	(* Generate a UUID compliant with RFC 4122v4 *)
	
	set disabled to "!|l0OI12Z5S8B"
	set allowed to "!#$%&()+,-./0123456789:;=?@ABCDEFGHIJKLMNOPQRSTUVWXYZ[]^abcdefghijklmnopqrstuvwxyz{|}~"
	
	set allowedCount to count of allowed
	set buffer to ""
	repeat
		
		repeat
			set thisChar to character (random number from 1 to allowedCount) of allowed
			if thisChar is not in disabled then exit repeat
		end repeat
		
		set buffer to buffer & thisChar
		if (count of buffer) is greater than or equal to stringSize then exit repeat
		
	end repeat
	
	return buffer
	
end randomString