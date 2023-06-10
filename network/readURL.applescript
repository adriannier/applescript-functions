readURL("https://apple.com")

on readURL(aURL)
	
	set userAgent to "Mozilla/5.0 (Macintosh; Intel Mac OS X 13_3_1) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/16.4 Safari/605.1.15"
	
	return do shell script "curl --ssl-reqd --fail --no-progress-meter --connect-timeout 20 --retry 3 --retry-max-time 30 --location --user-agent " & quoted form of userAgent & " " & quoted form of aURL
	
end readURL