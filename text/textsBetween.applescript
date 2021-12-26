textsBetween("<a href=\"a\"></a><a href=\"b\"></a><a href=\"c\"></a><a href=\"  \"", "<a href=\"", "\"")

on textsBetween(str, a, b)
	
	(* Returns substrings between a start string and an end string *)
	
	try
		
		set aLength to length of a
		set bLength to length of b
		set buffer to str
		set matches to {}
		
		repeat
			
			set aOffset to offset of a in buffer
			
			if aOffset is 0 then
				
				-- No more matches for a
				exit repeat
				
			else
				
				try
					set buffer to text (aOffset + aLength) thru -1 of buffer
				on error
					-- End of string
					set buffer to ""
				end try
				
				set bOffset to offset of b in buffer
				
				if bOffset is 0 then
					
					-- No more matches for b
					exit repeat
					
				else
					
					if bOffset is 1 then
						-- Empty string
						set match to ""
					else
						set match to text 1 thru (bOffset - 1) of buffer
					end if
					
					set end of matches to match
					
					try
						set buffer to text (bOffset + bLength) thru -1 of buffer
					on error
						-- End of string
						set buffer to ""
					end try
					
				end if
				
			end if
			
		end repeat
		
		
		return matches
		
	on error eMsg number eNum
		
		error "textsBetween: " & eMsg number eNum
		
	end try
	
end textsBetween
