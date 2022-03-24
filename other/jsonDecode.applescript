use framework "Foundation"
use scripting additions

log jsonDecode("/System/Library/CoreServices/CoreTypes.bundle/Contents/Resources/IANASchemesList.json")

log jsonDecode("/System/Library/CoreServices/ClimateProxy.app/Contents/PlugIns/WeatherWidget.appex/Contents/Resources/ClearDay.json")

on jsonDecode(posixPath)
	
	(* Returns the contents of the JSON file at the specified POSIX path as record or list. *)
	
	tell current application
		
		set json to its (NSData's dataWithContentsOfFile:posixPath)
		
		if json is missing value then
			error "Failed to read JSON file at " & posixPath
		end if
		
		set {obj, eMsg} to (its (NSJSONSerialization's JSONObjectWithData:json options:0 |error|:(reference)))
		
		if eMsg ­ missing value then error eMsg
		
		try
			
			if obj's isKindOfClass:(its NSDictionary) then
				return obj as record
			end if
			
		on error eMsg number eNum
			
			return obj as list
			
		end try
		
	end tell
	
end jsonDecode