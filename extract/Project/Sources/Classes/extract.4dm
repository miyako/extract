property extract : cs:C1710._extract

Class constructor($type : Text; $class : 4D:C1709.Class)
	
	var $controller : 4D:C1709.Class
	var $superclass : 4D:C1709.Class
	$superclass:=$class.superclass
	$controller:=cs:C1710._CLI_Controller
	
	While ($superclass#Null:C1517)
		If ($superclass.name=$controller.name)
			$controller:=$class
			break
		End if 
		$superclass:=$superclass.superclass
	End while 
	
	var $formats : Collection
	$formats:=cs:C1710.formats.new().formats
	
	var $format : Object
	$format:=$formats.query("extension === :1"; $type).first()
	
	If ($format=Null:C1517)
		return 
	End if 
	
	Case of 
		: ($format.extension=".pdf")
			This:C1470.extract:=cs:C1710._extract_pdf.new($format.parser; $controller)
		: ($format.extension=".ppt")
			This:C1470.extract:=cs:C1710._extract_ppt.new($format.parser; $controller)
		: ($format.extension=".rtf")
			This:C1470.extract:=cs:C1710._extract_rtf.new($format.parser; $controller)
		: ($format.extension=".msg")
			This:C1470.extract:=cs:C1710._extract_msg.new($format.parser; $controller)
		: ($format.extension=".doc")
			This:C1470.extract:=cs:C1710._extract_doc.new($format.parser; $controller)
		: ($format.extension=".html")
			This:C1470.extract:=cs:C1710._extract_html.new($format.parser; $controller)
		: ($format.extension=".docx")
			This:C1470.extract:=cs:C1710._extract_docx.new($format.parser; $controller)
		: ($format.extension=".xlsx")
			This:C1470.extract:=cs:C1710._extract_xlsx.new($format.parser; $controller)
		: ($format.extension=".xls")
			This:C1470.extract:=cs:C1710._extract_xls.new($format.parser; $controller)
		: ($format.extension=".txt")
			This:C1470.extract:=cs:C1710._extract_txt.new($format.parser; $controller)
		: ($format.extension=".eml")
			This:C1470.extract:=cs:C1710._extract_eml.new($format.parser; $controller)
		: ($format.extension=".jpg")\
			 || ($format.extension=".jpeg")\
			 || ($format.extension=".gif")\
			 || ($format.extension=".ico")\
			 || ($format.extension=".bmp")\
			 || ($format.extension=".webp")\
			 || ($format.extension=".pnm")\
			 || ($format.extension=".png")
			This:C1470.extract:=cs:C1710._extract_jpg.new($format.parser; $controller)
		: ($format.extension=".pptx")
			This:C1470.extract:=cs:C1710._extract_pptx.new($format.parser; $controller)
		Else 
			return 
	End case 
	
Function get worker() : 4D:C1709.SystemWorker
	
	return This:C1470.workers.first()
	
Function get workers() : Collection
	
	If (This:C1470.extract=Null:C1517)
		return 
	End if 
	
	return This:C1470.extract.controller.workers
	
Function terminate()
	
	If (This:C1470.extract=Null:C1517)
		return 
	End if 
	
	This:C1470.extract.controller.terminate()
	
Function getText($option : Variant; $formula : 4D:C1709.Function; $json : Boolean) : Collection
	
	If (This:C1470.extract=Null:C1517)
		return 
	End if 
	
	var $detectionModel; $recognitionModel : 4D:C1709.File
	
	Case of 
		: (This:C1470.extract.executableName="ocrs-parser")
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
		//once
		If (This:C1470.extract.controller._onResponse=Null:C1517)
			Use (This:C1470.extract.controller)
				This:C1470.extract.controller._onResponse:=$formula
			End use 
		End if 
	End if 
	
	For each ($option; $options)
		
		If ($option=Null:C1517) || (Value type:C1509($option)#Is object:K8:27)
			continue
		End if 
		
		$stdOut:=Not:C34(OB Instance of:C1731($option.output; 4D:C1709.File))
		
		$command:=This:C1470.extract.escape(This:C1470.extract.executablePath)
		
		Case of 
			: (This:C1470.extract.executableName="ocrs-parser")
				
				$command+=" --detect-model "
				$command+=This:C1470.extract.escape(This:C1470.extract.expand($detectionModel).path)
				
				$command+=" --rec-model "
				$command+=This:C1470.extract.escape(This:C1470.extract.expand($recognitionModel).path)
				
		End case 
		
		Case of 
			: (Value type:C1509($option.file)=Is object:K8:27) && (OB Instance of:C1731($option.file; 4D:C1709.File)) && ($option.file.exists)
				$command+=" -i "
				$command+=This:C1470.extract.escape(This:C1470.extract.expand($option.file).path)
			: ((Value type:C1509($option.file)=Is object:K8:27) && (OB Instance of:C1731($option.file; 4D:C1709.Blob))) || (Value type:C1509($option.file)=Is BLOB:K8:12) || (Value type:C1509($option.file)=Is text:K8:3)
				$command+=" - "
				$isStream:=True:C214
		End case 
		
		If (Not:C34($stdOut))
			$command+=" -o "
			$command+=This:C1470.extract.escape(This:C1470.extract.expand($option.output).path)
		End if 
		
		If ($option.json#Null:C1517) && (Value type:C1509($option.json)=Is boolean:K8:9) && ($option.json)
			//default
		Else 
			$command+=" -r "
		End if 
		
		var $worker : 4D:C1709.SystemWorker
		$worker:=This:C1470.extract.controller.execute($command; $isStream ? $option.file : Null:C1517; $option.data).worker
		
		If (Not:C34($isAsync))
			$worker.wait()
		End if 
		
		If (Not:C34($isAsync))
			If ($stdOut)
				$results.push($worker.response)
			Else 
				$results.push(Null:C1517)
			End if 
		End if 
		
	End for each 
	
	If (Not:C34($isAsync))
		return $results
	End if 