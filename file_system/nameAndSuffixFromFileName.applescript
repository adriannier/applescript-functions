(*
	Takes a file name, removes the suffix and returns both in a list.
*)

log nameAndSuffixFromFileName("Librarian.nib")

log nameAndSuffixFromFileName(".DS_Store")

log nameAndSuffixFromFileName("archive.tar.gz")

on nameAndSuffixFromFileName(fileName)
	
	(*
		Takes a file name, removes the suffix and returns both in a list.
	*)
	
	-- Initialize variables
	set theName to fileName
	set suffix to ""
	
	if fileName contains "." then
		
		-- Set delimiters
		set prvDlmt to text item delimiters
		set text item delimiters to "."
		
		-- Get rid of everything before the last dot
		set theName to (text items 1 thru -2 of fileName) as text
		
		-- Last text item should be the suffix
		set suffix to text item -1 of fileName
		
		-- Restore delimiters
		set text item delimiters to prvDlmt
		
		if suffix contains " " or theName is "" or suffix is "" then
			
			-- No suffix
			set theName to fileName
			set suffix to ""
			
		end if
		
	end if
	
	return {theName, suffix}
	
end nameAndSuffixFromFileName