if RomanConverter's isNumeral("lil") is true then
	error "Test 1 failed"
end if

repeat with n from 1 to 3999
	
	try
		set numeral to RomanConverter's toNumeral(n)
	on error
		error "Failed to convert " & (n as text) & " to numeral"
	end try
	
	try
		set int to RomanConverter's toInteger(numeral)
	on error
		error "Failed to convert " & numeral & " to integer"
	end try
	
end repeat

script RomanConverter
	
	(* Convert between integers and Roman numerals *)
	
	on isNumeral(input)
		
		try
			toInteger(input)
			return true
		on error
			return false
		end try
		
	end isNumeral
	
	on toNumeral(input)
		
		if class of input is not integer then
			error "RomanConverter: Invalid input type: " & ((class of input) as text) & "." number 1000
		end if
		
		if input < 1 or input > 3999 then
			error "RomanConverter: Invalid input: " & (input as text) & ". Only numbers from 1 to 3999 can be represented by Roman numerals." number 1001
		end if
		
		set symbols to {"", "C", "CC", "CCC", "CD", "D", "DC", "DCC", "DCCC", "CM", Â
			"", "X", "XX", "XXX", "XL", "L", "LX", "LXX", "LXXX", "XC", Â
			"", "I", "II", "III", "IV", "V", "VI", "VII", "VIII", "IX"}
		
		set roman to ""
		set inputTxt to input as text
		set inputPos to length of inputTxt
		repeat with i from 2 to 0 by -1
			
			set inputSlice to (character inputPos of inputTxt) as integer
			set symbolNumber to inputSlice + (i * 10) + 1
			
			try
				set symbol to item symbolNumber of symbols
			on error
				set symbol to ""
			end try
			set roman to symbol & roman
			
			set inputPos to inputPos - 1
			if inputPos is 0 then exit repeat
			
		end repeat
		
		try
			set inputRemainder to (text 1 thru inputPos of inputTxt) as integer
			repeat inputRemainder times
				set roman to "M" & roman
			end repeat
		end try
		
		return roman
		
	end toNumeral
	
	on toInteger(input)
		
		if class of input is not text then
			error "RomanConverter: Invalid input text: " & ((class of input) as text) & "." number 1000
		end if
		
		set inputLen to count of input
		set sum to 0
		repeat with i from 1 to inputLen
			
			try
				
				set val to _charToInteger(item i of input)
				
				if (i + 1) ² inputLen and _charToInteger(item (i + 1) of input) > val then
					set sum to sum - val
				else
					set sum to sum + val
				end if
				
			on error eMsg number eNum
				
				if eNum is 1002 then
					error "RomanConverter: Invalid Roman numeral: " & input number eNum
				end if
				
				error eMsg number eNum
				
			end try
			
		end repeat
		
		if toNumeral(sum) is not input then
			error "RomanConverter: Invalid input: " & input number 1003
		end if
		
		return sum
		
	end toInteger
	
	on _charToInteger(char)
		
		if char is "M" then
			return 1000
		else if char is "D" then
			return 500
		else if char is "C" then
			return 100
		else if char is "L" then
			return 50
		else if char is "X" then
			return 10
		else if char is "V" then
			return 5
		else if char is "I" then
			return 1
		else
			error "Invalid char" number 1002
		end if
		
	end _charToInteger
	
end script

