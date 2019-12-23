(*
	Converts a number to text
*)

log formatNumber(10, 2)

log formatNumber(1.234, 1)

on formatNumber(n, p)
	
	set n to round (n * (10 ^ p))
	set t to n / (10 ^ p) as text
	
	try
		set x to "1.2" as number
		set decimalPoint to "."
	on error
		try
			set x to "1,2" as number
			set decimalPoint to ","
		end try
	end try
	
	set decimalPointOffset to offset of decimalPoint in t
	set positionFromEnd to (length of t) - decimalPointOffset
	
	set missingZeroes to p - positionFromEnd
	
	
	repeat missingZeroes times
		
		set t to t & "0"
	end repeat
	
	
	return t
	
end formatNumber