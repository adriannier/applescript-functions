(*
Convert a number in a different base to decimal.
*)

log convertToDecimal("1111111", 2) -- Binary

log convertToDecimal("FF", 16) -- Hexadecimal

log convertToDecimal("22", 8) -- Octal

log convertToDecimal("SG", 36) -- Highest possible base

on convertToDecimal(aValue, baseOfValue)
	
	set valueComponents to characters of (aValue as string)
	set valueComponents to reverse of valueComponents
	
	set decimalValue to 0
	
	repeat with i from 1 to count of valueComponents
		
		set char to item i of valueComponents
		
		set charNumber to ASCII number char
		
		if charNumber ³ 65 and charNumber ² 90 then
			set v to charNumber - 55
		else
			set v to char as integer
		end if
		
		repeat i - 1 times
			set v to v * baseOfValue
		end repeat
		
		set decimalValue to decimalValue + v
		
	end repeat
	
	return decimalValue
	
end convertToDecimal