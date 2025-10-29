![version](https://img.shields.io/badge/version-20%2B-E23089)
![platform](https://img.shields.io/static/v1?label=platform&message=mac-intel%20|%20mac-arm%20|%20win-64&color=blue)
[![license](https://img.shields.io/github/license/miyako/extract)](LICENSE)
![downloads](https://img.shields.io/github/downloads/miyako/extract/total)


# extract
tool to extract text from major document formats (namespace: `extract`)

## supported formats

|format|parser|remarks|
|-|-|-|
|xls|[xls-parser](https://github.com/miyako/xls-parser/)|cells comma delimited|
|xlsx|[opc-parser](https://github.com/miyako/opc-parser/)|cells comma delimited|
|pdf|[pdfium-parser](https://github.com/miyako/pdfium-parser/)|
|msg|[olecf-parser](https://github.com/miyako/olecf-parser/)|subject+body|
|eml|[gmime-parser](https://github.com/miyako/gmime-parser/)|subject+body|
|rtf|[rtf-parser](https://github.com/miyako/rtf-parser/)|
|txt|[txt-parser](https://github.com/miyako/txt-parser/)|
|html|[tidy-parser](https://github.com/miyako/tidy-parser/)|
|ppt|[olecf-parser](https://github.com/miyako/olecf-parser/)|
|pptx|[opc-parser](https://github.com/miyako/opc-parser/)|
|doc|[olecf-parser](https://github.com/miyako/olecf-parser/)|with control characters|
|docx|[opc-parser](https://github.com/miyako/opc-parser/)|without header/footer|
|jpg|[ocrs-parser](https://github.com/miyako/ocrs-parser/)|only latin alphabet|
|gif|[ocrs-parser](https://github.com/miyako/ocrs-parser/)|only latin alphabet|
|ico|[ocrs-parser](https://github.com/miyako/ocrs-parser/)|only latin alphabet|
|bmp|[ocrs-parser](https://github.com/miyako/ocrs-parser/)|only latin alphabet|
|webp|[ocrs-parser](https://github.com/miyako/ocrs-parser/)|only latin alphabet|
|pnm|[ocrs-parser](https://github.com/miyako/ocrs-parser/)|only latin alphabet|
|png|[ocrs-parser](https://github.com/miyako/ocrs-parser/)|only latin alphabet|

## acknowledgements

* [libolecf](https://github.com/libyal/libolecf)
* [tidy-html5](https://github.com/htacg/tidy-html5)
* [PDFium](https://github.com/PDFium/PDFium)
* [OPC](https://github.com/freuter/libopc)
* [ocrs](https://github.com/robertknight/ocrs)

## usage

instantiate the class passing an extension as parameter.

```4d
var $extract : cs.extract.extract
$extract:=cs.extract.extract.new(".docx")
```

use `cs.extract.formats` to get the list of supported formats. 

```4d
$extensions:=cs.extract.formats.new().extensions
```

there are 2 ways to invoke `.getText()`; synchronous and asynchronous. 

**synchronous**: pass a single parameter and receive a collection of results in return.

```4d
$texts:=$extract.getText(${file: $file})
```

you can pass a single object or a collection of objects in a single call.

**asynchronous**: pass a second formula parameter. an empty collection is returned at this point.

the formula should have the following signature:

```4d
#DECLARE($worker : 4D.SystemWorker; $params : Object)

var $text : Text
$text:=$worker.response
```

> [!TIP]
> whatever value you pass in `data` is returned in `context`

```4d
$extract.getText({file: $file.getContent(); data: $file}; Formula(onResponse))
```

```4d
#DECLARE($worker : 4D.SystemWorker; $params : Object)

var $text : Text
$text:=$worker.response
$file:=$params.context
```

use this to match input against output.

|property|type|description|
|-|-|-|
|`file`|`4D.File` `4D.Blob` `Text`|input|
|`json`|`Boolean`|default: `false`|
