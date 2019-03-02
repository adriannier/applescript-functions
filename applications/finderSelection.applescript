(*
	Returns the selection of the frontmost Finder window respecting the sort state of the window.
*)

finderSelection()

on finderSelection()
	
	-- Get the current Finder selection and sort it the same way it is sorted in the current window
	tell application "Finder"
		
		set selectedFinderItems to selection
		if selectedFinderItems is {} then return {}
		
		
		try
			set frontWindow to window 1
			set currentView to current view of frontWindow
			
			
			if currentView is icon view then
				
				-- The window is in icon view
				set itemArrangement to arrangement of icon view options of frontWindow
				
				if itemArrangement is arranged by modification date then
					set sortKey to "modification date"
					
				else if itemArrangement is arranged by creation date then
					set sortKey to "creation date"
					
				else if itemArrangement is arranged by size then
					set sortKey to "size"
					
				else if itemArrangement is arranged by kind then
					set sortKey to "kind"
					
				else if itemArrangement is arranged by label then
					set sortKey to "label"
					
				else
					set sortKey to "name"
					
				end if
				
			else if currentView is list view then
				
				-- The window is in list view
				set sortColumnName to name of sort column of list view options of frontWindow
				
				if sortColumnName is modification date column then
					set sortKey to "modification date"
					
				else if sortColumnName is creation date column then
					set sortKey to "creation date"
					
				else if sortColumnName is size column then
					set sortKey to "size"
					
				else if sortColumnName is kind column then
					set sortKey to "kind"
					
				else if sortColumnName is label column then
					set sortKey to "label"
					
				else
					set sortKey to "name"
					
				end if
				
				
			else
				-- The window is in some other view
				set sortKey to "name"
				
			end if
			
			
		on error
			
			set sortKey to "name"
			
		end try
		
		-- Sort the list of selected items
		if sortKey is "name" then
			set selectedFinderItems to sort selectedFinderItems by name
			
		else if sortKey is "modification date" then
			set selectedFinderItems to sort selectedFinderItems by modification date
			
		else if sortKey is "creation date" then
			set selectedFinderItems to sort selectedFinderItems by creation date
			
		else if sortKey is "size" then
			set selectedFinderItems to sort selectedFinderItems by size
			
		else if sortKey is "kind" then
			set selectedFinderItems to sort selectedFinderItems by kind
			
		else if sortKey is "label" then
			set selectedFinderItems to sort selectedFinderItems by label
			
		end if
		
	end tell
	
	return selectedFinderItems
	
end finderSelection