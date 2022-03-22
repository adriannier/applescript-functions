log formatBits(82)

log formatBits(142343)

log formatBits(123424945)

on formatBits(n)
	
	(* Converts bits as text with unit. *)
	
	set n2 to n div 8
	set n to n / 8
	
	if n2 < 1000 then
		return (n2 as text) & " bit"
	else if n2 < 1000000 then
		set n to n div 1000
		set s to "Kbit"
	else
		set n to n div 1000000
		set s to "Mbit"
	end if
	
	return (n as text) & " " & s
	
end formatSize