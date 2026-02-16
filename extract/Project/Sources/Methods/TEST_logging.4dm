//%attributes = {}
var $Logger : cs:C1710.Logger
$Logger:=cs:C1710.Logger.new()

var $path : Text
$path:=$Logger.path

For ($i; 1; 100)
	$Logger.log(["this"; "is"; "a"; "test"])
End for 