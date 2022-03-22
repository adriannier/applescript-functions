log convertFromDecimal(127, 2) -- Binary

log convertFromDecimal(255, 16) -- Hex

log convertFromDecimal(18, 8) -- Octal

log convertFromDecimal(1024, 36) -- Highest possible base

on convertFromDecimal(aValue, targetBase)

(* Converts a decimal number to the specified base. *)
	
	if targetBase > 36 then error "Invalid target base." number 1
	
	set prvDlmt to text item delimiters
	set text item delimiters to ""
	
	if aValue is not "" then
		
		set theDiv to 1
		set targetValue to ""
		
		repeat until theDiv is 0
			
			set preliminaryDiv to aValue / targetBase
			
			set theDiv to round preliminaryDiv rounding down
			set rem to round (preliminaryDiv - theDiv) * targetBase
			
			if rem is greater than 9 then
				
				set c to ASCII character (65 + rem - 10)
				set targetValue to c & targetValue as text
				
			else
				
				set targetValue to rem & targetValue as text
				
			end if
			
			set aValue to theDiv
			
		end repeat
		
	else
		
		set targetValue to ""
		
	end if
	
	set text item delimiters to prvDlmt
	
	return targetValue
	
end convertFromDecimal