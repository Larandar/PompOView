PompOView = { "version" : "∫ 0.1" };

// Fonctions basiques qui permettent de bénéficier de la configuration du serveur.
PompOView.setAjax = function (url) { PompOView.ajaxURL = url ; };
PompOView.ajax    = function (val) { return PompOView.ajaxURL + val ;};

// Fonction utilisé pour initialisé toutes les composantes JavaScript/jQuery de la page lorsque la page à charger.
PompOView.ready   = function () {
	PompOView.UI.init();
};

PompOView.UI = { "version" : "0.1" , "loaded" : {}, "counter" : 1, "vars_map" : {}};
PompOView.UI.init      = function () {
	$('#pompoview-tabui').tabs({closable: true}).find( ".ui-tabs-nav" ).sortable({ axis: "x" });
};

PompOView.UI.initButton = function () {
	$( "button.ui-close-button, button").button();
}

PompOView.UI.isLoaded  = function (type) { return Boolean(PompOView.UI.loaded[type]) ;};
PompOView.UI.formatID  = function (count) { return "ui-tabs-" +  count ; };
PompOView.UI.setLoaded = function (type,val) { PompOView.UI.loaded[type] = val ;};
PompOView.UI.closeTab  = function (url,id) {
	PompOView.UI.setLoaded(url,false);
	$('#pompoview-tabui').tabs("remove","#"+id);
}

PompOView.UI.openTab = function (url,val,js) {
	url = url.replace(/"/g,"%22");
	if ( PompOView.UI.isLoaded(url) ) {
		var index = $("#pompoview-tabui>div").index($("#ui-tabs-"+PompOView.UI.loaded[url]));
		$('#pompoview-tabui').tabs("select",index);
	} else {
		PompOView.UI.loaded[url] = PompOView.UI.counter++;
		
		var tabid = PompOView.UI.formatID(PompOView.UI.loaded[url]);
		
		$('#pompoview-tabui').tabs("add","#"+tabid,val);
		
		if (!js) { js = {}; };
		
		js["currentid"] = tabid;
		js["currenturl"] = url;
		
		jQuery.post( url , js , function ( data ) { $("#"+tabid).html(data); }, "html" );
		
		PompOView.UI.openTab( url );
	};
};

PompOView.UI.newCorpusView = function (js) {
	PompOView.UI.openTab(PompOView.ajax("pompoview-corpusview.php?json="+JSON.stringify(js)),js["corpus"]);
}

PompOView.UI.vars = function (id) {
	if (PompOView.UI.vars_map[id]) {
		return PompOView.UI.vars_map[id];
	} else {
		PompOView.UI.vars_map[id] = {};
		return PompOView.UI.vars_map[id];
	};
	
}
