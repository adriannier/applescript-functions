(*
	Finds all services of the specified type on the local network and returns their host's name.
*)

-- Find AFP servers
log bonjourDiscovery("afpovertcp", 0.5)

-- Find SSH servers
log bonjourDiscovery("ssh", 0.5)


on bonjourDiscovery(aServiceType, aScanTime)
	
	-- Service types can be looked up at: http://www.dns-sd.org/ServiceTypes.html
	
	script BonjourDiscover
		
		property serviceType : aServiceType
		property scanTime : aScanTime
		
		property discoveryResults : {}
		property discoveredNames : {}
		
		on init()
			
			set discoveryResults to {}
			set discoveredNames to {}
			
		end init
		
		on discover()
			
			set discoveryResults to runDiscoveryScript()
			set discoveredNames to sortList(discoveredHostnames())
			
			return discoveredNames
			
		end discover
		
		on runDiscoveryScript()
			
			try
				-- Start the script
				set shellScript to {"#!/bin/bash"}
				
				-- Use the dns-sd tool to discover services
				set end of shellScript to "/usr/bin/dns-sd -B _" & serviceType & "._tcp local &"
				
				-- Keep track of the process id for the mDNS tool
				set end of shellScript to "mDNSpid=$!"
				
				-- Wait a little for mDNS to discover services
				set end of shellScript to "/bin/sleep " & (scanTime as text)
				
				-- Quit the mDNS tool
				set end of shellScript to "/bin/kill -HUP $mDNSpid"
				
				-- Compose the script
				set shellScript to joinList(shellScript, ASCII character 10)
				
				-- Run the script
				set discoverResult to do shell script shellScript
				
				-- Get the actual results without the header
				set discoverResults to paragraphs 5 thru -1 of discoverResult
				
				return discoverResults
				
			on error eMsg number eNum
				
				return {}
				
			end try
			
		end runDiscoveryScript
		
		on discoveredHostnames()
			
			set hostNames to {}
			
			set prvDlmt to text item delimiters
			set text item delimiters to ("_" & serviceType & "._tcp.")
			
			repeat with i from 1 to count of discoveryResults
				
				try
					set hostName to trim(text item 2 of (item i of discoveryResults))
					if hostName is not in hostNames then set end of hostNames to hostName
				end try
				
			end repeat
			
			set text item delimiters to prvDlmt
			
			return hostNames
			
		end discoveredHostnames
		
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
		
		on sortList(aList)
			
			set prvDlmt to text item delimiters
			set text item delimiters to ASCII character 10
			
			set tempText to aList as text
			
			set text item delimiters to prvDlmt
			
			try
				set sortedText to do shell script "/bin/echo " & quoted form of tempText & " | /usr/bin/sort"
			on error
				return aList
			end try
			
			set prvDlmt to text item delimiters
			set text item delimiters to ASCII character 13
			
			set sortedList to text items of sortedText
			
			set text item delimiters to prvDlmt
			
			return sortedList
			
		end sortList
		
		
	end script
	
	tell BonjourDiscover
		init()
		set discoverResult to discover()
	end tell
	
	
	return discoverResult
	
end discoverBonjourServicesOfType

