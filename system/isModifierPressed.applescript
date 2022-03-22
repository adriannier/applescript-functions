use framework "Cocoa"
use scripting additions

set keyNames to {"CapsLock", "Shift", "Control", "Option", "Command", "Function"}

repeat 15 times
	
	repeat with keyName in keyNames
		if isModifierPressed(keyName as text) then
			say keyName
		end if
	end repeat
	
	delay 1
	
end repeat

on isModifierPressed(modifierName)
	
	(* Returns boolean representing whether the specified modifier key is pressed at the time this function is called *)
	
	(* Modifier key names: CapsLock, Shift, Control, Option, Command, Function *)
	
	tell current application
		
		if modifierName is "CapsLock" then
			set modifier to its NSEventModifierFlagCapsLock
		else if modifierName is "Shift" then
			set modifier to its NSEventModifierFlagShift
		else if modifierName is "Control" then
			set modifier to its NSEventModifierFlagControl
		else if modifierName is "Option" then
			set modifier to its NSEventModifierFlagOption
		else if modifierName is "Command" then
			set modifier to its NSEventModifierFlagCommand
		else if modifierName is "Function" then
			set modifier to its NSEventModifierFlagFunction
		else
			error "isModifierPressed(): Unknown modifier name: " & modifierName
		end if
		
		set flags to its NSEvent's modifierFlags()
		
		set int1 to flags
		set int2 to modifier
		set theResult to 0
		
		repeat with bitOffset from 30 to 0 by -1
			
			if int1 div (2 ^ bitOffset) = 1 and int2 div (2 ^ bitOffset) = 1 then
				set theResult to theResult + 2 ^ bitOffset
			end if
			
			set int1 to int1 mod (2 ^ bitOffset)
			set int2 to int2 mod (2 ^ bitOffset)
			
		end repeat
		
		return (theResult as integer) = modifier
		
	end tell
	
end isModifierPressed
