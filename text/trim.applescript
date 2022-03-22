if trim("Hello World!") is not "Hello World!" then
	error "Test 1 failed"
end if

if trim("   Hello World!     ") is not "Hello World!" then
	error "Test 2 failed"
end if

set ws to (ASCII character 8) & (ASCII character 9) & (ASCII character 10) & (ASCII character 9) & (ASCII character 13) & return

if trim("Hello World!" & ws) is not "Hello World!" then
	error "Test 3 failed"
end if

if trim(ws & "Hello World!") is not "Hello World!" then
	error "Test 4 failed"
end if

if trim(ws & "Hello World!" & ws) is not "Hello World!" then
	error "Test 5 failed"
end if

if trim("H                      ") is not "H" then
	error "Test 6 failed"
end if

if trim("                      W") is not "W" then
	error "Test 7 failed"
end if

if trim("") is not "" then
	error "Test 8 failed"
end if

if trim(" ") is not "" then
	error "Test 9 failed"
end if

if trim("  ") is not "" then
	error "Test 10 failed"
end if

if trim("x") is not "x" then
	error "Test 11 failed"
end if

if trim("x ") is not "x" then
	error "Test 12 failed"
end if

if trim("x  ") is not "x" then
	error "Test 13 failed"
end if

if trim(" x") is not "x" then
	error "Test 14 failed"
end if

if trim("  x") is not "x" then
	error "Test 15 failed"
end if

on trim(aText)
	
	(* Removes surrounding white space from a text. *)
	
	try
		
		if class of aText is not text then error "Wrong type."
		
		if length of aText is 0 then return ""
		
		----------------------------------------------------
		
		set start_WhiteSpaceEnd to false
		
		repeat with i from 1 to count of characters in aText
			
			set asc to ASCII number character i of aText
			if asc > 32 and asc is not 202 then
				exit repeat
			else
				set start_WhiteSpaceEnd to i
			end if
			
		end repeat
		
		----------------------------------------------------
		
		set end_WhiteSpaceStart to false
		
		set i to count of characters in aText
		
		repeat
			
			if start_WhiteSpaceEnd is not false and i ² (start_WhiteSpaceEnd + 1) then exit repeat
			
			set asc to ASCII number character i of aText
			
			if asc > 32 and asc is not 202 then
				exit repeat
			else
				set end_WhiteSpaceStart to i
			end if
			
			set i to i - 1
			
		end repeat
		
		----------------------------------------------------
		
		if start_WhiteSpaceEnd is false and end_WhiteSpaceStart is false then
			return aText
			
		else if start_WhiteSpaceEnd is not false and end_WhiteSpaceStart is false then
			try
				return text (start_WhiteSpaceEnd + 1) thru -1 of aText
			on error
				return ""
			end try
			
		else if start_WhiteSpaceEnd is false and end_WhiteSpaceStart is not false then
			return text 1 thru (end_WhiteSpaceStart - 1) of aText
			
		else if start_WhiteSpaceEnd is not false and end_WhiteSpaceStart is not false then
			return text (start_WhiteSpaceEnd + 1) thru (end_WhiteSpaceStart - 1) of aText
			
		end if
		
	on error eMsg number eNum
		
		log "trim: " & eMsg & " (" & (eNum as text) & ")"
		error "trim: " & eMsg number eNum
		
	end try
	
end trim