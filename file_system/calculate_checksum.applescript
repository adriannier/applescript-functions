set examplePath to (path to preferences folder from user domain as text) & "com.apple.Finder.plist"

log md5(examplePath)

log sha1(examplePath)

log sha256(examplePath)

log sha512(examplePath)

on md5(aPath)
	
	return last word of (do shell script "/sbin/md5 " & quoted form of (POSIX path of aPath))
	
end md5

on sha1(aPath)
	
	return first word of (do shell script "/usr/bin/shasum -a 1 " & quoted form of (POSIX path of aPath))
	
end sha1

on sha256(aPath)
	
	return first word of (do shell script "/usr/bin/shasum -a 256 " & quoted form of (POSIX path of aPath))
	
end sha256

on sha512(aPath)
	
	return first word of (do shell script "/usr/bin/shasum -a 512 " & quoted form of (POSIX path of aPath))
	
end sha512