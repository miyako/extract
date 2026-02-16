property fileHandle : 4D:C1709.FileHandle
property file : 4D:C1709.File

Class constructor($file : 4D:C1709.File)
	
	This:C1470.file:=$file
	
Function log($messages : Collection)
/*
`4D.FileHandle` can't be a property of a shared object;
Use a singular process instance instead of a shared singleton
*/
	If (This:C1470.fileHandle=Null:C1517) || (Not:C34(This:C1470.file.exists))
		This:C1470.fileHandle:=This:C1470.file.open("append")
	End if 
	
	Try(This:C1470.fileHandle.writeLine([Timestamp:C1445].combine($messages).join("\t"; ck ignore null or empty:K85:5)))