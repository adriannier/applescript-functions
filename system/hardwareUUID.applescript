(*
	Returns the Mac's universally unique identifier.
*)

hardwareUUID()

on hardwareUUID()
	
	-- With thanks to jaharmi.com
	do shell script "/usr/sbin/ioreg -rd1 -c IOPlatformExpertDevice | awk '/IOPlatformUUID/ { split($0, line, \"\\\"\"); printf(\"%s\\n\", line[4]); }'"
	
end hardwareUUID