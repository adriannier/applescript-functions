if not versionCompare("1", "=", "1") then error "Test failed"

if not versionCompare("1.0", "=", "1.0") then error "Test failed"

if not versionCompare("1.1", "≠", "1.0") then error "Test failed"

if not versionCompare("1.1", ">", "1.0") then error "Test failed"

if not versionCompare("1.0", "<", "1.9") then error "Test failed"

if not versionCompare("1.0", "≤", "1.9") then error "Test failed"

if not versionCompare("1.9", "≤", "1.9") then error "Test failed"

if not versionCompare("1.9", "≥", "1.9") then error "Test failed"

if not versionCompare("1.9.1", "≥", "1.9") then error "Test failed"

if versionCompare("10.15.6", "≥", "12.*") then error "Test failed"

if not versionCompare("12.2.1", "≥", "12.*") then error "Test failed"

if not versionCompare("13.1.1", "≥", "12.*") then error "Test failed"

on versionCompare(v1, comp, v2)
	
	(* Compare two version strings. *)
	
	script Lib
		
		on newVersionObject(versionString)
			
			script VersionObject
				
				property _string : versionString
				property _components : missing value
				
				on init()
					
					set prvDlmt to text item delimiters
					set text item delimiters to "."
					set _components to text items of _string
					set text item delimiters to prvDlmt
					
					repeat with i from 1 to count of _components
						
						try
							if item i of _components is not "x" and item i of _components is not "*" then
								set item i of _components to item i of _components as integer
							end if
						on error
							error "Could not parse version string \"" & _string & "\"" number 1
						end try
						
					end repeat
					
					return
					
				end init
				
				on compare(comp, otherVersion)
					
					set compResult to "="
					
					set thisCount to componentCount()
					set otherCount to otherVersion's componentCount()
					
					if thisCount > otherCount then
						set maxCount to thisCount
					else
						set maxCount to otherCount
					end if
					
					repeat with i from 1 to maxCount
						
						set this to component(i)
						set other to otherVersion's component(i)
						
						if (this is "x" or this is "*") and (other is "x" or other is "*") then
							set this to 0
							set other to 0
						else if (this is "x" or this is "*") then
							set this to other
						else if (other is "x" or other is "*") then
							set other to this
						end if
						
						if this > other then
							set compResult to ">"
							exit repeat
						else if this < other then
							set compResult to "<"
							exit repeat
						end if
						
					end repeat
					
					if comp is "≤" or comp is "<=" then
						return compResult = "<" or compResult = "="
					else if comp is "≥" or comp is ">=" then
						return compResult = ">" or compResult = "="
					else if comp is "≠" or comp is "!=" then
						return compResult ≠ "="
					else if comp is "==" then
						return compResult = "="
					else
						return compResult = comp
					end if
					
				end compare
				
				on component(n)
				
					try
					
						return item n of _components
						
					on error
					
						if item -1 of _components is "x" or item -1 of _components is "*" then
							return "x"
						else
							return 0
						end if
						
					end try
					
				end component
				
				on componentCount()
				
					return count of _components
					
				end componentCount
				
			end script
			
			VersionObject's init()
			
			return VersionObject
			
		end newVersionObject
		
	end script
	
	return Lib's newVersionObject(v1)'s compare(comp, Lib's newVersionObject(v2))
	
end versionCompare