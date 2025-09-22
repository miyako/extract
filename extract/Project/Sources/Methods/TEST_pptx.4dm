//%attributes = {"invisible":true}
#DECLARE($params : Object)

If (Count parameters:C259=0)
	
	//execute in a worker to process callbacks
	CALL WORKER:C1389(1; Current method name:C684; {})
	
Else 
	
	var $extract : cs:C1710.extract
	$extract:=cs:C1710.extract.new(".pptx")
	
	var $srcFolder : 4D:C1709.Folder
	$srcFolder:=Folder:C1567(fk documents folder:K87:21).folder("samples/pptx")
	
	ASSERT:C1129($srcFolder.exists)
	
	var $dstFolder : 4D:C1709.Folder
	$dstFolder:=Folder:C1567(fk desktop folder:K87:19).folder("extract/pptx")
	$dstFolder.create()
	
	$files:=$srcFolder.files(fk ignore invisible:K87:22)
	$files:=$files.slice(0; 3)
	
	var $data : 4D:C1709.Blob
	
	$tasks:=[]
	//For each ($file; $files)
	//$tasks.push({file: $file})
	//End for each 
	
	//file to text sync✅
	//$texts:=$extract.getText($tasks)
	
	//file to text async✅
	//$extract.getText($tasks; Formula(onResponse))
	
	For each ($file; $files)
		$tasks.push({file: $file.getContent()})
	End for each 
	
	//blob to text sync✅
	$texts:=$extract.getText($tasks)
	
	//blob to text async✅
	//$extract.getText($tasks; Formula(onResponse))
	
End if 