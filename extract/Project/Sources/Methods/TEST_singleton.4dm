//%attributes = {"invisible":true}
#DECLARE($params : Object)

If (Count parameters:C259=0)
	
	//execute in a worker to process callbacks
	CALL WORKER:C1389("test"; Current method name:C684; {})
	
Else 
	
	var $srcFolder : 4D:C1709.Folder
	$srcFolder:=Folder:C1567(fk documents folder:K87:21).folder("samples")
	
	ASSERT:C1129($srcFolder.exists)
	
	var $dstFolder : 4D:C1709.Folder
	$dstFolder:=Folder:C1567(fk desktop folder:K87:19).folder("extract")
	$dstFolder.delete(Delete with contents:K24:24)
	$dstFolder.create()
	
	$files:=$srcFolder.files(fk ignore invisible:K87:22)
	
	For each ($file; $files)
		var $extract : cs:C1710.extract  //shared singleton
		$extract:=cs:C1710.extract.new($file.extension)
		$data:={dst: $dstFolder; src: $file}
		$task:={file: $file.getContent(); data: $data}
		$extract.getText($task; Formula:C1597(onResponse))
	End for each 
	
End if 

//callbacks will fire only if we exit the method