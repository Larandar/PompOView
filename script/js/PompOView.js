PompOView = { "version" : "∫ 0.1" };

// Fonctions basiques qui permettent de bénéficier de la configuration du serveur.
PompOView.setAjax = function (url) { PompOView.ajaxURL = url ; };
PompOView.ajax    = function (val) { return PompOView.ajaxURL + val ;};

// Fonction utilisé pour initialisé toutes les composantes JavaScript/jQuery de la page lorsque la page à charger.
PompOView.ready   = function () {
	PompOView.UI.init();
};

PompOView.UI = { "version" : "0.1" , "loaded" : {}, "counter" : 1};
PompOView.UI.init      = function () {
	$('#pompoview-tabui').tabs().find( ".ui-tabs-nav" ).sortable({ axis: "x" });
};

PompOView.UI.isLoaded  = function (type) { return Boolean(PompOView.UI.loaded[type]) ;};
PompOView.UI.formatID  = function (count) { return "ui-tabs-" +  count ; };
PompOView.UI.setLoaded = function (type,val) { PompOView.UI.loaded[type] = val ;};

PompOView.UI.openTab = function (url,val) {
	if ( PompOView.UI.isLoaded(url) ) {
		$('#pompoview-tabui').tabs("select",PompOView.UI.loaded[url] - 1);
	} else {
		PompOView.UI.loaded[url] = PompOView.UI.counter++;
		
		var tabid = PompOView.UI.formatID(PompOView.UI.loaded[url]);
		
		$('#pompoview-tabui').tabs("add","#"+tabid,val);
		
		jQuery.post( url , { "currentid" : tabid }, function ( data ) { $("#"+tabid).html(data); }, "html" );
		
		PompOView.UI.openTab( url );
	};
};
