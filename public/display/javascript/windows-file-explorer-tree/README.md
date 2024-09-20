# jQueryFileExplorer
Inspired by [jQueryFiletree](https://github.com/jqueryfiletree/jqueryfiletree). Most of the icons in the images folder are from [jQueryFiletree](https://github.com/jqueryfiletree/jqueryfiletree/tree/master/dist/images).  
[Split.js](https://split.js.org/) is included and used to provide split function. It can be excluded if panel resize is not required.
## Usage
```
$(selector).jQueryFileExplorer({
	root: "/",
	rootLabel: "Server",
	script: "https://localhost:44316/FileExplorer/GetPath",
	fileScript: "https://localhost:44316/FileExplorer/GetPath"
});)
```
## Parameters:
 - root: the path of the root passed to the backend url or function
- rootLabel: the label of the root shown in the file explorer
- script: the URL or a function that responds with folder information.
- fileScript: a function or a URL to download the file when a file is clicked
### Note:
- If the script/fileScript is a function, an object parameter {path: 'path'} is passed to the function. If the script/fileScript is a URL, a parameter 'path' with the path of the clicked folder/file is passed to the URL via POST(for folders) or GET(for files).
- The folder information received from the URL or function should be an **array** of objects like this:
```
[
	{
		label: string (e.g.: 'folder1' or 'pic.jpg')
		ext: string (e.g.: 'jpg'):
		path: string (e.g.: 'C:/Windows' or 'C:/Temp/pic.jpg')
		isFolder: bool
		isDrive: bool
		hasSubfolder: bool
		subitems:array of string (e.g.: ['1/1/2021', '100,000'])
	},
...
]
```

## Screenshot
![enter image description here](https://github.com/edmlin/jQueryFileExplorer/raw/master/Demo.jpg)
