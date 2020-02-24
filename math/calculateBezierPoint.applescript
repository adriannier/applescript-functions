set timeScale to 100
repeat with i from 0 to timeScale - 1
	log calculateBezierPoint(i / timeScale, {10, 10}, {10, 300}, {300, 700}, {700, 700})
end repeat

on calculateBezierPoint(t, p0, p1, p2, p3)
	
	-- From: https://stackoverflow.com/questions/9494167/move-an-object-on-on-a-bézier-curve-path
	
	set u to 1 - t
	set tt to t * t
	set uu to u * u
	set uuu to uu * u
	set ttt to tt * t
	
	set x to (item 1 of p0) * uuu
	set y to (item 2 of p0) * uuu
	
	set x to x + 3 * uu * t * (item 1 of p1)
	set y to y + 3 * uu * t * (item 2 of p1)
	
	set x to x + 3 * u * tt * (item 1 of p2)
	set y to y + 3 * u * tt * (item 2 of p2)
	
	set x to x + ttt * (item 1 of p3)
	set y to y + ttt * (item 2 of p3)
	
	return {round x, round y}
	
end calculateBezierPoint