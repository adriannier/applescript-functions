(*
	Looks up the network address and the port for the service of the specified type on the host with the specified name.
*)

log bonjourLookup("afpovertcp", "Mac001", 1.0)

log bonjourLookup("ssh", "Mac002", 1.0)

on bonjourLookup(aServiceType, aName, aScanTime)
	
	-- Service types can be looked up at: http://www.dns-sd.org/ServiceTypes.html
	
	script bonjourLookup
		
		property serviceType : aServiceType
		property computerName : aName
		property scanTime : aScanTime
		
		property lookupResult : ""
		
		on lookup()
			
			set lookupResult to runLookupScript()
			return addressAndPortFromLookupResult()
			
		end lookup
		
		on addressAndPortFromLookupResult()
			
			if lookupResult does not contain "can be reached at" then return {false, false}
			
			set prvDlmt to text item delimiters
			set text item delimiters to "can be reached at"
			
			set theAddress to text item 2 of lookupResult
			
			set text item delimiters to ":"
			set thePort to text item 2 of theAddress
			set theAddress to text item 1 of theAddress
			
			set text item delimiters to " "
			set thePort to text item 1 of thePort
			
			set text item delimiters to prvDlmt
			
			set theAddress to trim(theAddress)
			set thePort to trim(thePort)
			
			if character -1 of theAddress is "." then set theAddress to text 1 thru -2 of theAddress
			
			return {theAddress, thePort}
			
		end addressAndPortFromLookupResult
		
		on runLookupScript()
			
			try
				-- Start the script
				set shellScript to {"#!/bin/bash"}
				
				-- Use the dns-sd tool to discover services
				set end of shellScript to "/usr/bin/dns-sd -L " & quoted form of computerName & " _" & serviceType & "._tcp local &"
				
				-- Keep track of the process id for the mDNS tool
				set end of shellScript to "mDNSpid=$!"
				
				-- Wait a little for mDNS to discover services
				set end of shellScript to "sleep " & (scanTime as text)
				
				-- Quit the mDNS tool
				set end of shellScript to "kill -HUP $mDNSpid"
				
				-- Compose the script
				set shellScript to joinList(shellScript, ASCII character 10)
				
				-- Run the script
				set lookupResult to do shell script shellScript
				
				return lookupResult
				
			on error _eMsg number _eNum
				
				return ""
				
			end try
		end runLookupScript
		
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
					
					if start_WhiteSpaceEnd is not false and i ≤ (start_WhiteSpaceEnd + 1) then exit repeat
					
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
		
		on joinList(aList, aDelimiter)
			
			if aDelimiter is false then set aDelimiter to ""
			
			set prvDlmt to text item delimiters
			set text item delimiters to aDelimiter
			
			set aList to aList as text
			
			set text item delimiters to prvDlmt
			
			return aList
			
		end joinList
		
	end script
	
	tell bonjourLookup to return lookup()
	
end bonjourLookup