(*
	Returns a record of network devices and their addresses.
*)

ipAddresses()

on ipAddresses()
	
	try
		set foundDeviceMentions to paragraphs of (do shell script "networksetup -listallhardwareports | grep 'Device: '")
	on error
		set foundDeviceMentions to {}
	end try
	
	set allAddresses to {}
	
	repeat with i from 1 to count of foundDeviceMentions
		
			set networkDevice to last word of item i of foundDeviceMentions
			set shellCommand to "ipconfig getifaddr " & networkDevice
			
			try
			set networkAddress to do shell script shellCommand
			on error
			set networkAddress to false
			end try
			
			if networkAddress is not false then
			set end of allAddresses to {networkDevice:networkDevice, networkAddress:networkAddress}
			end if
			
	end repeat
	
	return allAddresses
	
end ipAddresses