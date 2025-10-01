property formats : Collection
property extensions : Collection

Class constructor()
	
	$formats:=[\
		{extension: ".pdf"; parser: "pdfium-parser"}; \
		{extension: ".rtf"; parser: "rtf-parser"}; \
		{extension: ".ppt"; parser: "olecf-parser"}; \
		{extension: ".msg"; parser: "olecf-parser"}; \
		{extension: ".html"; parser: "tidy-parser"}; \
		{extension: ".docx"; parser: "opc-parser"}; \
		{extension: ".xlsx"; parser: "opc-parser"}; \
		{extension: ".txt"; parser: "txt-parser"}; \
		{extension: ".pptx"; parser: "opc-parser"}]
	
	This:C1470["_formats"]:=$formats
	
Function get formats() : Collection
	
	return This:C1470["_formats"]
	
Function get extensions() : Collection
	
	return This:C1470.formats.extract("extension")