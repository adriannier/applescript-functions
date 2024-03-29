if htmlEntityConverter("decode", "Apples &amp; Oranges") is not "Apples & Oranges" then
	error "Test 1 failed"
end if

if htmlEntityConverter("encode", "Apples & Oranges") is not "Apples &amp; Oranges" then
	error "Test 2 failed"
end if

set testString to "!\"#$%&'()*+,-./0123456789:;<=>?@ABCDEFGHIJKLMNOPQRSTUVWXYZ[\\]^_`abcdefghijklmnopqrstuvwxyz{|}~ÄÅÇÉÑÖÜáàâäãåçéèêëíìîïñóòôöõúùûü†°¢£§•¶ß®©™´¨≠ÆØ∞±≤≥¥µ∂∑∏π∫ªºΩæø¿¡¬√ƒ≈∆«»… ÀÃÕŒœ–—“”‘’÷◊ÿŸ⁄€‹›ﬁﬂ‡·‚„‰ÂÊÁËÈÍÎÏÌÓÔÒÚÛÙıˆ˜¯˘˙˚¸˝˛ˇ"

if htmlEntityConverter("decode", htmlEntityConverter("encode", testString)) is not testString then
	error "Test 3 failed"
end if

on htmlEntityConverter(_mode, _str)
	
	(* Decodes/encodes HTML entities in a string *)
	
	script HTMLEntityDecoder
		
		on decode(str)
			
			considering case
				
				-- Ampersand
				if str contains "&amp;" or str contains "&#38;" then
					set str to snr(str, {"&amp;", "&#38;"}, {"&", "&"})
				end if
				
				-- Less-than
				if str contains "&lt;" or str contains "&#60;" then
					set str to snr(str, {"&lt;", "&#60;"}, {"<", "<"})
				end if
				
				-- Greater than
				if str contains "&gt;" or str contains "&#62;" then
					set str to snr(str, {"&gt;", "&#62;"}, {">", ">"})
				end if
				
				-- Capital a with grave accent
				if str contains "&Agrave;" or str contains "&#192;" then
					set str to snr(str, {"&Agrave;", "&#192;"}, {"À", "À"})
				end if
				
				-- Capital a with acute accent
				if str contains "&Aacute;" or str contains "&#193;" then
					set str to snr(str, {"&Aacute;", "&#193;"}, {"Á", "Á"})
				end if
				
				-- Capital a with circumflex accent
				if str contains "&Acirc;" or str contains "&#194;" then
					set str to snr(str, {"&Acirc;", "&#194;"}, {"Â", "Â"})
				end if
				
				-- Capital a with tilde
				if str contains "&Atilde;" or str contains "&#195;" then
					set str to snr(str, {"&Atilde;", "&#195;"}, {"Ã", "Ã"})
				end if
				
				-- Capital a with umlaut
				if str contains "&Auml;" or str contains "&#196;" then
					set str to snr(str, {"&Auml;", "&#196;"}, {"Ä", "Ä"})
				end if
				
				-- Capital a with ring
				if str contains "&Aring;" or str contains "&#197;" then
					set str to snr(str, {"&Aring;", "&#197;"}, {"Å", "Å"})
				end if
				
				-- Capital ae
				if str contains "&AElig;" or str contains "&#198;" then
					set str to snr(str, {"&AElig;", "&#198;"}, {"Æ", "Æ"})
				end if
				
				-- Capital c with cedilla
				if str contains "&Ccedil;" or str contains "&#199;" then
					set str to snr(str, {"&Ccedil;", "&#199;"}, {"Ç", "Ç"})
				end if
				
				-- Capital e with grave accent
				if str contains "&Egrave;" or str contains "&#200;" then
					set str to snr(str, {"&Egrave;", "&#200;"}, {"È", "È"})
				end if
				
				-- Capital e with acute accent
				if str contains "&Eacute;" or str contains "&#201;" then
					set str to snr(str, {"&Eacute;", "&#201;"}, {"É", "É"})
				end if
				
				-- Capital e with circumflex accent
				if str contains "&Ecirc;" or str contains "&#202;" then
					set str to snr(str, {"&Ecirc;", "&#202;"}, {"Ê", "Ê"})
				end if
				
				-- Capital e with umlaut
				if str contains "&Euml;" or str contains "&#203;" then
					set str to snr(str, {"&Euml;", "&#203;"}, {"Ë", "Ë"})
				end if
				
				-- Capital i with grave accent
				if str contains "&Igrave;" or str contains "&#204;" then
					set str to snr(str, {"&Igrave;", "&#204;"}, {"Ì", "Ì"})
				end if
				
				-- Capital i with accute accent
				if str contains "&Iacute;" or str contains "&#205;" then
					set str to snr(str, {"&Iacute;", "&#205;"}, {"Í", "Í"})
				end if
				
				-- Capital i with circumflex accent
				if str contains "&Icirc;" or str contains "&#206;" then
					set str to snr(str, {"&Icirc;", "&#206;"}, {"Î", "Î"})
				end if
				
				-- Capital i with umlaut
				if str contains "&Iuml;" or str contains "&#207;" then
					set str to snr(str, {"&Iuml;", "&#207;"}, {"Ï", "Ï"})
				end if
				
				-- Capital eth (Icelandic)
				if str contains "&ETH;" or str contains "&#208;" then
					set str to snr(str, {"&ETH;", "&#208;"}, {"Ð", "Ð"})
				end if
				
				-- Capital n with tilde
				if str contains "&Ntilde;" or str contains "&#209;" then
					set str to snr(str, {"&Ntilde;", "&#209;"}, {"Ñ", "Ñ"})
				end if
				
				-- Capital o with grave accent
				if str contains "&Ograve;" or str contains "&#210;" then
					set str to snr(str, {"&Ograve;", "&#210;"}, {"Ò", "Ò"})
				end if
				
				-- Capital o with accute accent
				if str contains "&Oacute;" or str contains "&#211;" then
					set str to snr(str, {"&Oacute;", "&#211;"}, {"Ó", "Ó"})
				end if
				
				-- Capital o with circumflex accent
				if str contains "&Ocirc;" or str contains "&#212;" then
					set str to snr(str, {"&Ocirc;", "&#212;"}, {"Ô", "Ô"})
				end if
				
				-- Capital o with tilde
				if str contains "&Otilde;" or str contains "&#213;" then
					set str to snr(str, {"&Otilde;", "&#213;"}, {"Õ", "Õ"})
				end if
				
				-- Capital o with umlaut
				if str contains "&Ouml;" or str contains "&#214;" then
					set str to snr(str, {"&Ouml;", "&#214;"}, {"Ö", "Ö"})
				end if
				
				-- Capital o with slash
				if str contains "&Oslash;" or str contains "&#216;" then
					set str to snr(str, {"&Oslash;", "&#216;"}, {"Ø", "Ø"})
				end if
				
				-- Capital u with grave accent
				if str contains "&Ugrave;" or str contains "&#217;" then
					set str to snr(str, {"&Ugrave;", "&#217;"}, {"Ù", "Ù"})
				end if
				
				-- Capital u with acute accent
				if str contains "&Uacute;" or str contains "&#218;" then
					set str to snr(str, {"&Uacute;", "&#218;"}, {"Ú", "Ú"})
				end if
				
				-- Capital u with circumflex accent
				if str contains "&Ucirc;" or str contains "&#219;" then
					set str to snr(str, {"&Ucirc;", "&#219;"}, {"Û", "Û"})
				end if
				
				-- Capital u with umlaut
				if str contains "&Uuml;" or str contains "&#220;" then
					set str to snr(str, {"&Uuml;", "&#220;"}, {"Ü", "Ü"})
				end if
				
				-- Capital y with acute accent
				if str contains "&Yacute;" or str contains "&#221;" then
					set str to snr(str, {"&Yacute;", "&#221;"}, {"Ý", "Ý"})
				end if
				
				-- Capital thorn (Icelandic)
				if str contains "&THORN;" or str contains "&#222;" then
					set str to snr(str, {"&THORN;", "&#222;"}, {"Þ", "Þ"})
				end if
				
				-- Lowercase sharp s (German)
				if str contains "&szlig;" or str contains "&#223;" then
					set str to snr(str, {"&szlig;", "&#223;"}, {"ß", "ß"})
				end if
				
				-- Lowercase a with grave accent
				if str contains "&agrave;" or str contains "&#224;" then
					set str to snr(str, {"&agrave;", "&#224;"}, {"à", "à"})
				end if
				
				-- Lowercase a with acute accent
				if str contains "&aacute;" or str contains "&#225;" then
					set str to snr(str, {"&aacute;", "&#225;"}, {"á", "á"})
				end if
				
				-- Lowercase a with circumflex accent
				if str contains "&acirc;" or str contains "&#226;" then
					set str to snr(str, {"&acirc;", "&#226;"}, {"â", "â"})
				end if
				
				-- Lowercase a with tilde
				if str contains "&atilde;" or str contains "&#227;" then
					set str to snr(str, {"&atilde;", "&#227;"}, {"ã", "ã"})
				end if
				
				-- Lowercase a with umlaut
				if str contains "&auml;" or str contains "&#228;" then
					set str to snr(str, {"&auml;", "&#228;"}, {"ä", "ä"})
				end if
				
				-- Lowercase a with ring
				if str contains "&aring;" or str contains "&#229;" then
					set str to snr(str, {"&aring;", "&#229;"}, {"å", "å"})
				end if
				
				-- Lowercase ae
				if str contains "&aelig;" or str contains "&#230;" then
					set str to snr(str, {"&aelig;", "&#230;"}, {"æ", "æ"})
				end if
				
				-- Lowercase c with cedilla
				if str contains "&ccedil;" or str contains "&#231;" then
					set str to snr(str, {"&ccedil;", "&#231;"}, {"ç", "ç"})
				end if
				
				-- Lowercase e with grave accent
				if str contains "&egrave;" or str contains "&#232;" then
					set str to snr(str, {"&egrave;", "&#232;"}, {"è", "è"})
				end if
				
				-- Lowercase e with acute accent
				if str contains "&eacute;" or str contains "&#233;" then
					set str to snr(str, {"&eacute;", "&#233;"}, {"é", "é"})
				end if
				
				-- Lowercase e with circumflex accent
				if str contains "&ecirc;" or str contains "&#234;" then
					set str to snr(str, {"&ecirc;", "&#234;"}, {"ê", "ê"})
				end if
				
				-- Lowercase e with umlaut
				if str contains "&euml;" or str contains "&#235;" then
					set str to snr(str, {"&euml;", "&#235;"}, {"ë", "ë"})
				end if
				
				-- Lowercase i with grave accent
				if str contains "&igrave;" or str contains "&#236;" then
					set str to snr(str, {"&igrave;", "&#236;"}, {"ì", "ì"})
				end if
				
				-- Lowercase i with acute accent
				if str contains "&iacute;" or str contains "&#237;" then
					set str to snr(str, {"&iacute;", "&#237;"}, {"í", "í"})
				end if
				
				-- Lowercase i with circumflex accent
				if str contains "&icirc;" or str contains "&#238;" then
					set str to snr(str, {"&icirc;", "&#238;"}, {"î", "î"})
				end if
				
				-- Lowercase i with umlaut
				if str contains "&iuml;" or str contains "&#239;" then
					set str to snr(str, {"&iuml;", "&#239;"}, {"ï", "ï"})
				end if
				
				-- Lowercase eth (Icelandic)
				if str contains "&eth;" or str contains "&#240;" then
					set str to snr(str, {"&eth;", "&#240;"}, {"ð", "ð"})
				end if
				
				-- Lowercase n with tilde
				if str contains "&ntilde;" or str contains "&#241;" then
					set str to snr(str, {"&ntilde;", "&#241;"}, {"ñ", "ñ"})
				end if
				
				-- Lowercase o with grave accent
				if str contains "&ograve;" or str contains "&#242;" then
					set str to snr(str, {"&ograve;", "&#242;"}, {"ò", "ò"})
				end if
				
				-- Lowercase o with acute accent
				if str contains "&oacute;" or str contains "&#243;" then
					set str to snr(str, {"&oacute;", "&#243;"}, {"ó", "ó"})
				end if
				
				-- Lowercase o with circumflex accent
				if str contains "&ocirc;" or str contains "&#244;" then
					set str to snr(str, {"&ocirc;", "&#244;"}, {"ô", "ô"})
				end if
				
				-- Lowercase o with tilde
				if str contains "&otilde;" or str contains "&#245;" then
					set str to snr(str, {"&otilde;", "&#245;"}, {"õ", "õ"})
				end if
				
				-- Lowercase o with umlaut
				if str contains "&ouml;" or str contains "&#246;" then
					set str to snr(str, {"&ouml;", "&#246;"}, {"ö", "ö"})
				end if
				
				-- Lowercase o with slash
				if str contains "&oslash;" or str contains "&#248;" then
					set str to snr(str, {"&oslash;", "&#248;"}, {"ø", "ø"})
				end if
				
				-- Lowercase u with grave accent
				if str contains "&ugrave;" or str contains "&#249;" then
					set str to snr(str, {"&ugrave;", "&#249;"}, {"ù", "ù"})
				end if
				
				-- Lowercase u with acute accent
				if str contains "&uacute;" or str contains "&#250;" then
					set str to snr(str, {"&uacute;", "&#250;"}, {"ú", "ú"})
				end if
				
				-- Lowercase u with circumflex accent
				if str contains "&ucirc;" or str contains "&#251;" then
					set str to snr(str, {"&ucirc;", "&#251;"}, {"û", "û"})
				end if
				
				-- Lowercase u with umlaut
				if str contains "&uuml;" or str contains "&#252;" then
					set str to snr(str, {"&uuml;", "&#252;"}, {"ü", "ü"})
				end if
				
				-- Lowercase y with acute accent
				if str contains "&yacute;" or str contains "&#253;" then
					set str to snr(str, {"&yacute;", "&#253;"}, {"ý", "ý"})
				end if
				
				-- Lowercase thorn (Icelandic)
				if str contains "&thorn;" or str contains "&#254;" then
					set str to snr(str, {"&thorn;", "&#254;"}, {"þ", "þ"})
				end if
				
				-- Lowercase y with umlaut
				if str contains "&yuml;" or str contains "&#255;" then
					set str to snr(str, {"&yuml;", "&#255;"}, {"ÿ", "ÿ"})
				end if
				
				-- Non-breaking space
				if str contains "&nbsp;" or str contains "&#160;" then
					set str to snr(str, {"&nbsp;", "&#160;"}, {" ", " "})
				end if
				
				-- Inverted exclamation mark
				if str contains "&iexcl;" or str contains "&#161;" then
					set str to snr(str, {"&iexcl;", "&#161;"}, {"¡", "¡"})
				end if
				
				-- Cent
				if str contains "&cent;" or str contains "&#162;" then
					set str to snr(str, {"&cent;", "&#162;"}, {"¢", "¢"})
				end if
				
				-- Pound
				if str contains "&pound;" or str contains "&#163;" then
					set str to snr(str, {"&pound;", "&#163;"}, {"£", "£"})
				end if
				
				-- Currency
				if str contains "&curren;" or str contains "&#164;" then
					set str to snr(str, {"&curren;", "&#164;"}, {"¤", "¤"})
				end if
				
				-- Yen
				if str contains "&yen;" or str contains "&#165;" then
					set str to snr(str, {"&yen;", "&#165;"}, {"¥", "¥"})
				end if
				
				-- Broken vertical bar
				if str contains "&brvbar;" or str contains "&#166;" then
					set str to snr(str, {"&brvbar;", "&#166;"}, {"¦", "¦"})
				end if
				
				-- Section
				if str contains "&sect;" or str contains "&#167;" then
					set str to snr(str, {"&sect;", "&#167;"}, {"§", "§"})
				end if
				
				-- Spacing diaeresis
				if str contains "&uml;" or str contains "&#168;" then
					set str to snr(str, {"&uml;", "&#168;"}, {"¨", "¨"})
				end if
				
				-- Copyright
				if str contains "&copy;" or str contains "&#169;" then
					set str to snr(str, {"&copy;", "&#169;"}, {"©", "©"})
				end if
				
				-- Feminine ordinal indicator
				if str contains "&ordf;" or str contains "&#170;" then
					set str to snr(str, {"&ordf;", "&#170;"}, {"ª", "ª"})
				end if
				
				-- Opening/Left angle quotation mark
				if str contains "&laquo;" or str contains "&#171;" then
					set str to snr(str, {"&laquo;", "&#171;"}, {"«", "«"})
				end if
				
				-- Negation
				if str contains "&not;" or str contains "&#172;" then
					set str to snr(str, {"&not;", "&#172;"}, {"¬", "¬"})
				end if
				
				-- Soft hyphen
				if str contains "&shy;" or str contains "&#173;" then
					set str to snr(str, {"&shy;", "&#173;"}, {"­", "­"})
				end if
				
				-- Registered trademark
				if str contains "&reg;" or str contains "&#174;" then
					set str to snr(str, {"&reg;", "&#174;"}, {"®", "®"})
				end if
				
				-- Spacing macron
				if str contains "&macr;" or str contains "&#175;" then
					set str to snr(str, {"&macr;", "&#175;"}, {"¯", "¯"})
				end if
				
				-- Degree
				if str contains "&deg;" or str contains "&#176;" then
					set str to snr(str, {"&deg;", "&#176;"}, {"°", "°"})
				end if
				
				-- Plus or minus
				if str contains "&plusmn;" or str contains "&#177;" then
					set str to snr(str, {"&plusmn;", "&#177;"}, {"±", "±"})
				end if
				
				-- Superscript 2
				if str contains "&sup2;" or str contains "&#178;" then
					set str to snr(str, {"&sup2;", "&#178;"}, {"²", "²"})
				end if
				
				-- Superscript 3
				if str contains "&sup3;" or str contains "&#179;" then
					set str to snr(str, {"&sup3;", "&#179;"}, {"³", "³"})
				end if
				
				-- Spacing acute
				if str contains "&acute;" or str contains "&#180;" then
					set str to snr(str, {"&acute;", "&#180;"}, {"´", "´"})
				end if
				
				-- Micro
				if str contains "&micro;" or str contains "&#181;" then
					set str to snr(str, {"&micro;", "&#181;"}, {"µ", "µ"})
				end if
				
				-- Paragraph
				if str contains "&para;" or str contains "&#182;" then
					set str to snr(str, {"&para;", "&#182;"}, {"¶", "¶"})
				end if
				
				-- Spacing cedilla
				if str contains "&cedil;" or str contains "&#184;" then
					set str to snr(str, {"&cedil;", "&#184;"}, {"¸", "¸"})
				end if
				
				-- Superscript 1
				if str contains "&sup1;" or str contains "&#185;" then
					set str to snr(str, {"&sup1;", "&#185;"}, {"¹", "¹"})
				end if
				
				-- Masculine ordinal indicator
				if str contains "&ordm;" or str contains "&#186;" then
					set str to snr(str, {"&ordm;", "&#186;"}, {"º", "º"})
				end if
				
				-- Closing/Right angle quotation mark
				if str contains "&raquo;" or str contains "&#187;" then
					set str to snr(str, {"&raquo;", "&#187;"}, {"»", "»"})
				end if
				
				-- Fraction 1/4
				if str contains "&frac14;" or str contains "&#188;" then
					set str to snr(str, {"&frac14;", "&#188;"}, {"¼", "¼"})
				end if
				
				-- Fraction 1/2
				if str contains "&frac12;" or str contains "&#189;" then
					set str to snr(str, {"&frac12;", "&#189;"}, {"½", "½"})
				end if
				
				-- Fraction 3/4
				if str contains "&frac34;" or str contains "&#190;" then
					set str to snr(str, {"&frac34;", "&#190;"}, {"¾", "¾"})
				end if
				
				-- Inverted question mark
				if str contains "&iquest;" or str contains "&#191;" then
					set str to snr(str, {"&iquest;", "&#191;"}, {"¿", "¿"})
				end if
				
				-- Multiplication
				if str contains "&times;" or str contains "&#215;" then
					set str to snr(str, {"&times;", "&#215;"}, {"×", "×"})
				end if
				
				-- Divide
				if str contains "&divide;" or str contains "&#247;" then
					set str to snr(str, {"&divide;", "&#247;"}, {"÷", "÷"})
				end if
				
				-- For all
				if str contains "&forall;" or str contains "&#8704;" then
					set str to snr(str, {"&forall;", "&#8704;"}, {"∀", "∀"})
				end if
				
				-- Part
				if str contains "&part;" or str contains "&#8706;" then
					set str to snr(str, {"&part;", "&#8706;"}, {"∂", "∂"})
				end if
				
				-- Exist
				if str contains "&exist;" or str contains "&#8707;" then
					set str to snr(str, {"&exist;", "&#8707;"}, {"∃", "∃"})
				end if
				
				-- Empty
				if str contains "&empty;" or str contains "&#8709;" then
					set str to snr(str, {"&empty;", "&#8709;"}, {"∅", "∅"})
				end if
				
				-- Nabla
				if str contains "&nabla;" or str contains "&#8711;" then
					set str to snr(str, {"&nabla;", "&#8711;"}, {"∇", "∇"})
				end if
				
				-- Is in
				if str contains "&isin;" or str contains "&#8712;" then
					set str to snr(str, {"&isin;", "&#8712;"}, {"∈", "∈"})
				end if
				
				-- Not in
				if str contains "&notin;" or str contains "&#8713;" then
					set str to snr(str, {"&notin;", "&#8713;"}, {"∉", "∉"})
				end if
				
				-- Ni
				if str contains "&ni;" or str contains "&#8715;" then
					set str to snr(str, {"&ni;", "&#8715;"}, {"∋", "∋"})
				end if
				
				-- Product
				if str contains "&prod;" or str contains "&#8719;" then
					set str to snr(str, {"&prod;", "&#8719;"}, {"∏", "∏"})
				end if
				
				-- Sum
				if str contains "&sum;" or str contains "&#8721;" then
					set str to snr(str, {"&sum;", "&#8721;"}, {"∑", "∑"})
				end if
				
				-- Minus
				if str contains "&minus;" or str contains "&#8722;" then
					set str to snr(str, {"&minus;", "&#8722;"}, {"−", "−"})
				end if
				
				-- Asterisk (Lowast)
				if str contains "&lowast;" or str contains "&#8727;" then
					set str to snr(str, {"&lowast;", "&#8727;"}, {"∗", "∗"})
				end if
				
				-- Square root
				if str contains "&radic;" or str contains "&#8730;" then
					set str to snr(str, {"&radic;", "&#8730;"}, {"√", "√"})
				end if
				
				-- Proportional to
				if str contains "&prop;" or str contains "&#8733;" then
					set str to snr(str, {"&prop;", "&#8733;"}, {"∝", "∝"})
				end if
				
				-- Infinity
				if str contains "&infin;" or str contains "&#8734;" then
					set str to snr(str, {"&infin;", "&#8734;"}, {"∞", "∞"})
				end if
				
				-- Angle
				if str contains "&ang;" or str contains "&#8736;" then
					set str to snr(str, {"&ang;", "&#8736;"}, {"∠", "∠"})
				end if
				
				-- And
				if str contains "&and;" or str contains "&#8743;" then
					set str to snr(str, {"&and;", "&#8743;"}, {"∧", "∧"})
				end if
				
				-- Or
				if str contains "&or;" or str contains "&#8744;" then
					set str to snr(str, {"&or;", "&#8744;"}, {"∨", "∨"})
				end if
				
				-- Cap
				if str contains "&cap;" or str contains "&#8745;" then
					set str to snr(str, {"&cap;", "&#8745;"}, {"∩", "∩"})
				end if
				
				-- Cup
				if str contains "&cup;" or str contains "&#8746;" then
					set str to snr(str, {"&cup;", "&#8746;"}, {"∪", "∪"})
				end if
				
				-- Integral
				if str contains "&int;" or str contains "&#8747;" then
					set str to snr(str, {"&int;", "&#8747;"}, {"∫", "∫"})
				end if
				
				-- Therefore
				if str contains "&there4;" or str contains "&#8756;" then
					set str to snr(str, {"&there4;", "&#8756;"}, {"∴", "∴"})
				end if
				
				-- Similar to
				if str contains "&sim;" or str contains "&#8764;" then
					set str to snr(str, {"&sim;", "&#8764;"}, {"∼", "∼"})
				end if
				
				-- Congurent to
				if str contains "&cong;" or str contains "&#8773;" then
					set str to snr(str, {"&cong;", "&#8773;"}, {"≅", "≅"})
				end if
				
				-- Almost equal
				if str contains "&asymp;" or str contains "&#8776;" then
					set str to snr(str, {"&asymp;", "&#8776;"}, {"≈", "≈"})
				end if
				
				-- Not equal
				if str contains "&ne;" or str contains "&#8800;" then
					set str to snr(str, {"&ne;", "&#8800;"}, {"≠", "≠"})
				end if
				
				-- Equivalent
				if str contains "&equiv;" or str contains "&#8801;" then
					set str to snr(str, {"&equiv;", "&#8801;"}, {"≡", "≡"})
				end if
				
				-- Less or equal
				if str contains "&le;" or str contains "&#8804;" then
					set str to snr(str, {"&le;", "&#8804;"}, {"≤", "≤"})
				end if
				
				-- Greater or equal
				if str contains "&ge;" or str contains "&#8805;" then
					set str to snr(str, {"&ge;", "&#8805;"}, {"≥", "≥"})
				end if
				
				-- Subset of
				if str contains "&sub;" or str contains "&#8834;" then
					set str to snr(str, {"&sub;", "&#8834;"}, {"⊂", "⊂"})
				end if
				
				-- Superset of
				if str contains "&sup;" or str contains "&#8835;" then
					set str to snr(str, {"&sup;", "&#8835;"}, {"⊃", "⊃"})
				end if
				
				-- Not subset of
				if str contains "&nsub;" or str contains "&#8836;" then
					set str to snr(str, {"&nsub;", "&#8836;"}, {"⊄", "⊄"})
				end if
				
				-- Subset or equal
				if str contains "&sube;" or str contains "&#8838;" then
					set str to snr(str, {"&sube;", "&#8838;"}, {"⊆", "⊆"})
				end if
				
				-- Superset or equal
				if str contains "&supe;" or str contains "&#8839;" then
					set str to snr(str, {"&supe;", "&#8839;"}, {"⊇", "⊇"})
				end if
				
				-- Circled plus
				if str contains "&oplus;" or str contains "&#8853;" then
					set str to snr(str, {"&oplus;", "&#8853;"}, {"⊕", "⊕"})
				end if
				
				-- Circled times
				if str contains "&otimes;" or str contains "&#8855;" then
					set str to snr(str, {"&otimes;", "&#8855;"}, {"⊗", "⊗"})
				end if
				
				-- Perpendicular
				if str contains "&perp;" or str contains "&#8869;" then
					set str to snr(str, {"&perp;", "&#8869;"}, {"⊥", "⊥"})
				end if
				
				-- Dot operator
				if str contains "&sdot;" or str contains "&#8901;" then
					set str to snr(str, {"&sdot;", "&#8901;"}, {"⋅", "⋅"})
				end if
				
				-- Alpha
				if str contains "&Alpha;" or str contains "&#913;" then
					set str to snr(str, {"&Alpha;", "&#913;"}, {"Α", "Α"})
				end if
				
				-- Beta
				if str contains "&Beta;" or str contains "&#914;" then
					set str to snr(str, {"&Beta;", "&#914;"}, {"Β", "Β"})
				end if
				
				-- Gamma
				if str contains "&Gamma;" or str contains "&#915;" then
					set str to snr(str, {"&Gamma;", "&#915;"}, {"Γ", "Γ"})
				end if
				
				-- Delta
				if str contains "&Delta;" or str contains "&#916;" then
					set str to snr(str, {"&Delta;", "&#916;"}, {"Δ", "Δ"})
				end if
				
				-- Epsilon
				if str contains "&Epsilon;" or str contains "&#917;" then
					set str to snr(str, {"&Epsilon;", "&#917;"}, {"Ε", "Ε"})
				end if
				
				-- Zeta
				if str contains "&Zeta;" or str contains "&#918;" then
					set str to snr(str, {"&Zeta;", "&#918;"}, {"Ζ", "Ζ"})
				end if
				
				-- Eta
				if str contains "&Eta;" or str contains "&#919;" then
					set str to snr(str, {"&Eta;", "&#919;"}, {"Η", "Η"})
				end if
				
				-- Theta
				if str contains "&Theta;" or str contains "&#920;" then
					set str to snr(str, {"&Theta;", "&#920;"}, {"Θ", "Θ"})
				end if
				
				-- Iota
				if str contains "&Iota;" or str contains "&#921;" then
					set str to snr(str, {"&Iota;", "&#921;"}, {"Ι", "Ι"})
				end if
				
				-- Kappa
				if str contains "&Kappa;" or str contains "&#922;" then
					set str to snr(str, {"&Kappa;", "&#922;"}, {"Κ", "Κ"})
				end if
				
				-- Lambda
				if str contains "&Lambda;" or str contains "&#923;" then
					set str to snr(str, {"&Lambda;", "&#923;"}, {"Λ", "Λ"})
				end if
				
				-- Mu
				if str contains "&Mu;" or str contains "&#924;" then
					set str to snr(str, {"&Mu;", "&#924;"}, {"Μ", "Μ"})
				end if
				
				-- Nu
				if str contains "&Nu;" or str contains "&#925;" then
					set str to snr(str, {"&Nu;", "&#925;"}, {"Ν", "Ν"})
				end if
				
				-- Xi
				if str contains "&Xi;" or str contains "&#926;" then
					set str to snr(str, {"&Xi;", "&#926;"}, {"Ξ", "Ξ"})
				end if
				
				-- Omicron
				if str contains "&Omicron;" or str contains "&#927;" then
					set str to snr(str, {"&Omicron;", "&#927;"}, {"Ο", "Ο"})
				end if
				
				-- Pi
				if str contains "&Pi;" or str contains "&#928;" then
					set str to snr(str, {"&Pi;", "&#928;"}, {"Π", "Π"})
				end if
				
				-- Rho
				if str contains "&Rho;" or str contains "&#929;" then
					set str to snr(str, {"&Rho;", "&#929;"}, {"Ρ", "Ρ"})
				end if
				
				-- Sigma
				if str contains "&Sigma;" or str contains "&#931;" then
					set str to snr(str, {"&Sigma;", "&#931;"}, {"Σ", "Σ"})
				end if
				
				-- Tau
				if str contains "&Tau;" or str contains "&#932;" then
					set str to snr(str, {"&Tau;", "&#932;"}, {"Τ", "Τ"})
				end if
				
				-- Upsilon
				if str contains "&Upsilon;" or str contains "&#933;" then
					set str to snr(str, {"&Upsilon;", "&#933;"}, {"Υ", "Υ"})
				end if
				
				-- Phi
				if str contains "&Phi;" or str contains "&#934;" then
					set str to snr(str, {"&Phi;", "&#934;"}, {"Φ", "Φ"})
				end if
				
				-- Chi
				if str contains "&Chi;" or str contains "&#935;" then
					set str to snr(str, {"&Chi;", "&#935;"}, {"Χ", "Χ"})
				end if
				
				-- Psi
				if str contains "&Psi;" or str contains "&#936;" then
					set str to snr(str, {"&Psi;", "&#936;"}, {"Ψ", "Ψ"})
				end if
				
				-- Omega
				if str contains "&Omega;" or str contains "&#937;" then
					set str to snr(str, {"&Omega;", "&#937;"}, {"Ω", "Ω"})
				end if
				
				-- alpha
				if str contains "&alpha;" or str contains "&#945;" then
					set str to snr(str, {"&alpha;", "&#945;"}, {"α", "α"})
				end if
				
				-- beta
				if str contains "&beta;" or str contains "&#946;" then
					set str to snr(str, {"&beta;", "&#946;"}, {"β", "β"})
				end if
				
				-- gamma
				if str contains "&gamma;" or str contains "&#947;" then
					set str to snr(str, {"&gamma;", "&#947;"}, {"γ", "γ"})
				end if
				
				-- delta
				if str contains "&delta;" or str contains "&#948;" then
					set str to snr(str, {"&delta;", "&#948;"}, {"δ", "δ"})
				end if
				
				-- epsilon
				if str contains "&epsilon;" or str contains "&#949;" then
					set str to snr(str, {"&epsilon;", "&#949;"}, {"ε", "ε"})
				end if
				
				-- zeta
				if str contains "&zeta;" or str contains "&#950;" then
					set str to snr(str, {"&zeta;", "&#950;"}, {"ζ", "ζ"})
				end if
				
				-- eta
				if str contains "&eta;" or str contains "&#951;" then
					set str to snr(str, {"&eta;", "&#951;"}, {"η", "η"})
				end if
				
				-- theta
				if str contains "&theta;" or str contains "&#952;" then
					set str to snr(str, {"&theta;", "&#952;"}, {"θ", "θ"})
				end if
				
				-- iota
				if str contains "&iota;" or str contains "&#953;" then
					set str to snr(str, {"&iota;", "&#953;"}, {"ι", "ι"})
				end if
				
				-- kappa
				if str contains "&kappa;" or str contains "&#954;" then
					set str to snr(str, {"&kappa;", "&#954;"}, {"κ", "κ"})
				end if
				
				-- lambda
				if str contains "&lambda;" or str contains "&#955;" then
					set str to snr(str, {"&lambda;", "&#955;"}, {"λ", "λ"})
				end if
				
				-- mu
				if str contains "&mu;" or str contains "&#956;" then
					set str to snr(str, {"&mu;", "&#956;"}, {"μ", "μ"})
				end if
				
				-- nu
				if str contains "&nu;" or str contains "&#957;" then
					set str to snr(str, {"&nu;", "&#957;"}, {"ν", "ν"})
				end if
				
				-- xi
				if str contains "&xi;" or str contains "&#958;" then
					set str to snr(str, {"&xi;", "&#958;"}, {"ξ", "ξ"})
				end if
				
				-- omicron
				if str contains "&omicron;" or str contains "&#959;" then
					set str to snr(str, {"&omicron;", "&#959;"}, {"ο", "ο"})
				end if
				
				-- pi
				if str contains "&pi;" or str contains "&#960;" then
					set str to snr(str, {"&pi;", "&#960;"}, {"π", "π"})
				end if
				
				-- rho
				if str contains "&rho;" or str contains "&#961;" then
					set str to snr(str, {"&rho;", "&#961;"}, {"ρ", "ρ"})
				end if
				
				-- sigmaf
				if str contains "&sigmaf;" or str contains "&#962;" then
					set str to snr(str, {"&sigmaf;", "&#962;"}, {"ς", "ς"})
				end if
				
				-- sigma
				if str contains "&sigma;" or str contains "&#963;" then
					set str to snr(str, {"&sigma;", "&#963;"}, {"σ", "σ"})
				end if
				
				-- tau
				if str contains "&tau;" or str contains "&#964;" then
					set str to snr(str, {"&tau;", "&#964;"}, {"τ", "τ"})
				end if
				
				-- upsilon
				if str contains "&upsilon;" or str contains "&#965;" then
					set str to snr(str, {"&upsilon;", "&#965;"}, {"υ", "υ"})
				end if
				
				-- phi
				if str contains "&phi;" or str contains "&#966;" then
					set str to snr(str, {"&phi;", "&#966;"}, {"φ", "φ"})
				end if
				
				-- chi
				if str contains "&chi;" or str contains "&#967;" then
					set str to snr(str, {"&chi;", "&#967;"}, {"χ", "χ"})
				end if
				
				-- psi
				if str contains "&psi;" or str contains "&#968;" then
					set str to snr(str, {"&psi;", "&#968;"}, {"ψ", "ψ"})
				end if
				
				-- omega
				if str contains "&omega;" or str contains "&#969;" then
					set str to snr(str, {"&omega;", "&#969;"}, {"ω", "ω"})
				end if
				
				-- Theta symbol
				if str contains "&thetasym;" or str contains "&#977;" then
					set str to snr(str, {"&thetasym;", "&#977;"}, {"ϑ", "ϑ"})
				end if
				
				-- Upsilon symbol
				if str contains "&upsih;" or str contains "&#978;" then
					set str to snr(str, {"&upsih;", "&#978;"}, {"ϒ", "ϒ"})
				end if
				
				-- Pi symbol
				if str contains "&piv;" or str contains "&#982;" then
					set str to snr(str, {"&piv;", "&#982;"}, {"ϖ", "ϖ"})
				end if
				
				-- Uppercase ligature OE
				if str contains "&OElig;" or str contains "&#338;" then
					set str to snr(str, {"&OElig;", "&#338;"}, {"Œ", "Œ"})
				end if
				
				-- Lowercase ligature OE
				if str contains "&oelig;" or str contains "&#339;" then
					set str to snr(str, {"&oelig;", "&#339;"}, {"œ", "œ"})
				end if
				
				-- Uppercase S with caron
				if str contains "&Scaron;" or str contains "&#352;" then
					set str to snr(str, {"&Scaron;", "&#352;"}, {"Š", "Š"})
				end if
				
				-- Lowercase S with caron
				if str contains "&scaron;" or str contains "&#353;" then
					set str to snr(str, {"&scaron;", "&#353;"}, {"š", "š"})
				end if
				
				-- Capital Y with diaeres
				if str contains "&Yuml;" or str contains "&#376;" then
					set str to snr(str, {"&Yuml;", "&#376;"}, {"Ÿ", "Ÿ"})
				end if
				
				-- Lowercase with hook
				if str contains "&fnof;" or str contains "&#402;" then
					set str to snr(str, {"&fnof;", "&#402;"}, {"ƒ", "ƒ"})
				end if
				
				-- Circumflex accent
				if str contains "&circ;" or str contains "&#710;" then
					set str to snr(str, {"&circ;", "&#710;"}, {"ˆ", "ˆ"})
				end if
				
				-- Tilde
				if str contains "&tilde;" or str contains "&#732;" then
					set str to snr(str, {"&tilde;", "&#732;"}, {"˜", "˜"})
				end if
				
				-- En space
				if str contains "&ensp;" or str contains "&#8194;" then
					set str to snr(str, {"&ensp;", "&#8194;"}, {" ", " "})
				end if
				
				-- Em space
				if str contains "&emsp;" or str contains "&#8195;" then
					set str to snr(str, {"&emsp;", "&#8195;"}, {" ", " "})
				end if
				
				-- Thin space
				if str contains "&thinsp;" or str contains "&#8201;" then
					set str to snr(str, {"&thinsp;", "&#8201;"}, {" ", " "})
				end if
				
				-- En dash
				if str contains "&ndash;" or str contains "&#8211;" then
					set str to snr(str, {"&ndash;", "&#8211;"}, {"–", "–"})
				end if
				
				-- Em dash
				if str contains "&mdash;" or str contains "&#8212;" then
					set str to snr(str, {"&mdash;", "&#8212;"}, {"—", "—"})
				end if
				
				-- Left single quotation mark
				if str contains "&lsquo;" or str contains "&#8216;" then
					set str to snr(str, {"&lsquo;", "&#8216;"}, {"‘", "‘"})
				end if
				
				-- Right single quotation mark
				if str contains "&rsquo;" or str contains "&#8217;" then
					set str to snr(str, {"&rsquo;", "&#8217;"}, {"’", "’"})
				end if
				
				-- Single low-9 quotation mark
				if str contains "&sbquo;" or str contains "&#8218;" then
					set str to snr(str, {"&sbquo;", "&#8218;"}, {"‚", "‚"})
				end if
				
				-- Left double quotation mark
				if str contains "&ldquo;" or str contains "&#8220;" then
					set str to snr(str, {"&ldquo;", "&#8220;"}, {"“", "“"})
				end if
				
				-- Right double quotation mark
				if str contains "&rdquo;" or str contains "&#8221;" then
					set str to snr(str, {"&rdquo;", "&#8221;"}, {"”", "”"})
				end if
				
				-- Double low-9 quotation mark
				if str contains "&bdquo;" or str contains "&#8222;" then
					set str to snr(str, {"&bdquo;", "&#8222;"}, {"„", "„"})
				end if
				
				-- Dagger
				if str contains "&dagger;" or str contains "&#8224;" then
					set str to snr(str, {"&dagger;", "&#8224;"}, {"†", "†"})
				end if
				
				-- Double dagger
				if str contains "&Dagger;" or str contains "&#8225;" then
					set str to snr(str, {"&Dagger;", "&#8225;"}, {"‡", "‡"})
				end if
				
				-- Bullet
				if str contains "&bull;" or str contains "&#8226;" then
					set str to snr(str, {"&bull;", "&#8226;"}, {"•", "•"})
				end if
				
				-- Horizontal ellipsis
				if str contains "&hellip;" or str contains "&#8230;" then
					set str to snr(str, {"&hellip;", "&#8230;"}, {"…", "…"})
				end if
				
				-- Per mille
				if str contains "&permil;" or str contains "&#8240;" then
					set str to snr(str, {"&permil;", "&#8240;"}, {"‰", "‰"})
				end if
				
				-- Minutes (Degrees)
				if str contains "&prime;" or str contains "&#8242;" then
					set str to snr(str, {"&prime;", "&#8242;"}, {"′", "′"})
				end if
				
				-- Seconds (Degrees)
				if str contains "&Prime;" or str contains "&#8243;" then
					set str to snr(str, {"&Prime;", "&#8243;"}, {"″", "″"})
				end if
				
				-- Single left angle quotation
				if str contains "&lsaquo;" or str contains "&#8249;" then
					set str to snr(str, {"&lsaquo;", "&#8249;"}, {"‹", "‹"})
				end if
				
				-- Single right angle quotation
				if str contains "&rsaquo;" or str contains "&#8250;" then
					set str to snr(str, {"&rsaquo;", "&#8250;"}, {"›", "›"})
				end if
				
				-- Overline
				if str contains "&oline;" or str contains "&#8254;" then
					set str to snr(str, {"&oline;", "&#8254;"}, {"‾", "‾"})
				end if
				
				-- Euro
				if str contains "&euro;" or str contains "&#8364;" then
					set str to snr(str, {"&euro;", "&#8364;"}, {"€", "€"})
				end if
				
				-- Trademark
				if str contains "&trade;" or str contains "&#8482;" then
					set str to snr(str, {"&trade;", "&#8482;"}, {"™", "™"})
				end if
				
				-- Left arrow
				if str contains "&larr;" or str contains "&#8592;" then
					set str to snr(str, {"&larr;", "&#8592;"}, {"←", "←"})
				end if
				
				-- Up arrow
				if str contains "&uarr;" or str contains "&#8593;" then
					set str to snr(str, {"&uarr;", "&#8593;"}, {"↑", "↑"})
				end if
				
				-- Right arrow
				if str contains "&rarr;" or str contains "&#8594;" then
					set str to snr(str, {"&rarr;", "&#8594;"}, {"→", "→"})
				end if
				
				-- Down arrow
				if str contains "&darr;" or str contains "&#8595;" then
					set str to snr(str, {"&darr;", "&#8595;"}, {"↓", "↓"})
				end if
				
				-- Left right arrow
				if str contains "&harr;" or str contains "&#8596;" then
					set str to snr(str, {"&harr;", "&#8596;"}, {"↔", "↔"})
				end if
				
				-- Carriage return arrow
				if str contains "&crarr;" or str contains "&#8629;" then
					set str to snr(str, {"&crarr;", "&#8629;"}, {"↵", "↵"})
				end if
				
				-- Left ceiling
				if str contains "&lceil;" or str contains "&#8968;" then
					set str to snr(str, {"&lceil;", "&#8968;"}, {"⌈", "⌈"})
				end if
				
				-- Right ceiling
				if str contains "&rceil;" or str contains "&#8969;" then
					set str to snr(str, {"&rceil;", "&#8969;"}, {"⌉", "⌉"})
				end if
				
				-- Left floor
				if str contains "&lfloor;" or str contains "&#8970;" then
					set str to snr(str, {"&lfloor;", "&#8970;"}, {"⌊", "⌊"})
				end if
				
				-- Right floor
				if str contains "&rfloor;" or str contains "&#8971;" then
					set str to snr(str, {"&rfloor;", "&#8971;"}, {"⌋", "⌋"})
				end if
				
				-- Lozenge
				if str contains "&loz;" or str contains "&#9674;" then
					set str to snr(str, {"&loz;", "&#9674;"}, {"◊", "◊"})
				end if
				
				-- Spade
				if str contains "&spades;" or str contains "&#9824;" then
					set str to snr(str, {"&spades;", "&#9824;"}, {"♠", "♠"})
				end if
				
				-- Club
				if str contains "&clubs;" or str contains "&#9827;" then
					set str to snr(str, {"&clubs;", "&#9827;"}, {"♣", "♣"})
				end if
				
				-- Heart
				if str contains "&hearts;" or str contains "&#9829;" then
					set str to snr(str, {"&hearts;", "&#9829;"}, {"♥", "♥"})
				end if
				
				-- Diamond
				if str contains "&diams;" or str contains "&#9830;" then
					set str to snr(str, {"&diams;", "&#9830;"}, {"♦", "♦"})
				end if
				
			end considering
			
			return str
			
		end decode
		
		on encode(str)
			
			considering case
				
				-- Ampersand
				if str contains "&" then
					set str to snr(str, "&", "&amp;")
				end if
				
				-- Less-than
				if str contains "<" then
					set str to snr(str, "<", "&lt;")
				end if
				
				-- Greater than
				if str contains ">" then
					set str to snr(str, ">", "&gt;")
				end if
				
				-- Capital a with grave accent
				if str contains "À" then
					set str to snr(str, "À", "&Agrave;")
				end if
				
				-- Capital a with acute accent
				if str contains "Á" then
					set str to snr(str, "Á", "&Aacute;")
				end if
				
				-- Capital a with circumflex accent
				if str contains "Â" then
					set str to snr(str, "Â", "&Acirc;")
				end if
				
				-- Capital a with tilde
				if str contains "Ã" then
					set str to snr(str, "Ã", "&Atilde;")
				end if
				
				-- Capital a with umlaut
				if str contains "Ä" then
					set str to snr(str, "Ä", "&Auml;")
				end if
				
				-- Capital a with ring
				if str contains "Å" then
					set str to snr(str, "Å", "&Aring;")
				end if
				
				-- Capital ae
				if str contains "Æ" then
					set str to snr(str, "Æ", "&AElig;")
				end if
				
				-- Capital c with cedilla
				if str contains "Ç" then
					set str to snr(str, "Ç", "&Ccedil;")
				end if
				
				-- Capital e with grave accent
				if str contains "È" then
					set str to snr(str, "È", "&Egrave;")
				end if
				
				-- Capital e with acute accent
				if str contains "É" then
					set str to snr(str, "É", "&Eacute;")
				end if
				
				-- Capital e with circumflex accent
				if str contains "Ê" then
					set str to snr(str, "Ê", "&Ecirc;")
				end if
				
				-- Capital e with umlaut
				if str contains "Ë" then
					set str to snr(str, "Ë", "&Euml;")
				end if
				
				-- Capital i with grave accent
				if str contains "Ì" then
					set str to snr(str, "Ì", "&Igrave;")
				end if
				
				-- Capital i with accute accent
				if str contains "Í" then
					set str to snr(str, "Í", "&Iacute;")
				end if
				
				-- Capital i with circumflex accent
				if str contains "Î" then
					set str to snr(str, "Î", "&Icirc;")
				end if
				
				-- Capital i with umlaut
				if str contains "Ï" then
					set str to snr(str, "Ï", "&Iuml;")
				end if
				
				-- Capital eth (Icelandic)
				if str contains "Ð" then
					set str to snr(str, "Ð", "&ETH;")
				end if
				
				-- Capital n with tilde
				if str contains "Ñ" then
					set str to snr(str, "Ñ", "&Ntilde;")
				end if
				
				-- Capital o with grave accent
				if str contains "Ò" then
					set str to snr(str, "Ò", "&Ograve;")
				end if
				
				-- Capital o with accute accent
				if str contains "Ó" then
					set str to snr(str, "Ó", "&Oacute;")
				end if
				
				-- Capital o with circumflex accent
				if str contains "Ô" then
					set str to snr(str, "Ô", "&Ocirc;")
				end if
				
				-- Capital o with tilde
				if str contains "Õ" then
					set str to snr(str, "Õ", "&Otilde;")
				end if
				
				-- Capital o with umlaut
				if str contains "Ö" then
					set str to snr(str, "Ö", "&Ouml;")
				end if
				
				-- Capital o with slash
				if str contains "Ø" then
					set str to snr(str, "Ø", "&Oslash;")
				end if
				
				-- Capital u with grave accent
				if str contains "Ù" then
					set str to snr(str, "Ù", "&Ugrave;")
				end if
				
				-- Capital u with acute accent
				if str contains "Ú" then
					set str to snr(str, "Ú", "&Uacute;")
				end if
				
				-- Capital u with circumflex accent
				if str contains "Û" then
					set str to snr(str, "Û", "&Ucirc;")
				end if
				
				-- Capital u with umlaut
				if str contains "Ü" then
					set str to snr(str, "Ü", "&Uuml;")
				end if
				
				-- Capital y with acute accent
				if str contains "Ý" then
					set str to snr(str, "Ý", "&Yacute;")
				end if
				
				-- Capital thorn (Icelandic)
				if str contains "Þ" then
					set str to snr(str, "Þ", "&THORN;")
				end if
				
				-- Lowercase sharp s (German)
				if str contains "ß" then
					set str to snr(str, "ß", "&szlig;")
				end if
				
				-- Lowercase a with grave accent
				if str contains "à" then
					set str to snr(str, "à", "&agrave;")
				end if
				
				-- Lowercase a with acute accent
				if str contains "á" then
					set str to snr(str, "á", "&aacute;")
				end if
				
				-- Lowercase a with circumflex accent
				if str contains "â" then
					set str to snr(str, "â", "&acirc;")
				end if
				
				-- Lowercase a with tilde
				if str contains "ã" then
					set str to snr(str, "ã", "&atilde;")
				end if
				
				-- Lowercase a with umlaut
				if str contains "ä" then
					set str to snr(str, "ä", "&auml;")
				end if
				
				-- Lowercase a with ring
				if str contains "å" then
					set str to snr(str, "å", "&aring;")
				end if
				
				-- Lowercase ae
				if str contains "æ" then
					set str to snr(str, "æ", "&aelig;")
				end if
				
				-- Lowercase c with cedilla
				if str contains "ç" then
					set str to snr(str, "ç", "&ccedil;")
				end if
				
				-- Lowercase e with grave accent
				if str contains "è" then
					set str to snr(str, "è", "&egrave;")
				end if
				
				-- Lowercase e with acute accent
				if str contains "é" then
					set str to snr(str, "é", "&eacute;")
				end if
				
				-- Lowercase e with circumflex accent
				if str contains "ê" then
					set str to snr(str, "ê", "&ecirc;")
				end if
				
				-- Lowercase e with umlaut
				if str contains "ë" then
					set str to snr(str, "ë", "&euml;")
				end if
				
				-- Lowercase i with grave accent
				if str contains "ì" then
					set str to snr(str, "ì", "&igrave;")
				end if
				
				-- Lowercase i with acute accent
				if str contains "í" then
					set str to snr(str, "í", "&iacute;")
				end if
				
				-- Lowercase i with circumflex accent
				if str contains "î" then
					set str to snr(str, "î", "&icirc;")
				end if
				
				-- Lowercase i with umlaut
				if str contains "ï" then
					set str to snr(str, "ï", "&iuml;")
				end if
				
				-- Lowercase eth (Icelandic)
				if str contains "ð" then
					set str to snr(str, "ð", "&eth;")
				end if
				
				-- Lowercase n with tilde
				if str contains "ñ" then
					set str to snr(str, "ñ", "&ntilde;")
				end if
				
				-- Lowercase o with grave accent
				if str contains "ò" then
					set str to snr(str, "ò", "&ograve;")
				end if
				
				-- Lowercase o with acute accent
				if str contains "ó" then
					set str to snr(str, "ó", "&oacute;")
				end if
				
				-- Lowercase o with circumflex accent
				if str contains "ô" then
					set str to snr(str, "ô", "&ocirc;")
				end if
				
				-- Lowercase o with tilde
				if str contains "õ" then
					set str to snr(str, "õ", "&otilde;")
				end if
				
				-- Lowercase o with umlaut
				if str contains "ö" then
					set str to snr(str, "ö", "&ouml;")
				end if
				
				-- Lowercase o with slash
				if str contains "ø" then
					set str to snr(str, "ø", "&oslash;")
				end if
				
				-- Lowercase u with grave accent
				if str contains "ù" then
					set str to snr(str, "ù", "&ugrave;")
				end if
				
				-- Lowercase u with acute accent
				if str contains "ú" then
					set str to snr(str, "ú", "&uacute;")
				end if
				
				-- Lowercase u with circumflex accent
				if str contains "û" then
					set str to snr(str, "û", "&ucirc;")
				end if
				
				-- Lowercase u with umlaut
				if str contains "ü" then
					set str to snr(str, "ü", "&uuml;")
				end if
				
				-- Lowercase y with acute accent
				if str contains "ý" then
					set str to snr(str, "ý", "&yacute;")
				end if
				
				-- Lowercase thorn (Icelandic)
				if str contains "þ" then
					set str to snr(str, "þ", "&thorn;")
				end if
				
				-- Lowercase y with umlaut
				if str contains "ÿ" then
					set str to snr(str, "ÿ", "&yuml;")
				end if
				
				(*
			-- Non-breaking space
			if str contains " " then
				set str to snr(str, " ", "&nbsp;")
			end if
			*)
				
				-- Inverted exclamation mark
				if str contains "¡" then
					set str to snr(str, "¡", "&iexcl;")
				end if
				
				-- Cent
				if str contains "¢" then
					set str to snr(str, "¢", "&cent;")
				end if
				
				-- Pound
				if str contains "£" then
					set str to snr(str, "£", "&pound;")
				end if
				
				-- Currency
				if str contains "¤" then
					set str to snr(str, "¤", "&curren;")
				end if
				
				-- Yen
				if str contains "¥" then
					set str to snr(str, "¥", "&yen;")
				end if
				
				-- Broken vertical bar
				if str contains "¦" then
					set str to snr(str, "¦", "&brvbar;")
				end if
				
				-- Section
				if str contains "§" then
					set str to snr(str, "§", "&sect;")
				end if
				
				-- Spacing diaeresis
				if str contains "¨" then
					set str to snr(str, "¨", "&uml;")
				end if
				
				-- Copyright
				if str contains "©" then
					set str to snr(str, "©", "&copy;")
				end if
				
				-- Feminine ordinal indicator
				if str contains "ª" then
					set str to snr(str, "ª", "&ordf;")
				end if
				
				-- Opening/Left angle quotation mark
				if str contains "«" then
					set str to snr(str, "«", "&laquo;")
				end if
				
				-- Negation
				if str contains "¬" then
					set str to snr(str, "¬", "&not;")
				end if
				
				-- Soft hyphen
				if str contains "­" then
					set str to snr(str, "­", "&shy;")
				end if
				
				-- Registered trademark
				if str contains "®" then
					set str to snr(str, "®", "&reg;")
				end if
				
				-- Spacing macron
				if str contains "¯" then
					set str to snr(str, "¯", "&macr;")
				end if
				
				-- Degree
				if str contains "°" then
					set str to snr(str, "°", "&deg;")
				end if
				
				-- Plus or minus
				if str contains "±" then
					set str to snr(str, "±", "&plusmn;")
				end if
				
				-- Superscript 2
				if str contains "²" then
					set str to snr(str, "²", "&sup2;")
				end if
				
				-- Superscript 3
				if str contains "³" then
					set str to snr(str, "³", "&sup3;")
				end if
				
				-- Spacing acute
				if str contains "´" then
					set str to snr(str, "´", "&acute;")
				end if
				
				-- Micro
				if str contains "µ" then
					set str to snr(str, "µ", "&micro;")
				end if
				
				-- Paragraph
				if str contains "¶" then
					set str to snr(str, "¶", "&para;")
				end if
				
				-- Spacing cedilla
				if str contains "¸" then
					set str to snr(str, "¸", "&cedil;")
				end if
				
				-- Superscript 1
				if str contains "¹" then
					set str to snr(str, "¹", "&sup1;")
				end if
				
				-- Masculine ordinal indicator
				if str contains "º" then
					set str to snr(str, "º", "&ordm;")
				end if
				
				-- Closing/Right angle quotation mark
				if str contains "»" then
					set str to snr(str, "»", "&raquo;")
				end if
				
				-- Fraction 1/4
				if str contains "¼" then
					set str to snr(str, "¼", "&frac14;")
				end if
				
				-- Fraction 1/2
				if str contains "½" then
					set str to snr(str, "½", "&frac12;")
				end if
				
				-- Fraction 3/4
				if str contains "¾" then
					set str to snr(str, "¾", "&frac34;")
				end if
				
				-- Inverted question mark
				if str contains "¿" then
					set str to snr(str, "¿", "&iquest;")
				end if
				
				-- Multiplication
				if str contains "×" then
					set str to snr(str, "×", "&times;")
				end if
				
				-- Divide
				if str contains "÷" then
					set str to snr(str, "÷", "&divide;")
				end if
				
				-- For all
				if str contains "∀" then
					set str to snr(str, "∀", "&forall;")
				end if
				
				-- Part
				if str contains "∂" then
					set str to snr(str, "∂", "&part;")
				end if
				
				-- Exist
				if str contains "∃" then
					set str to snr(str, "∃", "&exist;")
				end if
				
				-- Empty
				if str contains "∅" then
					set str to snr(str, "∅", "&empty;")
				end if
				
				-- Nabla
				if str contains "∇" then
					set str to snr(str, "∇", "&nabla;")
				end if
				
				-- Is in
				if str contains "∈" then
					set str to snr(str, "∈", "&isin;")
				end if
				
				-- Not in
				if str contains "∉" then
					set str to snr(str, "∉", "&notin;")
				end if
				
				-- Ni
				if str contains "∋" then
					set str to snr(str, "∋", "&ni;")
				end if
				
				-- Product
				if str contains "∏" then
					set str to snr(str, "∏", "&prod;")
				end if
				
				-- Sum
				if str contains "∑" then
					set str to snr(str, "∑", "&sum;")
				end if
				
				-- Minus
				if str contains "−" then
					set str to snr(str, "−", "&minus;")
				end if
				
				-- Asterisk (Lowast)
				if str contains "∗" then
					set str to snr(str, "∗", "&lowast;")
				end if
				
				-- Square root
				if str contains "√" then
					set str to snr(str, "√", "&radic;")
				end if
				
				-- Proportional to
				if str contains "∝" then
					set str to snr(str, "∝", "&prop;")
				end if
				
				-- Infinity
				if str contains "∞" then
					set str to snr(str, "∞", "&infin;")
				end if
				
				-- Angle
				if str contains "∠" then
					set str to snr(str, "∠", "&ang;")
				end if
				
				-- And
				if str contains "∧" then
					set str to snr(str, "∧", "&and;")
				end if
				
				-- Or
				if str contains "∨" then
					set str to snr(str, "∨", "&or;")
				end if
				
				-- Cap
				if str contains "∩" then
					set str to snr(str, "∩", "&cap;")
				end if
				
				-- Cup
				if str contains "∪" then
					set str to snr(str, "∪", "&cup;")
				end if
				
				-- Integral
				if str contains "∫" then
					set str to snr(str, "∫", "&int;")
				end if
				
				-- Therefore
				if str contains "∴" then
					set str to snr(str, "∴", "&there4;")
				end if
				
				-- Similar to
				if str contains "∼" then
					set str to snr(str, "∼", "&sim;")
				end if
				
				-- Congurent to
				if str contains "≅" then
					set str to snr(str, "≅", "&cong;")
				end if
				
				-- Almost equal
				if str contains "≈" then
					set str to snr(str, "≈", "&asymp;")
				end if
				
				-- Not equal
				if str contains "≠" then
					set str to snr(str, "≠", "&ne;")
				end if
				
				-- Equivalent
				if str contains "≡" then
					set str to snr(str, "≡", "&equiv;")
				end if
				
				-- Less or equal
				if str contains "≤" then
					set str to snr(str, "≤", "&le;")
				end if
				
				-- Greater or equal
				if str contains "≥" then
					set str to snr(str, "≥", "&ge;")
				end if
				
				-- Subset of
				if str contains "⊂" then
					set str to snr(str, "⊂", "&sub;")
				end if
				
				-- Superset of
				if str contains "⊃" then
					set str to snr(str, "⊃", "&sup;")
				end if
				
				-- Not subset of
				if str contains "⊄" then
					set str to snr(str, "⊄", "&nsub;")
				end if
				
				-- Subset or equal
				if str contains "⊆" then
					set str to snr(str, "⊆", "&sube;")
				end if
				
				-- Superset or equal
				if str contains "⊇" then
					set str to snr(str, "⊇", "&supe;")
				end if
				
				-- Circled plus
				if str contains "⊕" then
					set str to snr(str, "⊕", "&oplus;")
				end if
				
				-- Circled times
				if str contains "⊗" then
					set str to snr(str, "⊗", "&otimes;")
				end if
				
				-- Perpendicular
				if str contains "⊥" then
					set str to snr(str, "⊥", "&perp;")
				end if
				
				-- Dot operator
				if str contains "⋅" then
					set str to snr(str, "⋅", "&sdot;")
				end if
				
				-- Alpha
				if str contains "Α" then
					set str to snr(str, "Α", "&Alpha;")
				end if
				
				-- Beta
				if str contains "Β" then
					set str to snr(str, "Β", "&Beta;")
				end if
				
				-- Gamma
				if str contains "Γ" then
					set str to snr(str, "Γ", "&Gamma;")
				end if
				
				-- Delta
				if str contains "Δ" then
					set str to snr(str, "Δ", "&Delta;")
				end if
				
				-- Epsilon
				if str contains "Ε" then
					set str to snr(str, "Ε", "&Epsilon;")
				end if
				
				-- Zeta
				if str contains "Ζ" then
					set str to snr(str, "Ζ", "&Zeta;")
				end if
				
				-- Eta
				if str contains "Η" then
					set str to snr(str, "Η", "&Eta;")
				end if
				
				-- Theta
				if str contains "Θ" then
					set str to snr(str, "Θ", "&Theta;")
				end if
				
				-- Iota
				if str contains "Ι" then
					set str to snr(str, "Ι", "&Iota;")
				end if
				
				-- Kappa
				if str contains "Κ" then
					set str to snr(str, "Κ", "&Kappa;")
				end if
				
				-- Lambda
				if str contains "Λ" then
					set str to snr(str, "Λ", "&Lambda;")
				end if
				
				-- Mu
				if str contains "Μ" then
					set str to snr(str, "Μ", "&Mu;")
				end if
				
				-- Nu
				if str contains "Ν" then
					set str to snr(str, "Ν", "&Nu;")
				end if
				
				-- Xi
				if str contains "Ξ" then
					set str to snr(str, "Ξ", "&Xi;")
				end if
				
				-- Omicron
				if str contains "Ο" then
					set str to snr(str, "Ο", "&Omicron;")
				end if
				
				-- Pi
				if str contains "Π" then
					set str to snr(str, "Π", "&Pi;")
				end if
				
				-- Rho
				if str contains "Ρ" then
					set str to snr(str, "Ρ", "&Rho;")
				end if
				
				-- Sigma
				if str contains "Σ" then
					set str to snr(str, "Σ", "&Sigma;")
				end if
				
				-- Tau
				if str contains "Τ" then
					set str to snr(str, "Τ", "&Tau;")
				end if
				
				-- Upsilon
				if str contains "Υ" then
					set str to snr(str, "Υ", "&Upsilon;")
				end if
				
				-- Phi
				if str contains "Φ" then
					set str to snr(str, "Φ", "&Phi;")
				end if
				
				-- Chi
				if str contains "Χ" then
					set str to snr(str, "Χ", "&Chi;")
				end if
				
				-- Psi
				if str contains "Ψ" then
					set str to snr(str, "Ψ", "&Psi;")
				end if
				
				-- Omega
				if str contains "Ω" then
					set str to snr(str, "Ω", "&Omega;")
				end if
				
				-- alpha
				if str contains "α" then
					set str to snr(str, "α", "&alpha;")
				end if
				
				-- beta
				if str contains "β" then
					set str to snr(str, "β", "&beta;")
				end if
				
				-- gamma
				if str contains "γ" then
					set str to snr(str, "γ", "&gamma;")
				end if
				
				-- delta
				if str contains "δ" then
					set str to snr(str, "δ", "&delta;")
				end if
				
				-- epsilon
				if str contains "ε" then
					set str to snr(str, "ε", "&epsilon;")
				end if
				
				-- zeta
				if str contains "ζ" then
					set str to snr(str, "ζ", "&zeta;")
				end if
				
				-- eta
				if str contains "η" then
					set str to snr(str, "η", "&eta;")
				end if
				
				-- theta
				if str contains "θ" then
					set str to snr(str, "θ", "&theta;")
				end if
				
				-- iota
				if str contains "ι" then
					set str to snr(str, "ι", "&iota;")
				end if
				
				-- kappa
				if str contains "κ" then
					set str to snr(str, "κ", "&kappa;")
				end if
				
				-- lambda
				if str contains "λ" then
					set str to snr(str, "λ", "&lambda;")
				end if
				
				-- mu
				if str contains "μ" then
					set str to snr(str, "μ", "&mu;")
				end if
				
				-- nu
				if str contains "ν" then
					set str to snr(str, "ν", "&nu;")
				end if
				
				-- xi
				if str contains "ξ" then
					set str to snr(str, "ξ", "&xi;")
				end if
				
				-- omicron
				if str contains "ο" then
					set str to snr(str, "ο", "&omicron;")
				end if
				
				-- pi
				if str contains "π" then
					set str to snr(str, "π", "&pi;")
				end if
				
				-- rho
				if str contains "ρ" then
					set str to snr(str, "ρ", "&rho;")
				end if
				
				-- sigmaf
				if str contains "ς" then
					set str to snr(str, "ς", "&sigmaf;")
				end if
				
				-- sigma
				if str contains "σ" then
					set str to snr(str, "σ", "&sigma;")
				end if
				
				-- tau
				if str contains "τ" then
					set str to snr(str, "τ", "&tau;")
				end if
				
				-- upsilon
				if str contains "υ" then
					set str to snr(str, "υ", "&upsilon;")
				end if
				
				-- phi
				if str contains "φ" then
					set str to snr(str, "φ", "&phi;")
				end if
				
				-- chi
				if str contains "χ" then
					set str to snr(str, "χ", "&chi;")
				end if
				
				-- psi
				if str contains "ψ" then
					set str to snr(str, "ψ", "&psi;")
				end if
				
				-- omega
				if str contains "ω" then
					set str to snr(str, "ω", "&omega;")
				end if
				
				-- Theta symbol
				if str contains "ϑ" then
					set str to snr(str, "ϑ", "&thetasym;")
				end if
				
				-- Upsilon symbol
				if str contains "ϒ" then
					set str to snr(str, "ϒ", "&upsih;")
				end if
				
				-- Pi symbol
				if str contains "ϖ" then
					set str to snr(str, "ϖ", "&piv;")
				end if
				
				-- Uppercase ligature OE
				if str contains "Œ" then
					set str to snr(str, "Œ", "&OElig;")
				end if
				
				-- Lowercase ligature OE
				if str contains "œ" then
					set str to snr(str, "œ", "&oelig;")
				end if
				
				-- Uppercase S with caron
				if str contains "Š" then
					set str to snr(str, "Š", "&Scaron;")
				end if
				
				-- Lowercase S with caron
				if str contains "š" then
					set str to snr(str, "š", "&scaron;")
				end if
				
				-- Capital Y with diaeres
				if str contains "Ÿ" then
					set str to snr(str, "Ÿ", "&Yuml;")
				end if
				
				-- Lowercase with hook
				if str contains "ƒ" then
					set str to snr(str, "ƒ", "&fnof;")
				end if
				
				-- Circumflex accent
				if str contains "ˆ" then
					set str to snr(str, "ˆ", "&circ;")
				end if
				
				-- Tilde
				if str contains "˜" then
					set str to snr(str, "˜", "&tilde;")
				end if
				
				-- En space
				if str contains " " then
					set str to snr(str, " ", "&ensp;")
				end if
				
				-- Em space
				if str contains " " then
					set str to snr(str, " ", "&emsp;")
				end if
				
				-- Thin space
				if str contains " " then
					set str to snr(str, " ", "&thinsp;")
				end if
				
				-- En dash
				if str contains "–" then
					set str to snr(str, "–", "&ndash;")
				end if
				
				-- Em dash
				if str contains "—" then
					set str to snr(str, "—", "&mdash;")
				end if
				
				-- Left single quotation mark
				if str contains "‘" then
					set str to snr(str, "‘", "&lsquo;")
				end if
				
				-- Right single quotation mark
				if str contains "’" then
					set str to snr(str, "’", "&rsquo;")
				end if
				
				-- Single low-9 quotation mark
				if str contains "‚" then
					set str to snr(str, "‚", "&sbquo;")
				end if
				
				-- Left double quotation mark
				if str contains "“" then
					set str to snr(str, "“", "&ldquo;")
				end if
				
				-- Right double quotation mark
				if str contains "”" then
					set str to snr(str, "”", "&rdquo;")
				end if
				
				-- Double low-9 quotation mark
				if str contains "„" then
					set str to snr(str, "„", "&bdquo;")
				end if
				
				-- Dagger
				if str contains "†" then
					set str to snr(str, "†", "&dagger;")
				end if
				
				-- Double dagger
				if str contains "‡" then
					set str to snr(str, "‡", "&Dagger;")
				end if
				
				-- Bullet
				if str contains "•" then
					set str to snr(str, "•", "&bull;")
				end if
				
				-- Horizontal ellipsis
				if str contains "…" then
					set str to snr(str, "…", "&hellip;")
				end if
				
				-- Per mille
				if str contains "‰" then
					set str to snr(str, "‰", "&permil;")
				end if
				
				-- Minutes (Degrees)
				if str contains "′" then
					set str to snr(str, "′", "&prime;")
				end if
				
				-- Seconds (Degrees)
				if str contains "″" then
					set str to snr(str, "″", "&Prime;")
				end if
				
				-- Single left angle quotation
				if str contains "‹" then
					set str to snr(str, "‹", "&lsaquo;")
				end if
				
				-- Single right angle quotation
				if str contains "›" then
					set str to snr(str, "›", "&rsaquo;")
				end if
				
				-- Overline
				if str contains "‾" then
					set str to snr(str, "‾", "&oline;")
				end if
				
				-- Euro
				if str contains "€" then
					set str to snr(str, "€", "&euro;")
				end if
				
				-- Trademark
				if str contains "™" then
					set str to snr(str, "™", "&trade;")
				end if
				
				-- Left arrow
				if str contains "←" then
					set str to snr(str, "←", "&larr;")
				end if
				
				-- Up arrow
				if str contains "↑" then
					set str to snr(str, "↑", "&uarr;")
				end if
				
				-- Right arrow
				if str contains "→" then
					set str to snr(str, "→", "&rarr;")
				end if
				
				-- Down arrow
				if str contains "↓" then
					set str to snr(str, "↓", "&darr;")
				end if
				
				-- Left right arrow
				if str contains "↔" then
					set str to snr(str, "↔", "&harr;")
				end if
				
				-- Carriage return arrow
				if str contains "↵" then
					set str to snr(str, "↵", "&crarr;")
				end if
				
				-- Left ceiling
				if str contains "⌈" then
					set str to snr(str, "⌈", "&lceil;")
				end if
				
				-- Right ceiling
				if str contains "⌉" then
					set str to snr(str, "⌉", "&rceil;")
				end if
				
				-- Left floor
				if str contains "⌊" then
					set str to snr(str, "⌊", "&lfloor;")
				end if
				
				-- Right floor
				if str contains "⌋" then
					set str to snr(str, "⌋", "&rfloor;")
				end if
				
				-- Lozenge
				if str contains "◊" then
					set str to snr(str, "◊", "&loz;")
				end if
				
				-- Spade
				if str contains "♠" then
					set str to snr(str, "♠", "&spades;")
				end if
				
				-- Club
				if str contains "♣" then
					set str to snr(str, "♣", "&clubs;")
				end if
				
				-- Heart
				if str contains "♥" then
					set str to snr(str, "♥", "&hearts;")
				end if
				
				-- Diamond
				if str contains "♦" then
					set str to snr(str, "♦", "&diams;")
				end if
				
			end considering
			
			return str
			
		end encode
		
		on snr(aText, aPattern, aReplacement)
			
			(*	Search for a pattern and replace it in a string. Pattern and replacement can be a list of multiple values. *)
			
			if (class of aPattern) is list and (class of aReplacement) is list then
				
				-- Replace multiple patterns with a corresponding replacement
				
				-- Check patterns and replacements count
				if (count of aPattern) is not (count of aReplacement) then
					error "The count of patterns and replacements needs to match."
				end if
				
				-- Process matching list of patterns and replacements
				repeat with i from 1 to count of aPattern
					set aText to snr(aText, item i of aPattern, item i of aReplacement)
				end repeat
				
				return aText
				
			else if class of aPattern is list then
				
				-- Replace multiple patterns with the same text
				
				repeat with i from 1 to count of aPattern
					set aText to snr(aText, item i of aPattern, aReplacement)
				end repeat
				
				return aText
				
			else
				
				considering case
					
					if aText does not contain aPattern then
						
						return aText
						
					else
						
						set prvDlmt to text item delimiters
						
						-- considering case
						
						try
							set text item delimiters to aPattern
							set tempList to text items of aText
							set text item delimiters to aReplacement
							set aText to tempList as text
						end try
						
						--	end considering
						
						set text item delimiters to prvDlmt
						
						return aText
						
					end if
					
				end considering
				
			end if
			
		end snr
		
	end script
	
	if _mode is "decode" then
		return HTMLEntityDecoder's decode(_str)
	else if _mode is "encode" then
		return HTMLEntityDecoder's encode(_str)
	else
		error "htmlEntityConverter(): Invalid mode: " & _mode & ". Please use decode or encode."
	end if
	
end htmlEntityConverter