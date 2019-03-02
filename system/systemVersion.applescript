(*
Returns the current system version as a record in the form of:
{major:10, minor:14, revision:2, versionString:"10.14.2"}
*)

systemVersion()

on systemVersion()
	
	set versionString to do shell script "sw_vers -productVersion"
	
	set prvDlmt to text item delimiters
	set text item delimiters to "."
	try
		set major to text item 1 of versionString
	on error
		set major to 0
	end try
	try
		set minor to text item 2 of versionString
	on error
		set minor to 0
	end try
	try
		set revision to text item 3 of versionString
	on error
		set revision to 0
	end try
	set text item delimiters to prvDlmt
	
	
	return {major:major, minor:minor, revision:revision, versionString:versionString}
	
end systemVersion