hardwareUUID()

on hardwareUUID()

(* Returns the Mac's universally unique identifier. *)
	
	do shell script "/usr/sbin/ioreg -rd1 -c IOPlatformExpertDevice | awk '/IOPlatformUUID/ { split($0, line, \"\\\"\"); printf(\"%s\\n\", line[4]); }'"
	
		-- With thanks to jaharmi.com
		
end hardwareUUID