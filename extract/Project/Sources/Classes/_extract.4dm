Class extends _CLI

shared Class constructor($parser : Text; $controller : 4D:C1709.Class)
	
	cs:C1710._Logger.new().log(["Create CLI singleton for "+$parser])
	
	Super:C1705($parser; $controller)