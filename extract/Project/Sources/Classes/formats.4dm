property formats : Collection
property extensions : Collection

shared singleton Class constructor()
	
	$formats:=[\
		{extension: ".pdf"; parser: "pdfium-parser"}; \
		{extension: ".rtf"; parser: "rtf-parser"}; \
		{extension: ".ppt"; parser: "olecf-parser"}; \
		{extension: ".msg"; parser: "olecf-parser"}; \
		{extension: ".doc"; parser: "olecf-parser"}; \
		{extension: ".html"; parser: "tidy-parser"}; \
		{extension: ".docx"; parser: "opc-parser"}; \
		{extension: ".xlsx"; parser: "opc-parser"}; \
		{extension: ".xls"; parser: "xls-parser"}; \
		{extension: ".txt"; parser: "txt-parser"}; \
		{extension: ".eml"; parser: "gmime-parser"}; \
		{extension: ".jpg"; parser: "ocrs-parser"}; \
		{extension: ".jpeg"; parser: "ocrs-parser"}; \
		{extension: ".gif"; parser: "ocrs-parser"}; \
		{extension: ".ico"; parser: "ocrs-parser"}; \
		{extension: ".bmp"; parser: "ocrs-parser"}; \
		{extension: ".webp"; parser: "ocrs-parser"}; \
		{extension: ".pnm"; parser: "ocrs-parser"}; \
		{extension: ".png"; parser: "ocrs-parser"}; \
		{extension: ".pptx"; parser: "opc-parser"}]
	
	This:C1470["_formats"]:=$formats.copy(ck shared:K85:29)
	
Function get formats() : Collection
	
	return This:C1470["_formats"]
	
Function get extensions() : Collection
	
	return This:C1470.formats.extract("extension")