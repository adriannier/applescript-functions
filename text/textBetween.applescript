log "Test 1"
if textBetween("<tag>", "<", ">") is not "tag" then error "1"

log "Test 2"
if textBetween("<tag>", "<", -1) is not "tag" then error "2"

log "Test 3"
if textBetween("abcdefghi", "cde", -1) is not "fgh" then error "3"

log "Test 4"
if textBetween("abcdefghi", "cde", false) is not "fghi" then error "4"

log "Test 5"
if textBetween("abcdefghi", false, "def") is not "abc" then error "5"

log "Test 6"
if textBetween("abcdefghi", false, false) is not "abcdefghi" then error "6"

log "Test 7"
if textBetween("This is a Hello World example", "s a ", " ex") is not "Hello World" then error "7"

log "Test 8"
try
	log textBetween("", "", "")
on error eMsg number eNum
	if eMsg is not "textBetween: Empty start string specified" then error "8"
end try

log "Test 9"
try
	log textBetween("", "<", "")
on error eMsg number eNum
	if eMsg is not "textBetween: Empty end string specified" then error "9"
end try

log "Test 10"
try
	log textBetween("<", "<", ">")
on error eMsg number eNum
	if eMsg is not "textBetween: Input string too short" then error "10"
end try

log "Test 11"
try
	log textBetween("<<", "<", ">")
on error eMsg number eNum
	if eMsg is not "textBetween: End string not found" then error "11"
end try

log "Test 12"
try
	log textBetween("<>", "<", ">")
on error eMsg number eNum
	if eMsg is not "textBetween: End string not found" then error "12"
end try

log "Test 13"
if textBetween("<a>", "<", ">") is not "a" then error "13"

log "Test 14"
try
	log textBetween("<a<", "<", ">")
on error eMsg number eNum
	if eMsg is not "textBetween: End string not found" then error "14"
end try

log "Test 15"
if textBetween("<a>", 1, 3) is not "a" then error "15"

log "Test 16"
try
	log textBetween("<a", 1, 3)
on error eMsg number eNum
	if eMsg is not "textBetween: Invalid end offset specified. Out of bounds." then error "16"
end try

log "Test 17"
if textBetween("Hello World", 2, 5) is not "ll" then error "17"

on textBetween(str, a, b)
	
	(* Returns a substring between a start string and an end string *)
	
	try
		
		-- Start string
		if class of a is integer then
			
			if a is 0 or a > (length of str) then
				error "Invalid start offset specified"
			end if
			
			set aOffset to a
			
		else if class of a is boolean then
			
			if a is false then
				set a to ""
				set aOffset to 1
			else
				error "Invalid start offset"
			end if
			
			
		else if a is "" then
			error "Empty start string specified"
			
		else
			set aOffset to offset of a in str
			
		end if
		
		-- End string
		if class of b is integer then
			
			if b < 0 then
				set b to (length of str) + b + 1
			end if
			
			if class of a is integer and b ² a then
				error "Invalid end offset specified. Needs to be higher than start offset."
			end if
			
			if b > (length of str) then
				error "Invalid end offset specified. Out of bounds."
			end if
			
		else if class of b is boolean and b is not false then
			error "Invalid end position"
			
		else if b is "" then
			error "Empty end string specified"
			
		end if
		
		if aOffset is 0 then
			
			error "Start string not found"
			
		else
			
			if class of a is integer then
				set newStartOffset to a + 1
			else
				set newStartOffset to aOffset + (length of a)
			end if
			
			if newStartOffset > (length of str) then
				error "Input string too short"
			end if
			
			set subStr to text newStartOffset thru -1 of str
			
			if class of b is integer then
				set bOffset to b - newStartOffset
				
			else if class of b is boolean then
				set bOffset to length of subStr
				
			else
				set bOffset to (offset of b in subStr) - 1
				
			end if
			
			if bOffset ² 0 then
				error "End string not found"
				
			else
				
				set subStr to text 1 thru bOffset of subStr
				
				return subStr
				
			end if
			
		end if
		
	on error eMsg number eNum
		
		error "textBetween: " & eMsg number eNum
		
	end try
	
end textBetween
