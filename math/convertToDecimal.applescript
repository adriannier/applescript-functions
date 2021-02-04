(*
Convert a number in a different base to decimal.
*)

log convertToDecimal("FF", 16) -- Hexadecimal


on convertToDecimal(aValue, baseOfValue)

set valueComponents to characters of (aValue as string)
set valueComponents to reverse of valueComponents

set decimalValue to 0

repeat with i from 1 to count of valueComponents
	
	set char to item i of valueComponents
	
	set charNumber to ASCII number char
	
	if charNumber ≥ 65 and charNumber ≤ 90 then
		set v to charNumber - 55
	else
		set v to char as integer
	end if
	
	log v
	repeat i - 1 times
		set v to v * baseOfValue
	end repeat
	log v
	
	set decimalValue to decimalValue + v
	
end repeat

return decimalValue

end convertToDecimal