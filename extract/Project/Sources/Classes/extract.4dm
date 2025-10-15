Class extends _CLI

Class constructor($type : Text; $controller : 4D:C1709.Class)
	
	If (Not:C34(OB Instance of:C1731($controller; cs:C1710._extract_Controller)))
		$controller:=cs:C1710._extract_Controller
	End if 
	
	var $formats : Collection
	$formats:=cs:C1710.formats.new().formats
	
	var $format : Object
	$format:=$formats.query("extension === :1"; $type).first()
	
	If ($format=Null:C1517)
		return 
	End if 
	
	Super:C1705($format.parser; $controller)
	
Function get worker() : 4D:C1709.SystemWorker
	
	return This:C1470.controller.worker
	
Function terminate()
	
	This:C1470.controller.terminate()
	
Function getText($option : Variant; $formula : 4D:C1709.Function) : Collection
	
	var $detectionModel; $recognitionModel : 4D:C1709.File
	
	Case of 
		: (This:C1470.executableName="ocrs-parser")
			$detectionModel:=File:C1566("/RESOURCES/ocrs/text-detection.rten")
			$recognitionModel:=File:C1566("/RESOURCES/ocrs/text-recognition.rten")
	End case 
	
	var $stdOut; $isStream; $isAsync : Boolean
	var $options : Collection
	var $results : Collection
	$results:=[]
	
	Case of 
		: (Value type:C1509($option)=Is object:K8:27)
			$options:=[$option]
		: (Value type:C1509($option)=Is collection:K8:32)
			$options:=$option
		Else 
			$options:=[]
	End case 
	
	var $commands : Collection
	$commands:=[]
	
	If (OB Instance of:C1731($formula; 4D:C1709.Function))
		$isAsync:=True:C214
		This:C1470.controller.onResponse:=$formula
	End if 
	
	For each ($option; $options)
		
		If ($option=Null:C1517) || (Value type:C1509($option)#Is object:K8:27)
			continue
		End if 
		
		$stdOut:=Not:C34(OB Instance of:C1731($option.output; 4D:C1709.File))
		
		$command:=This:C1470.escape(This:C1470.executablePath)
		
		Case of 
			: (This:C1470.executableName="ocrs-parser")
				
				$command+=" --detect-model "
				$command+=This:C1470.escape(This:C1470.expand($detectionModel).path)
				
				$command+=" --rec-model "
				$command+=This:C1470.escape(This:C1470.expand($recognitionModel).path)
				
		End case 
		
		Case of 
			: (Value type:C1509($option.file)=Is object:K8:27) && (OB Instance of:C1731($option.file; 4D:C1709.File)) && ($option.file.exists)
				$command+=" -i "
				$command+=This:C1470.escape(This:C1470.expand($option.file).path)
			: ((Value type:C1509($option.file)=Is object:K8:27) && (OB Instance of:C1731($option.file; 4D:C1709.Blob))) || (Value type:C1509($option.file)=Is BLOB:K8:12) || (Value type:C1509($option.file)=Is text:K8:3)
				$command+=" - "
				$isStream:=True:C214
		End case 
		
		If (Not:C34($stdOut))
			$command+=" -o "
			$command+=This:C1470.escape(This:C1470.expand($option.output).path)
		End if 
		
		$command+=" -r "
		
		var $worker : 4D:C1709.SystemWorker
		$worker:=This:C1470.controller.execute($command; $isStream ? $option.file : Null:C1517; $option.data).worker
		
		If (Not:C34($isAsync))
			$worker.wait()
		End if 
		
		If ($stdOut) && (Not:C34($isAsync))
			//%W-550.26
			//%W-550.2
			$results.push(This:C1470.controller.stdOut)
			This:C1470.controller.clear()
			//%W+550.2
			//%W+550.26
		End if 
		
	End for each 
	
	If ($stdOut) && (Not:C34($isAsync))
		return $results
	End if 