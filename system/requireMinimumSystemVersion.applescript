(*
	Checks if the specified minimum system version is available.
*)

requireMinimumSystemVersion("10.4.11")

requireMinimumSystemVersion("10.14.2")

requireMinimumSystemVersion("12.3.4")

on requireMinimumSystemVersion(minimumSystemVersion)
	
	set currentVersion to parseVersionString(do shell script "sw_vers -productVersion")
	
	set requiredVersion to parseVersionString(minimumSystemVersion)
	
	if (majorVersion of currentVersion) < (majorVersion of requiredVersion) then
		set requirementsMet to false
		
	else if (majorVersion of currentVersion) = (majorVersion of requiredVersion) then
		
		if (minorVersion of currentVersion) < (minorVersion of requiredVersion) then
			set requirementsMet to false
			
		else if (minorVersion of currentVersion) = (minorVersion of requiredVersion) then
			
			if (theRevision of currentVersion) < (theRevision of requiredVersion) then
				set requirementsMet to false
			else
				set requirementsMet to true
			end if
			
		else
			set requirementsMet to true
		end if
		
	else
		set requirementsMet to true
	end if
	
	
	if requirementsMet then return true
	
	-- Display a dialog if requirements are not met
	try
		set targetLanguage to first word of (do shell script "defaults read NSGlobalDomain AppleLanguages")
	on error
		set targetLanguage to "en"
	end try
	
	if targetLanguage is "de" then
		
		set dialogTitle to "Nicht unterst" & (ASCII character 159) & "tztes System"
		set dialogMessage to "Dieses Skript erfordert mindestens die Systemversion " & minimumSystemVersion & ". "
		
	else
		
		set dialogTitle to "System not supported"
		set dialogMessage to "This script requires at least system version " & minimumSystemVersion & ". "
		
	end if
	
	activate
	
	if (majorVersion of currentVersion) ≥ 10 and (minorVersion of currentVersion) ≥ 4 then
		display alert dialogTitle message dialogMessage buttons {"OK"} default button "OK" as warning
	else
		display dialog dialogTitle & return & return & dialogMessage buttons {"OK"} default button "OK" with icon 2
	end if
	
	return false
	
end requireMinimumSystemVersion

on parseVersionString(versionString)
	
	set prvDlmt to text item delimiters
	set text item delimiters to "."
	
	try
		set majorVersion to (text item 1 of versionString) as integer
	on error
		set majorVersion to 0
	end try
	try
		set minorVersion to (text item 2 of versionString) as integer
	on error
		set minorVersion to 0
	end try
	try
		set theRevision to (text item 3 of versionString) as integer
	on error
		set theRevision to 0
	end try
	
	set text item delimiters to prvDlmt
	
	return {majorVersion:majorVersion, minorVersion:minorVersion, theRevision:theRevision}
	
end parseVersionString