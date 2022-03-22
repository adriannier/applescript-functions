urlEncode("https://www.apple.com/de/search/iMac?src=globalnav")

on urlEncode(str)

(* Encode characters so that they can be part of a URL *)
	
	set str to str as text
	set buffer to ""
	
	repeat with i from 1 to length of str
		
		set c to character i of str
		set cTrans to c
		set cNum to ASCII number of c
		
		if cNum = 32 then
			
			set cTrans to "+"
			
		else if (cNum ­ 42) and (cNum ­ 95) and (cNum < 45 or cNum > 46) and (cNum < 48 or cNum > 57) and (cNum < 65 or cNum > 90) and (cNum < 97 or cNum > 122) then
			
			set firstDig to round (cNum / 16) rounding down
			set secondDig to cNum mod 16
			
			if firstDig > 9 then
				set aNum to firstDig + 55
				set firstDig to ASCII character aNum
			end if
			
			if secondDig > 9 then
				set aNum to secondDig + 55
				set secondDig to ASCII character aNum
			end if
			
			set cTrans to ("%" & (firstDig as string) & (secondDig as string)) as string
			
		end if
		
		set buffer to buffer & cTrans as string
		
	end repeat
	
	return buffer
	
end urlEncode