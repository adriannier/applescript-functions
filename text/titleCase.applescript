(*
	Converts a text to title case.
*)

log convertTextToTitleCase("In episode iv: MAC MINI finally speed bumped.")

log convertTextToTitleCase("DON'T EVEN TRIP, o.k.? (FEAT. AMON TOBIN)")

on convertTextToTitleCase(aText)
	
	script TitleCaser
		
		property pInitialized : false
		
		property pConvertRestToLowercase : true
		
		property pLowercaseCharacters : {}
		property pUppercaseCharacters : {}
		
		property pWordsToKeepLowercase : {"a", "an", "and", "as", "at"} & ¬
			{"but", "by"} & ¬
			{"en"} & ¬
			{"featuring", "feat.", "feat", "for"} & ¬
			{"if", "in"} & ¬
			{"of", "on", "or"} & ¬
			{"the", "to"} & ¬
			{"v", "v.", "via", "vs", "vs."}
		
		property pSpecialPhrases : {"iPod touch", "Mac mini", "(featuring", "[featuring", "(feat.", "[feat.", "(feat", "[feat."}
		
		property pSpecialWords : {"iBook", "iDVD", "iLife", "iMac", "iMovie", "iPhone", "iPhoto", "iPod", "iWeb", "iWork", "eMac", "eMail", "AT&T", "Q&A"}
		
		property pWordAndPhraseAdditions : {"'s", "’s", "s'", "s’", "s", "es"}
		
		-- Define characters that require the next character to be upper case
		property pCharsCausingUppercaseForNextChar : {"\"", "'", "“", "‘", "(", "{", "[", "_"}
		
		-- Define characters that are the last character of one word and require the next word to be upper case
		property pLastCharsCausingUppercaseForNextWord : {":", ".", "?", "!"}
		property pCharactersThatBreakWords : {":", "-", return}
		
		on init()
			
			-- Generate variations for special words
			set originalSpecialWordsCount to count of pSpecialWords
			repeat with i from 1 to count of pWordAndPhraseAdditions
				repeat with j from 1 to originalSpecialWordsCount
					set end of pSpecialWords to (item j of pSpecialWords & item i of pWordAndPhraseAdditions)
				end repeat
			end repeat
			
			-- Generate variations for special phrases
			set _originalSpecialPhrasesCount to count of pSpecialPhrases
			repeat with i from 1 to count of pWordAndPhraseAdditions
				repeat with j from 1 to _originalSpecialPhrasesCount
					set end of pSpecialPhrases to (item j of pSpecialPhrases & item i of pWordAndPhraseAdditions)
				end repeat
			end repeat
			
			-- Reverse the list of phrases so that "Mac minis" produces a positive match before "Mac mini" does.
			set pSpecialPhrases to reverse of pSpecialPhrases
			
			-- Define character sets
			set lowercaseCharacters to characters of "abcdefghijklmnopqrstuvwxyz"
			set uppercaseCharacters to characters of "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
			
			-- Add special characters by using their ASCII numbers
			-- Currently scripts encoded into applescript:// protocol URLs do not open in Script Editor when they contain high-ascii characters 
			set lowercaseSpecialCharacters to {138, 140, 136, 139, 135, 137, 190, 141, 142, 144, 145, 143, 146, 148, 149, 147, 150, 154, 155, 151, 153, 152, 207, 159, 156, 158, 157, 216}
			set uppercaseSpecialCharacters to {128, 129, 203, 204, 231, 229, 174, 130, 131, 230, 232, 233, 234, 235, 236, 237, 132, 133, 205, 238, 239, 241, 206, 134, 242, 243, 244, 217}
			
			-- Add special characters to the character lists
			repeat with i from 1 to count of lowercaseSpecialCharacters
				set end of lowercaseCharacters to ASCII character (item i of lowercaseSpecialCharacters)
			end repeat
			repeat with i from 1 to count of uppercaseSpecialCharacters
				set end of uppercaseCharacters to ASCII character (item i of uppercaseSpecialCharacters)
			end repeat
			
			set pLowercaseCharacters to lowercaseCharacters
			set pUppercaseCharacters to uppercaseCharacters
			
			set pInitialized to true
			
		end init
		
		on convertText(aText)
			
			if pInitialized is false then init()
			
			-- Protect special phrases from being parsed
			set aText to protectSpecialPhrasesInText(aText)
			
			-- Convert string to list of words
			set prvDlmt to text item delimiters
			set text item delimiters to " "
			set wordList to text items of aText
			set text item delimiters to prvDlmt
			
			set convertedWords to {}
			set previousWord to false
			
			repeat with i from 1 to count of wordList
				try
					set nextWord to item (i + 1) of wordList
				on error
					set nextWord to false
				end try
				
				set end of convertedWords to processWord(item i of wordList, previousWord, nextWord)
				
				set previousWord to item i of wordList
			end repeat
			
			-- Convert list of words to string
			set prvDlmt to text item delimiters
			set text item delimiters to " "
			set convertedText to convertedWords as text
			set text item delimiters to prvDlmt
			
			-- Restore special phrases
			set convertedText to restoreSpecialPhrasesInText(convertedText)
			
			return convertedText
			
		end convertText
		
		on protectSpecialPhrasesInText(aText)
			
			set specialPhraseCount to count of pSpecialPhrases
			set paddingLength to count of (specialPhraseCount as text)
			
			repeat with i from 1 to specialPhraseCount
				
				set specialPhrase to item i of pSpecialPhrases
				set replacementIndex to padWithPrefix((i as text), paddingLength, "0")
				set replacementCode to "<TCProtectedSpecialPhrase" & replacementIndex & ">"
				set aText to snr(aText, specialPhrase, replacementCode)
				
			end repeat
			
			return aText
			
		end protectSpecialPhrasesInText
		
		on snr(aText, aPattern, aReplacement)
			
			if aText does not contain aPattern then return aText
			
			set prvDlmt to text item delimiters
			try
				set text item delimiters to aPattern
				set tempList to text items of aText
				set text item delimiters to aReplacement
				set aText to tempList as text
			end try
			set text item delimiters to prvDlmt
			
			return aText
			
		end snr
		
		on padWithPrefix(aText, aPadding, newWidth)
			
			repeat newWidth - (count of aText) times
				set aText to aPadding & aText
			end repeat
			
			return aText
			
		end padWithPrefix
		
		
		on restoreSpecialPhrasesInText(aText)
			
			set prvDlmt to text item delimiters
			set text item delimiters to "<TCProtectedSpecialPhrase"
			set tempList to text items of aText
			set text item delimiters to prvDlmt
			
			set restoredItems to {item 1 of tempList}
			if (count of tempList) > 1 then
				repeat with i from 2 to count of tempList
					set prvDlmt to text item delimiters
					set text item delimiters to ">"
					try
						set phraseNumber to text item 1 of (item i of tempList) as integer
						set theRemainder to text items 2 thru -1 of (item i of tempList) as text
					on error
						set phraseNumber to 0
					end try
					
					set text item delimiters to prvDlmt
					
					if phraseNumber ≠ 0 then
						set end of restoredItems to (item phraseNumber of pSpecialPhrases & theRemainder)
					else
						set end of restoredItems to (item i of tempList)
					end if
				end repeat
			end if
			
			set prvDlmt to text item delimiters
			set text item delimiters to ""
			set restoredItems to restoredItems as text
			set text item delimiters to prvDlmt
			
			return restoredItems
			
		end restoreSpecialPhrasesInText
		
		on processWord(aWord, previousWord, nextWord)
			
			repeat with i from 1 to count of pCharactersThatBreakWords
				if aWord contains (item i of pCharactersThatBreakWords) then
					return breakWordUsingCharacter(aWord, item i of pCharactersThatBreakWords, previousWord, nextWord)
				end if
			end repeat
			
			
			set action to actionForWord(aWord, previousWord, nextWord)
			
			if action is "TCUppercaseFirstChar" then
				set aWord to uppercaseFirstCharacterInText(aWord)
				
			else if action is "TCReplaceWithSpecialWord" then
				set aWord to replaceSpecialWord(aWord)
				
			else if action is "TCUppercaseSecondChar" then
				set aWord to uppercaseSecondCharacterInText(aWord)
				
			else if action is "TCLowercase" then
				set aWord to lowercaseText(aWord)
				
			else if action is "TCUppercase" then
				set aWord to uppercaseText(aWord)
				
			else if action is "TCNoChange" then
				-- Do nothing
				
			else if pConvertRestToLowercase then
				set aWord to lowercaseText(aWord)
				
			end if
			
			return aWord
			
		end processWord
		
		on actionForWord(aText, previousWord, nextWord)
			
			if previousWord is "" then set previousWord to " "
			
			if aText is "" then
				return "TCNoChange"
				
			else if aText starts with "<TCProtectedSpecialPhrase" then
				return "TCNoChange"
				
			else if aText is in pSpecialWords then
				return "TCReplaceWithSpecialWord"
				
			else if isRomanNumeral(aText) then
				return "TCUppercase"
				
			else if isAbbreviation(aText) then
				return "TCUppercase"
				
			else if isEmailAddress(aText) then
				return "TCLowercase"
				
			else if isProtocol(aText) then
				return "TCLowercase"
				
			else if containsInsideDot(aText) then
				return "TCNoChange"
				
			else if (character 1 of aText) is in pCharsCausingUppercaseForNextChar then
				return "TCUppercaseSecondChar"
				
			else if previousWord is false then
				return "TCUppercaseFirstChar"
				
			else if (character -1 of previousWord) is in pLastCharsCausingUppercaseForNextWord then
				return "TCUppercaseFirstChar"
				
			else if nextWord is false or nextWord is return then
				return "TCUppercaseFirstChar"
				
			else if aText is in pWordsToKeepLowercase then
				return "TCLowercase"
				
			else
				return "TCUppercaseFirstChar"
				
			end if
			
		end actionForWord
		
		on breakWordUsingCharacter(aWord, breakCharacter, previousWord, nextWord)
			
			set prvDlmt to text item delimiters
			set text item delimiters to breakCharacter
			set subWords to text items of aWord
			set text item delimiters to prvDlmt
			
			set convertedWords to {}
			repeat with i from 1 to count of subWords
				try
					set nextWord to item (i + 1) of subWords
				on error
					set nextWord to false
				end try
				set aWord to processWord(item i of subWords, previousWord, nextWord)
				
				set previousWord to aWord
				set end of convertedWords to aWord
			end repeat
			
			set prvDlmt to text item delimiters
			set text item delimiters to breakCharacter
			set aWord to convertedWords as text
			set text item delimiters to prvDlmt
			
			return aWord
			
		end breakWordUsingCharacter
		
		on containsInsideDot(aText)
			
			if aText contains "." and character -1 of aText is not "." then
				return true
			else
				return false
			end if
			
		end containsInsideDot
		
		on isEmailAddress(aText)
			
			if aText contains "@" and aText contains "." then
				return true
			else
				return false
			end if
			
		end isEmailAddress:
		
		on isProtocol(aText)
			
			if aText contains "://" then
				return true
			else
				return false
			end if
			
		end isProtocol:
		
		on isAbbreviation(aText)
			
			set allLetters to "abcdefghijklmnopqrstuvwxyz"
			
			try
				if character 1 of aText is in allLetters and character 2 of aText is "." and character 3 of aText is in allLetters and character 4 of aText is "." then return true
			end try
			
			return false
			
		end isAbbreviation
		
		on isRomanNumeral(aText)
			
			set romanNumeralSymbols to {"I", "V", "X", "L", "C", "D", "M"}
			
			repeat with i from 1 to count of characters of aText
				if character i of aText is not in romanNumeralSymbols then return false
			end repeat
			
			return true
			
		end isRomanNumeral:
		
		on replaceSpecialWord(aText)
			
			ignoring case
				
				repeat with i from 1 to count of pSpecialWords
					if item i of pSpecialWords is aText then exit repeat
				end repeat
				
			end ignoring
			
			return item i of pSpecialWords
			
		end replaceSpecialWord
		
		on uppercaseFirstCharacterInText(aText)
			
			if pConvertRestToLowercase then set aText to lowercaseText(aText)
			
			set firstChar to uppercaseText(character 1 of aText)
			if (count of characters in aText) < 2 then
				set remainingChars to ""
			else
				set remainingChars to text 2 thru -1 of aText
			end if
			
			set aText to firstChar & remainingChars
			
			return aText
			
		end uppercaseFirstCharacterInText
		
		on uppercaseSecondCharacterInText(aText)
			
			if (count of characters in aText) < 2 then return aText
			
			if pConvertRestToLowercase then set aText to lowercaseText(aText)
			
			set firstChar to character 1 of aText
			set secondChar to uppercaseText(character 2 of aText)
			
			if (count of characters in aText) < 3 then
				set remainingChars to ""
			else
				set remainingChars to text 3 thru -1 of aText
			end if
			
			set aText to firstChar & secondChar & remainingChars
			
			return aText
			
		end uppercaseSecondCharacterInText
		
		on uppercaseText(aText)
			
			set lowercaseCharacters to pLowercaseCharacters & (ASCII character 167)
			set uppercaseCharacters to pUppercaseCharacters & "SS"
			
			set prvDlmt to text item delimiters
			
			-- Loop through every lower case character
			repeat with i from 1 to count of lowercaseCharacters
				
				considering case
					
					if aText contains (item i of lowercaseCharacters) then
						
						-- Delimit string by lower case character
						set text item delimiters to (item i of lowercaseCharacters)
						set tempList to text items of aText
						-- Join list by upper case character
						set text item delimiters to (item i of uppercaseCharacters)
						set aText to tempList as text
						
					end if
					
				end considering
				
			end repeat
			
			set text item delimiters to prvDlmt
			
			return aText
		end uppercaseText
		
		on lowercaseText(aText)
			
			set lowercaseCharacters to pLowercaseCharacters
			set uppercaseCharacters to pUppercaseCharacters
			
			set prvDlmt to text item delimiters
			
			-- Loop through every upper case character
			repeat with i from 1 to count of uppercaseCharacters
				
				considering case
					
					if aText contains (item i of uppercaseCharacters) then
						
						-- Delimit string by upper case character
						set text item delimiters to (item i of uppercaseCharacters)
						set tempList to text items of aText
						
						-- Join list by lower case character
						set text item delimiters to (item i of lowercaseCharacters)
						set aText to tempList as text
						
					end if
					
				end considering
				
			end repeat
			
			set text item delimiters to prvDlmt
			
			return aText
			
		end lowercaseText
		
	end script
	
	tell TitleCaser to convertText(aText)
	
end convertTextToTitleCase