log formatSize(10)

log formatSize(1423)

log formatSize(1234245)

log formatSize(1.666E+9)

log formatSize(1.336E+12)

log formatSize(1.426E+15)

on formatSize(n)
	
	(* Converts a file size to text with unit. *)
	
	if n < 1000 then
		return (n as text) & " B"
	else if n < 1000000 then
		set n to n / 1000
		set s to "KB"
	else if n < 1.0E+9 then
		set n to n / 1000000
		set s to "MB"
	else if n < 1.0E+12 then
		set n to n / 1.0E+9
		set s to "GB"
	else if n < 1.0E+15 then
		set n to n / 1.0E+12
		set s to "TB"
	else
		set n to n / 1.0E+15
		set s to "EB"
	end if
	
	set p to 2
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
	
	return t & " " & s
	
end formatSize