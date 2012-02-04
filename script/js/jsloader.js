var JSLoader = {
	"author"   : "Adrien 'Larandar' Dudouit",
	"version"  : "0.9.0",
	"license"  : "M.I.T License"
};

JSLoader.manifest = {
	"Loader"          : "script/jsloader.js",
	"HTML5 Shiv"      : "script/html5shiv.min.js",
	"HTML5 PrintShiv" : "script/html5shiv-printshiv.min.js",
	"jQuery"          : "script/jquery-1.7.1.min.js",
	"jQuery UI"       : "script/jquery-ui-1.8.17.min.js"
};

JSLoader.load = function(name, insert) {
	if (!insert) {insert = "";};
	
	var script  = document.createElement("script");
	
	script.type = "text/javascript";
	script.src  = JSLoader.manifest[ name ];
	script.innerHTML = insert;
	
	document.getElementsByTagName("head")[0].appendChild(script);
	
}