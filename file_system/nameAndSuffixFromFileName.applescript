(*
Takes a file name, removes the suffix and returns both in a list.
*)

log baseNameAndSuffixFromFileName("Librarian.nib")

log baseNameAndSuffixFromFileName(".DS_Store")

log baseNameAndSuffixFromFileName("archive.tar.gz")

on baseNameAndSuffixFromFileName(fileName)
	
	(*
		Takes a file name, removes the suffix and returns both in a list.
	*)
	
	-- Initialize variables
	set baseName to fileName
	set suffix to ""
	
	if fileName contains "." then
		
		-- Set delimiters
		set prvDlmt to text item delimiters
		set text item delimiters to "."
		
		-- Get rid of everything before the last dot
		set baseName to (text items 1 thru -2 of fileName) as text
		
		-- Last text item should be the suffix
		set suffix to text item -1 of fileName
		
		-- Restore delimiters
		set text item delimiters to prvDlmt
		
		if suffix contains " " or baseName is "" or suffix is "" then
		
			-- No suffix
			set baseName to fileName
			set suffix to ""
			
		end if
		
	end if
	
	return {baseName, suffix}
		
end baseNameAndSuffixFromFileName