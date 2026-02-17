Class extends _CLI

shared Class constructor($parser : Text; $controller : 4D:C1709.Class)
	
	cs:C1710.logger.new().log([$parser; "Creating"])
	
	Super:C1705($parser; $controller)