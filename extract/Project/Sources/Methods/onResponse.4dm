//%attributes = {"invisible":true,"preemptive":"capable"}
#DECLARE($worker : 4D:C1709.SystemWorker; $params : Object)

var $text : Text
$text:=$worker.response

var $folder : 4D:C1709.Folder
var $file : 4D:C1709.File
$folder:=$params.context.dst
$file:=$params.context.src

$folder.file($file.fullName).setText($text)