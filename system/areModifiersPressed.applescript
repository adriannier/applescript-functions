use framework "Cocoa"
use scripting additions

set keyCombinations to {{"CapsLock", "Shift"}, {"Control"}, {"Option", "Command"}, {"Function"}}

repeat 15 times
	
	repeat with keyCombo in keyCombinations
		if areModifiersPressed(keyCombo) then
			say (keyCombo as text)
		end if
	end repeat
	
	delay 1
	
end repeat

on areModifiersPressed(modifiersList)
	
	(* Returns boolean representing whether the modifier keys in the specified list are pressed together at the time this function is called *)
	
	(* Modifier key names: CapsLock, Shift, Control, Option, Command, Function *)
	
if class of modifiersList is text then
set modifiersList to {modifiersList}
end if

	tell current application
		
		set modifierSum to 0
		
		repeat with modifierName in modifiersList
			
			set modifierName to modifierName as text
			
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
				error "areModifiersPressed(): Unknown modifier name: " & modifierName
			end if
			
			set modifierSum to modifierSum + modifier
			
		end repeat
		
		set flags to its NSEvent's modifierFlags()
		
		return flags = modifierSum
		
	end tell
	
end areModifiersPressed
