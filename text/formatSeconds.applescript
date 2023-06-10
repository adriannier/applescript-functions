set t to 0

repeat
	
	log formatSeconds(t)
	
	set t to t * 2
	if t is 0 then set t to 1
	if t > 1000000 then exit repeat
	
end repeat

on formatSeconds(secs)
	
	set h to secs div 3600
	set m to secs div 60 - h * 60
	set s to secs mod 60
	
	if s < 10 then set s to "0" & (s as text)
	if m < 10 then set m to "0" & (m as text)
	
	return (h as text) & ":" & (m as text) & ":" & (s as text)
	
end formatSeconds