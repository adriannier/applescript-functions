(* ### DESCRIPTION ###
Converts a text to title case.

# Required parameters
Parameter 1 (text)
:-- A text that is converted to title case.
*)
-- ### FUNCTION CALLS ###
convertTextToTitleCase_("In episode iv: MAC MINI finally speed bumped.")

convertTextToTitleCase_("DON'T EVEN TRIP, o.k.? (FEAT. AMON TOBIN)")
-- ### IMPLEMENTATION ###

on convertTextToTitleCase_(aText)
	
	script TitleCaser
		
		property pCONVERT_REST_TO_LOWERCASE : true
		
		global gLOWERCASE_CHARACTERS
		global gUPPERCASE_CHARACTERS
		
		global gWORDS_TO_KEEP_LOWERCASE
		global gSPECIAL_PHRASES
		global gSPECIAL_WORDS
		
		global gCHARS_CAUSING_UPPERCASE_FOR_NEXT_CHAR
		global gLAST_CHARS_CAUSING_UPPERCASE_FOR_NEXT_WORD
		global gCHARACTERS_THAT_BREAK_WORDS
		
		on init()
			
			-- Define list of words to keep lower case
			set gWORDS_TO_KEEP_LOWERCASE to {}
			set gWORDS_TO_KEEP_LOWERCASE to gWORDS_TO_KEEP_LOWERCASE & {"a", "an", "and", "as", "at"}
			set gWORDS_TO_KEEP_LOWERCASE to gWORDS_TO_KEEP_LOWERCASE & {"but", "by"}
			set gWORDS_TO_KEEP_LOWERCASE to gWORDS_TO_KEEP_LOWERCASE & {"en"}
			set gWORDS_TO_KEEP_LOWERCASE to gWORDS_TO_KEEP_LOWERCASE & {"featuring", "feat.", "feat", "for"}
			set gWORDS_TO_KEEP_LOWERCASE to gWORDS_TO_KEEP_LOWERCASE & {"if", "in"}
			set gWORDS_TO_KEEP_LOWERCASE to gWORDS_TO_KEEP_LOWERCASE & {"of", "on", "or"}
			set gWORDS_TO_KEEP_LOWERCASE to gWORDS_TO_KEEP_LOWERCASE & {"the", "to"}
			set gWORDS_TO_KEEP_LOWERCASE to gWORDS_TO_KEEP_LOWERCASE & {"v", "v.", "via", "vs", "vs."}
			
			-- Define list of special phrases
			set gSPECIAL_PHRASES to {"iPod touch", "Mac mini", "(featuring", "[featuring", "(feat.", "[feat.", "(feat", "[feat."}
			
			-- Define list of special words
			set gSPECIAL_WORDS to {"iBook", "iDVD", "iLife", "iMac", "iMovie", "iPhone", "iPhoto", "iPod", "iWeb", "iWork", "eMac", "eMail", "AT&T", "Q&A"}
			
			-- Define characters that require the next character to be upper case
			set gCHARS_CAUSING_UPPERCASE_FOR_NEXT_CHAR to {"\"", "'", "“", "‘", "(", "{", "[", "_"}
			
			-- Define characters that are the last character of one word and require the next word to be upper case
			set gLAST_CHARS_CAUSING_UPPERCASE_FOR_NEXT_WORD to {":", ".", "?", "!"}
			set gCHARACTERS_THAT_BREAK_WORDS to {":", "-", return}
			
			-- Generate variations for special words
			set originalSpecialWordsCount to count of gSPECIAL_WORDS
			set wordAndPhraseAdditions to {"'s", "’s", "s'", "s’", "s", "es"}
			repeat with i from 1 to count of wordAndPhraseAdditions
				repeat with j from 1 to originalSpecialWordsCount
					set end of gSPECIAL_WORDS to (item j of gSPECIAL_WORDS & item i of wordAndPhraseAdditions)
				end repeat
			end repeat
			
			-- Generate variations for special phrases
			set _originalSpecialPhrasesCount to count of gSPECIAL_PHRASES
			repeat with i from 1 to count of wordAndPhraseAdditions
				repeat with j from 1 to _originalSpecialPhrasesCount
					set end of gSPECIAL_PHRASES to (item j of gSPECIAL_PHRASES & item i of wordAndPhraseAdditions)
				end repeat
			end repeat
			-- Reverse the list of phrases so that "Mac minis" produces a positive match before "Mac mini" does.
			set gSPECIAL_PHRASES to reverse of gSPECIAL_PHRASES
			
			-- Define character sets
			set lowercaseCharacters to "abcdefghijklmnopqrstuvwxyz"
			set uppercaseCharacters to "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
			-- Add special characters by using their ASCII numbers
			-- Currently scripts encoded into applescript:// protocol URLs do not open in Script Editor when they contain high-ascii characters 
			set lowercaseSpecialCharacters to {138, 140, 136, 139, 135, 137, 190, 141, 142, 144, 145, 143, 146, 148, 149, 147, 150, 154, 155, 151, 153, 152, 207, 159, 156, 158, 157, 216}
			set uppercaseSpecialCharacters to {128, 129, 203, 204, 231, 229, 174, 130, 131, 230, 232, 233, 234, 235, 236, 237, 132, 133, 205, 238, 239, 241, 206, 134, 242, 243, 244, 217}
			
			-- Convert comma seperated texts into a list
			set lowercaseCharacters to characters of lowercaseCharacters
			set uppercaseCharacters to characters of uppercaseCharacters
			
			-- Add special characters to the character lists
			repeat with i from 1 to count of lowercaseSpecialCharacters
				set end of lowercaseCharacters to ASCII character (item i of lowercaseSpecialCharacters)
			end repeat
			repeat with i from 1 to count of uppercaseSpecialCharacters
				set end of uppercaseCharacters to ASCII character (item i of uppercaseSpecialCharacters)
			end repeat
			
			set gLOWERCASE_CHARACTERS to lowercaseCharacters
			set gUPPERCASE_CHARACTERS to uppercaseCharacters
			
			
		end init
		
		on convertText_(aText)
			
			init()
			
			-- Protect special phrases from being parsed
			set aText to protectSpecialPhrasesInText_(aText)
			
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
				
				set end of convertedWords to processWord_(item i of wordList, previousWord, nextWord)
				
				set previousWord to item i of wordList
			end repeat
			
			-- Convert list of words to string
			set prvDlmt to text item delimiters
			set text item delimiters to " "
			set convertedText to convertedWords as text
			set text item delimiters to prvDlmt
			
			-- Restore special phrases
			set convertedText to restoreSpecialPhrasesInText_(convertedText)
			
			return convertedText
			
		end convertText_
		
		on protectSpecialPhrasesInText_(aText)
			
			set specialPhraseCount to count of gSPECIAL_PHRASES
			set paddingLength to count of (specialPhraseCount as text)
			
			repeat with i from 1 to specialPhraseCount
				
				set specialPhrase to item i of gSPECIAL_PHRASES
				set replacementIndex to padText_toWidth_usingPrefix_((i as text), paddingLength, "0")
				set replacementCode to "<TCProtectedSpecialPhrase" & replacementIndex & ">"
				set aText to snr(aText, specialPhrase, replacementCode)
				
			end repeat
			
			return aText
			
		end protectSpecialPhrasesInText_
		
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
		
		on padText_toWidth_usingPrefix_(aText, aPadding, newWidth)
			
			repeat newWidth - (count of aText) times
				set aText to aPadding & aText
			end repeat
			
			return aText
			
		end padText_toWidth_usingPrefix_
		
		
		on restoreSpecialPhrasesInText_(aText)
			
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
						set end of restoredItems to (item phraseNumber of gSPECIAL_PHRASES & theRemainder)
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
			
		end restoreSpecialPhrasesInText_
		
		on processWord_(aWord, previousWord, nextWord)
			
			repeat with i from 1 to count of gCHARACTERS_THAT_BREAK_WORDS
				if aWord contains (item i of gCHARACTERS_THAT_BREAK_WORDS) then
					return breakWord_usingCharacter_previousWord_nextWord_(aWord, item i of gCHARACTERS_THAT_BREAK_WORDS, previousWord, nextWord)
				end if
			end repeat
			
			
			set action to actionForWord_previousWord_nextWord_(aWord, previousWord, nextWord)
			
			if action is "TCUppercaseFirstChar" then
				set aWord to uppercaseFirstCharacterInText_(aWord)
				
			else if action is "TCReplaceWithSpecialWord" then
				set aWord to replaceSpecialWord_(aWord)
				
			else if action is "TCUppercaseSecondChar" then
				set aWord to uppercaseSecondCharacterInText_(aWord)
				
			else if action is "TCLowercase" then
				set aWord to lowercaseText_(aWord)
				
			else if action is "TCUppercase" then
				set aWord to uppercaseText_(aWord)
				
			else if action is "TCNoChange" then
				-- Do nothing
				
			else if pCONVERT_REST_TO_LOWERCASE then
				set aWord to lowercaseText_(aWord)
				
			end if
			
			return aWord
			
		end processWord_
		
		on actionForWord_previousWord_nextWord_(aText, previousWord, nextWord)
			
			if previousWord is "" then set previousWord to " "
			
			if aText is "" then
				return "TCNoChange"
				
			else if aText starts with "<TCProtectedSpecialPhrase" then
				return "TCNoChange"
				
			else if aText is in gSPECIAL_WORDS then
				return "TCReplaceWithSpecialWord"
				
			else if isRomanNumeral_(aText) then
				return "TCUppercase"
				
			else if isAbbreviation_(aText) then
				return "TCUppercase"
				
			else if isEmailAddress_(aText) then
				return "TCLowercase"
				
			else if isProtocol_(aText) then
				return "TCLowercase"
				
			else if containsInsideDot_(aText) then
				return "TCNoChange"
				
			else if (character 1 of aText) is in gCHARS_CAUSING_UPPERCASE_FOR_NEXT_CHAR then
				return "TCUppercaseSecondChar"
				
			else if previousWord is false then
				return "TCUppercaseFirstChar"
				
			else if (character -1 of previousWord) is in gLAST_CHARS_CAUSING_UPPERCASE_FOR_NEXT_WORD then
				return "TCUppercaseFirstChar"
				
			else if nextWord is false or nextWord is return then
				return "TCUppercaseFirstChar"
				
			else if aText is in gWORDS_TO_KEEP_LOWERCASE then
				return "TCLowercase"
				
			else
				return "TCUppercaseFirstChar"
				
			end if
			
		end actionForWord_previousWord_nextWord_
		
		on breakWord_usingCharacter_previousWord_nextWord_(aWord, breakCharacter, previousWord, nextWord)
			
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
				set aWord to processWord_(item i of subWords, previousWord, nextWord)
				
				set previousWord to aWord
				set end of convertedWords to aWord
			end repeat
			
			set prvDlmt to text item delimiters
			set text item delimiters to breakCharacter
			set aWord to convertedWords as text
			set text item delimiters to prvDlmt
			
			return aWord
			
		end breakWord_usingCharacter_previousWord_nextWord_
		
		on containsInsideDot_(aText)
			
			if aText contains "." and character -1 of aText is not "." then
				return true
			else
				return false
			end if
			
		end containsInsideDot_
		
		on isEmailAddress_(aText)
			
			if aText contains "@" and aText contains "." then
				return true
			else
				return false
			end if
			
		end isEmailAddress_
		
		on isProtocol_(aText)
			
			if aText contains "://" then
				return true
			else
				return false
			end if
			
		end isProtocol_
		
		on isAbbreviation_(aText)
			
			set allLetters to "abcdefghijklmnopqrstuvwxyz"
			
			try
				if character 1 of aText is in allLetters and character 2 of aText is "." and character 3 of aText is in allLetters and character 4 of aText is "." then return true
			end try
			
			return false
			
		end isAbbreviation_
		
		on isRomanNumeral_(aText)
			
			set romanNumeralSymbols to {"I", "V", "X", "L", "C", "D", "M"}
			
			repeat with i from 1 to count of characters of aText
				if character i of aText is not in romanNumeralSymbols then return false
			end repeat
			
			return true
			
		end isRomanNumeral_
		
		on replaceSpecialWord_(aText)
			
			ignoring case
				
				repeat with i from 1 to count of gSPECIAL_WORDS
					if item i of gSPECIAL_WORDS is aText then exit repeat
				end repeat
				
			end ignoring
			
			return item i of gSPECIAL_WORDS
			
		end replaceSpecialWord_
		
		on uppercaseFirstCharacterInText_(aText)
			
			if pCONVERT_REST_TO_LOWERCASE then set aText to lowercaseText_(aText)
			
			set firstChar to uppercaseText_(character 1 of aText)
			if (count of characters in aText) < 2 then
				set remainingChars to ""
			else
				set remainingChars to text 2 thru -1 of aText
			end if
			
			set aText to firstChar & remainingChars
			
			return aText
			
		end uppercaseFirstCharacterInText_
		
		on uppercaseSecondCharacterInText_(aText)
			
			if (count of characters in aText) < 2 then return aText
			
			if pCONVERT_REST_TO_LOWERCASE then set aText to lowercaseText_(aText)
			
			set firstChar to character 1 of aText
			set secondChar to uppercaseText_(character 2 of aText)
			
			if (count of characters in aText) < 3 then
				set remainingChars to ""
			else
				set remainingChars to text 3 thru -1 of aText
			end if
			
			set aText to firstChar & secondChar & remainingChars
			
			return aText
			
		end uppercaseSecondCharacterInText_
		
		on uppercaseText_(aText)
			
			set lowercaseCharacters to gLOWERCASE_CHARACTERS & (ASCII character 167)
			set uppercaseCharacters to gUPPERCASE_CHARACTERS & "SS"
			
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
		end uppercaseText_
		
		on lowercaseText_(aText)
			
			set lowercaseCharacters to gLOWERCASE_CHARACTERS
			set uppercaseCharacters to gUPPERCASE_CHARACTERS
			
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
			
		end lowercaseText_
		
	end script
	
	tell TitleCaser to convertText_(aText)
	
	(*
	
	Copyright (C) 2014 by Adrian Nier (http://adriannier.de/code)
	
	Permission is hereby granted, free of charge, to any person obtaining a copy of 
	this software and associated documentation files (the "Software"), to deal in the
	Software without restriction, including without limitation the rights to use, copy, 
	modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, 
	and to permit persons to whom the Software is furnished to do so, subject to the 
	following conditions:
	
	The above copyright notice and this permission notice shall be included in all 
	copies or substantial portions of the Software.
	
	THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, 
	EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF 
	MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. 
	IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY 
	CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, 
	TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE 
	SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
	
	*)
	
end convertTextToTitleCase_
-- ### END ###