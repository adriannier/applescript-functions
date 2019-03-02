(*
Returns regular expression matches for the specified pattern and string.
*)

set thePattern to "/Invoice.*(\\d\\d-\\d\\d\\d\\d)/i"

set theString to "Invoice number: 19-12345.
Lorem ipsum dolor sit amet, consetetur sadipscing 
elitr. Invoice 18-54321 At vero eos et accusam et
justo duo dolores et ea rebum. Stet clita kasd."

regex(thePattern, theString)

on regex(aPattern, aString)
	
	set myDelimiter to ("<DELIMITER_" & (random number from 100000 to 999999) as text) & ">"
	
	set phpScript to "
 
		error_reporting(0);
 
		$str = $argv[1];
		$regex = $argv[2];
 
 		$matches = allRegexMatches($regex, $str);
		$matchesAsString = implode('" & myDelimiter & "', $matches);
		
		echo($matchesAsString);
 
 		function allRegexMatches($pattern, $text) {
  
  			@preg_match_all($pattern, $text, $matches, PREG_SET_ORDER);
  
  			if ($matches === NULL) { 
 				return array('?');
 			}
 	
  			$allMatches = array();
  	
  			for ($i = 0; $i < count($matches); $i++ ) {
  	
				if (isset($matches[$i][1]) && trim($matches[$i][1]) != '') {
  		
  					$allMatches[] = trim($matches[$i][1]);
  		
  				}
  				
  			}
  	
  			return $allMatches;
  
  		}"
	
	set shellCommand to "/usr/bin/php -r " & quoted form of phpScript & " " & quoted form of aString & " " & quoted form of aPattern
	
	set phpOutput to do shell script shellCommand
	
	set prvDlmt to text item delimiters
	set text item delimiters to myDelimiter
	set allMatches to text items of phpOutput
	set text item delimiters to prvDlmt
	
	return allMatches
	
end regex