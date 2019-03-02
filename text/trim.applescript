(*
Removes surrounding white space from a text.
*)

log trim("Hello World!")

log trim("   Hello World!     ")

set ws to (ASCII character 9) & (ASCII character 10) & (ASCII character 9)

log trim("Hello World!" & ws)

log trim(ws & "Hello World!")

log trim(ws & "Hello World!" & ws)

log trim("H                      ")

log trim("                      W")

on trim(aText)
	
	(* Strips a text of its surrounding white space. *)
	
	try
		
		if class of aText is not text then error "Wrong type."
		
		if length of aText is 0 then return ""
		
		----------------------------------------------------
		
		set start_WhiteSpaceEnd to false
		
		repeat with i from 1 to count of characters in aText
			
			if (ASCII number (character i of aText)) > 32 and (ASCII number (character i of aText)) is not 202 then
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
			
			if (ASCII number (character i of aText)) > 32 and (ASCII number (character i of aText)) is not 202 then
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
			return text (start_WhiteSpaceEnd + 1) thru -1 of aText
			
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