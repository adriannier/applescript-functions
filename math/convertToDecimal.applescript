log convertToDecimal("FF", 16) -- Hexadecimal

log convertToDecimal("ff", 16) -- Hexadecimal

log convertToDecimal("0A", 16) -- Hexadecimal

log convertToDecimal("0a", 16) -- Hexadecimal

on convertToDecimal(aValue, baseOfValue)
	
	(* Convert a number in a different base to decimal. *)
	
	set valueComponents to characters of (aValue as string)
	set valueComponents to reverse of valueComponents
	
	set decimalValue to 0
	
	repeat with i from 1 to count of valueComponents
		
		set char to item i of valueComponents
		
		set charNumber to id of char
		
		if charNumber ³ 65 and charNumber ² 90 then
			set v to charNumber - 55
			
		else if charNumber ³ 97 and charNumber ² 102 then
			set v to charNumber - 87
			
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