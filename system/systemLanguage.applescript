(*
	Returns the default language.
*)

systemLanguage()

on systemLanguage()

	try
		return first word of (do shell script "defaults read NSGlobalDomain AppleLanguages")
	on error
		return "en"
	end try
		
end systemLanguage