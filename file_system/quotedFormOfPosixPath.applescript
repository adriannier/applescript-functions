qpp(path to desktop folder)

on qpp(aPath)
	return quoted form of (POSIX path of (aPath as text))
end qpp