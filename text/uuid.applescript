repeat 10 times
log uuid()
end

on uuid()
	
	set buffer to ""
	set chars to "0123456789ABCDEF"
	set dashPositions to {9, 14, 19, 24}
	set charCount to length of chars
	
	
	repeat with i from 1 to 36
		
		if i is in dashPositions then
			set buffer to buffer & "-"
		else
			set buffer to buffer & character (random number from 1 to charCount) of chars
		end if
		
	end repeat
	
	return buffer
	
end uuid