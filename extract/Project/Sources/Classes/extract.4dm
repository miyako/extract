property data : Collection

Class extends _CLI

Class constructor($type : Text; $controller : 4D:C1709.Class)
	
	If (Not:C34(OB Instance of:C1731($controller; cs:C1710._extract_Controller)))
		$controller:=cs:C1710._extract_Controller
	End if 
	
	Case of 
		: ($type="html") || ($type=".html") || ($type="text/html")
			Super:C1705("tidy-parser"; $controller)
		: ($type="msg") || ($type=".msg") || ($type="application/vnd.ms-outlook")
			Super:C1705("olecf-parser"; $controller)
		: ($type="ppt") || ($type=".ppt") || ($type="application/vnd.ms-powerpoint")
			Super:C1705("olecf-parser"; $controller)
		: ($type="rtf") || ($type=".rtf") || ($type="application/rtf")
			Super:C1705("rtf-parser"; $controller)
		: ($type="pdf") || ($type=".pdf") || ($type="application/pdf")
			Super:C1705("pdfium-parser"; $controller)
		Else 
			TRACE:C157
	End case 
	
Function get worker() : 4D:C1709.SystemWorker
	
	return This:C1470.controller.worker
	
Function terminate()
	
	This:C1470.controller.terminate()
	
Function getText($option : Variant; $formula : 4D:C1709.Function) : Collection
	
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
			: (OB Instance of:C1731($option.file; 4D:C1709.File)) && ($option.file.exists)
				$command+=" -i "
				$command+=This:C1470.escape(This:C1470.expand($option.file).path)
			: (OB Instance of:C1731($option.file; 4D:C1709.Blob)) || (Value type:C1509($option.file)=Is BLOB:K8:12) || (Value type:C1509($option.file)=Is text:K8:3)
				$command+=" - "
				$isStream:=True:C214
		End case 
		
		If (Not:C34($stdOut))
			$command+=" -o "
			$command+=This:C1470.escape(This:C1470.expand($option.output).path)
		End if 
		
		$command+=" -r "
		
		var $worker : 4D:C1709.SystemWorker
		$worker:=This:C1470.controller.execute($command; $isStream ? $option.file : Null:C1517).worker
		
		If (Not:C34($isAsync))
			$worker.wait()
		End if 
		
		If ($stdOut) && (Not:C34($isAsync))
			$results.push(This:C1470.controller.stdOut)
			This:C1470.controller.clear()
		End if 
		
	End for each 
	
	If ($stdOut) && (Not:C34($isAsync))
		return $results
	End if 