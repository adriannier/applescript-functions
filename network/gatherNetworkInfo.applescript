
on run
	repeat
		log (word 1 of speedDownloadBitReadout of statistics of gatherNetworkInfo())
	end repeat
	delay 1
end run

on gatherNetworkInfo()
	
	script InterfacesLister
		
		property kWanAddressQuery : "https://tools.adriannier.de/network/current-ip"
		property kEmptyAddress : "https://tools.adriannier.de/test/empty"
		property kDataAddress : "https://tools.adriannier.de/test/data?size=10000000"
		
		property kInterfacesTemplate : {wanAddress:missing value, defaultRoute:{deviceName:missing value, networkName:missing value, portName:missing value, serviceName:missing value}, interfaces:missing value, statistics:missing value}
		
		property kInterfaceTemplate : {order:missing value, serviceName:missing value, portName:missing value, deviceName:missing value, ethernetAddress:missing value, ipAddress:missing value, subnetMask:missing value, router:missing value, dnsServers:missing value, networkName:missing value}
		
		property pBuffer : ""
		property pCurrentInterface : missing value
		
		on run
			
			copy kInterfacesTemplate to interfacesData
			
			set hardwarePorts to gatherPorts()
			--			return gatherStats()
			set statistics of interfacesData to gatherTransferStats()
			set wanAddress of interfacesData to gatherWAN()
			set defaultRouteDeviceName to gatherDefaultRouteDeviceName()
			
			set interfaces of interfacesData to gatherInterfaces()
			set dnsWasGathered to false
			
			repeat with i from 1 to count of (interfaces of interfacesData)
				
				set pCurrentInterface to (a reference to item i of (interfaces of interfacesData))
				
				gatherBasic()
				if not dnsWasGathered and ipAddress of pCurrentInterface is not missing value then
					gatherDNS()
					set dnsWasGathered to false
				end if
				gatherWireless()
				
				set ethernetAddress of pCurrentInterface to ethernetAddressForPort(hardwarePorts, deviceName of pCurrentInterface)
				
				if deviceName of pCurrentInterface is defaultRouteDeviceName then
					copy item i of (interfaces of interfacesData) to defaultRoute of interfacesData
				end if
				
			end repeat
			
			return interfacesData
			
		end run
		
		on gatherPorts()
			
			(* Returns a list of records describing current hardware ports *)
			
			set theOutput to do shell script "networksetup -listallhardwareports"
			
			(*
			log "-------------------------------------"
			log "networksetup -listallhardwareports"
			log theOutput
			*)
			
			set rawPorts to splitString(theOutput, return & return)
			
			set portData to {}
			
			repeat with rawPort in rawPorts
				set pBuffer to rawPort as text
				
				set deviceName to extract("Device: ", return)
				
				if deviceName is not missing value then
					set ethernetAddress to extract("Ethernet Address: ", false)
					set end of portData to {deviceName:deviceName, ethernetAddress:ethernetAddress}
				end if
			end repeat
			
			return portData
			
		end gatherPorts
		
		on ethernetAddressForPort(ports, deviceName)
			
			(* Accepts a list of hardware port records and returns the value for ethernetAddress for a matching deviceName *)
			
			repeat with i from 1 to count of ports
				if deviceName of item i of ports is deviceName then
					return ethernetAddress of item i of ports
				end if
			end repeat
			
			return missing value
			
		end ethernetAddressForPort
		
		on gatherStats()
			
			do shell script "curl -L --silent --connect-timeout 15 --max-time 30 --write-out " & quoted form of ("%{http_code},%{time_total},%{time_connect},%{time_appconnect},%{time_starttransfer},%{size_download},%{size_upload},%{speed_download},%{speed_upload}") & " --output /dev/null " & quoted form of kEmptyAddress
			
			
		end gatherStats
		
		on gatherTransferStats()
			
			set statNames to {}
			set end of statNames to "%{http_code}" -- 1
			set end of statNames to "%{time_total}" -- 2
			set end of statNames to "%{time_connect}" -- 3
			set end of statNames to "%{time_redirect}" -- 4
			set end of statNames to "%{time_appconnect}" -- 5
			set end of statNames to "%{time_pretransfer}" -- 6
			set end of statNames to "%{time_starttransfer}" -- 7
			set end of statNames to "%{size_header}" -- 8
			set end of statNames to "%{size_download}" -- 9
			set end of statNames to "%{speed_download}" -- 10
			set end of statNames to "%{size_upload}" -- 11
			set end of statNames to "%{speed_upload}" -- 12
			set statNames to joinList(statNames, "[DELIM]")
			
			try
				set stats to splitString(do shell script "curl -L --silent --connect-timeout 15 --max-time 30 --write-out " & quoted form of statNames & " --output /dev/null " & quoted form of kDataAddress, "[DELIM]")
			on error
				return {httpCode:missing value, timeTotal:missing value, timeConnect:missing value, timeRedirect:missing value, timeAppconnect:missing value, timePretransfer:missing value, timeStarttransfer:missing value, sizeHeader:missing value, sizeDownload:missing value, speedDownload:missing value, speedDownloadByteReadout:missing value, speedDownloadBitReadout:missing value, sizeUpload:missing value, speedUpload:missing value, speedUpdateByteReadout:missing value, speedUpdateBitReadout:missing value}
			end try
			
			return {httpCode:item 1 of stats, timeTotal:item 2 of stats as number, timeConnect:item 3 of stats as number, timeRedirect:item 4 of stats as number, timeAppconnect:item 5 of stats as number, timePretransfer:item 6 of stats as number, timeStarttransfer:item 7 of stats as number, sizeHeader:item 8 of stats as number, sizeDownload:item 9 of stats as number, speedDownload:item 10 of stats as number, speedDownloadByteReadout:formatSize(item 10 of stats as number) & "/s", speedDownloadBitReadout:formatBits(item 10 of stats as number) & "/s", sizeUpload:item 11 of stats as number, speedUpload:item 12 of stats as number, speedUpdateByteReadout:formatSize(item 12 of stats as number) & "/s", speedUpdateBitReadout:formatBits(item 12 of stats as number) & "/s"}
			
		end gatherTransferStats
		
		on gatherWAN()
			
			(* Queries external server to determine current public IP address *)
			
			try
				return do shell script "curl -L --no-progress-meter --connect-timeout 15 --max-time 30 " & quoted form of kWanAddressQuery
			on error eMsg number eNum
				-- log eMsg
				return missing value
			end try
			
		end gatherWAN
		
		on gatherDefaultRouteDeviceName()
			
			try
				return last word of (do shell script "route -n get default | grep 'interface:'")
			on error
				return missing value
			end try
			
		end gatherDefaultRouteDeviceName
		
		on gatherInterfaces()
			
			(* Produces a list of records for each network interface; whatÕs disabled is excluded *)
			
			set theOutput to do shell script "networksetup -listnetworkserviceorder"
			
			(*
			log "-------------------------------------"
			log "networksetup -listnetworkserviceorder"
			log theOutput
			*)
			
			try
				set theOutput to joinList(paragraphs 2 thru -1 of theOutput, return)
				set outputEntities to text items of splitString(theOutput, return & return)
			on error eMsg number eNum
				error "Failed to parse list of service names. " & eMsg number eNum
			end try
			
			set interfacesList to {}
			
			repeat with entitity in outputEntities
				
				copy kInterfaceTemplate to pCurrentInterface
				
				set pBuffer to entitity as text
				
				try
					set order to extract("(", ")") as integer
				on error eMsg number eNum
					-- log "gatherInterfaces(): " & eMsg & " (" & (eNum as text) & ")"
					set order to false
				end try
				
				if order is not missing value and order is not false then
					
					set order of pCurrentInterface to order
					set serviceName of pCurrentInterface to extract(" ", return)
					set portName of pCurrentInterface to extract("Hardware Port: ", ",")
					set deviceName of pCurrentInterface to extract("Device: ", ")")
					
					set end of interfacesList to pCurrentInterface
					
				end if
				
			end repeat
			
			
			return interfacesList
			
		end gatherInterfaces
		
		on gatherBasic()
			
			try
				
				set cmd to "networksetup -getinfo " & quoted form of ((serviceName of pCurrentInterface) as text)
				set pBuffer to do shell script cmd
				
				(*
				log "------------------------------"
				log cmd
				log pBuffer
				*)
				
				set ipAddress of pCurrentInterface to extract("IP address: ", return)
				if ipAddress of pCurrentInterface is "none" then
					set ipAddress of pCurrentInterface to missing value
				end if
				
				set subnetMask of pCurrentInterface to extract("Subnet mask: ", return)
				if subnetMask of pCurrentInterface is "none" then
					set subnetMask of pCurrentInterface to missing value
				end if
				
				set router of pCurrentInterface to extract("Router: ", return)
				if router of pCurrentInterface is "none" then
					set router of pCurrentInterface to missing value
				end if
				
			on error eMsg number eNum
				
				log "gatherBasic(): " & eMsg & " (" & (eNum as text) & ")"
				
			end try
			
		end gatherBasic
		
		on gatherDNS()
			
			try
				
				
				
				set cmd to "scutil --dns | grep nameserver | grep -v '::'"
				set theOutput to do shell script cmd
				
				(*
				log "------------------------------"
				log cmd
				log pBuffer
				*)
				
				set outputLines to paragraphs of theOutput
				set addresses to {}
				
				repeat with i from 1 to count of outputLines
					
					set pBuffer to item i of outputLines
					set thisAddress to extract(" : ", false)
					
					if thisAddress is not in addresses then
						set end of addresses to thisAddress
					end if
				end repeat
				
				set dnsServers of pCurrentInterface to addresses
				
			on error eMsg number eNum
				
				log "gatherDNS(): " & eMsg & " (" & (eNum as text) & ")"
				
			end try
			
		end gatherDNS
		
		on gatherWireless()
			
			try
				
				set cmd to "networksetup -getairportnetwork " & quoted form of ((deviceName of pCurrentInterface) as text)
				set pBuffer to do shell script cmd
				
				(*
				log "------------------------------"
				log cmd
				log pBuffer
				*)
				
				set networkName of pCurrentInterface to extract("Current Wi-Fi Network: ", false)
				
			on error eMsg number eNum
				
				--log "gatherWireless(): " & eMsg & " (" & (eNum as text) & ")"
				
			end try
			
		end gatherWireless
		
		on extract(a, b)
			
			try
				return trim(textBetween(pBuffer, a, b))
			on error eMsg number eNum
				if b is return then
					set bDebug to "return"
				else
					set bDebug to "\"" & b & "\""
				end if
				
				-- log "extract(\"" & a & "\", " & bDebug & "): " & eMsg & " (" & (eNum as text) & ")"
				return missing value
			end try
			
		end extract
		
		on splitString(aText, aDelimiter)
			
			(* Splits a string the specified delimiter *)
			
			if class of aText is not text then
				error "splitString(): Wrong data type" number 1
			end if
			
			set prvDlmt to text item delimiters
			set text item delimiters to aDelimiter
			
			set anOutput to text items of aText
			
			set text item delimiters to prvDlmt
			
			return anOutput
			
		end splitString
		
		on textBetween(str, a, b)
			
			(* Returns a substring between a start string and an end string *)
			
			try
				
				-- Start string
				if class of a is integer then
					
					if a is 0 or a > (length of str) then
						error "Invalid start offset specified"
					end if
					
					set aOffset to a
					
				else if class of a is boolean then
					
					if a is false then
						set a to ""
						set aOffset to 1
					else
						error "Invalid start offset"
					end if
					
					
				else if a is "" then
					error "Empty start string specified"
					
				else
					set aOffset to offset of a in str
					
				end if
				
				-- End string
				if class of b is integer then
					
					if b < 0 then
						set b to (length of str) + b + 1
					end if
					
					if class of a is integer and b ² a then
						error "Invalid end offset specified. Needs to be higher than start offset."
					end if
					
					if b > (length of str) then
						error "Invalid end offset specified. Out of bounds."
					end if
					
				else if class of b is boolean and b is not false then
					error "Invalid end position"
					
				else if b is "" then
					error "Empty end string specified"
					
				end if
				
				if aOffset is 0 then
					
					error "Start string not found"
					
				else
					
					if class of a is integer then
						set newStartOffset to a + 1
					else
						set newStartOffset to aOffset + (length of a)
					end if
					
					if newStartOffset > (length of str) then
						error "Input string too short: " & str
					end if
					
					set subStr to text newStartOffset thru -1 of str
					
					if class of b is integer then
						set bOffset to b - newStartOffset
						
					else if class of b is boolean then
						set bOffset to length of subStr
						
					else
						set bOffset to (offset of b in subStr) - 1
						
					end if
					
					if bOffset ² 0 then
						error "End string not found"
						
					else
						
						set subStr to text 1 thru bOffset of subStr
						
						return subStr
						
					end if
					
				end if
				
			on error eMsg number eNum
				
				error "textBetween: " & eMsg number eNum
				
			end try
			
		end textBetween
		
		on joinList(aList, aDelimiter)
			
			(* Joins a list using the specified delimiter *)
			
			if aDelimiter is false then set aDelimiter to ""
			
			set prvDlmt to text item delimiters
			set text item delimiters to aDelimiter
			
			set aList to aList as text
			
			set text item delimiters to prvDlmt
			
			return aList
			
		end joinList
		
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
			
		end formatBits
		
	end script
	
	tell InterfacesLister to run
	
end gatherNetworkInfo