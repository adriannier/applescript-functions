log bitwiseAnd(655360, 131072)

log bitwiseAnd(655360, 524288)

log bitwiseAnd(655360, 1048576)

on bitwiseAnd(integer1, integer2)
	
	(* Compares two integers as bitwise AND *)
	
	set int1 to integer1
	set int2 to integer2
	set theResult to 0
	
	repeat with bitOffset from 30 to 0 by -1
	
		if int1 div (2 ^ bitOffset) = 1 and int2 div (2 ^ bitOffset) = 1 then
			set theResult to theResult + 2 ^ bitOffset
		end if
		
		set int1 to int1 mod (2 ^ bitOffset)
		set int2 to int2 mod (2 ^ bitOffset)
		
	end repeat
	
	return (theResult as integer) = integer2
	
end bitwiseAnd