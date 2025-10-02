![version](https://img.shields.io/badge/version-20%2B-E23089)
![platform](https://img.shields.io/static/v1?label=platform&message=mac-intel%20|%20mac-arm%20|%20win-64&color=blue)
[![license](https://img.shields.io/github/license/miyako/extract)](LICENSE)
![downloads](https://img.shields.io/github/downloads/miyako/extract/total)


# extract
tool to extract text from major document formats (namespace: `extract`)

## supported formats

- [x] pdf
- [x] msg
- [ ] eml (not implemented) 
- [x] ppt
- [ ] xls (not implemented)
- [ ] doc (not implemented)
- [x] rtf
- [x] html
- [x] pptx
- [x] xlsx
- [x] docx
- [X] txt

## acknowledgements

* [libolecf](https://github.com/libyal/libolecf)
* [tidy-html5](https://github.com/htacg/tidy-html5)
* [PDFium](https://github.com/PDFium/PDFium)
* [OPC](https://github.com/freuter/libopc)

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

there are 2 ways to synchronous and asynchronous. 

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

the `file` property can be 

* `4D.File`
* `4D.Blob`
* `Text`  



