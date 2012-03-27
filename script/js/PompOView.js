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

PompOView.UI.initCorpusView = function ( url , id , js ) {
	// Construction
	PompOView.UI.vars_map[url] = {
		"id"  : "#" + id,
		"url" : url,
		"json"  : js,
		openDiff : function (a,b) {
			var post = JSON.parse(this.json);
			post[1] = a; post[2] = b;
			PompOView.UI.newDiffView(post);
		},
		load : function () {
			var post = { "json" : this.json , "curl" : this.url, "cid" : this.id };
			
			post["options"] = PompOView.UI.vars(url).getOptions();
			
			jQuery.post(PompOView.ajax("fragment/pompoview-corpusview.result.php"),post,function (data) {
				$("#"+id+"-result").html(data);
			});
			
			jQuery.post(PompOView.ajax("fragment/pompoview-corpusview.documentlist.php"),post,function (data) {
				$("#"+id+"-documentlist").html(data);
			});
		},
		getOptions : function () {
			var options = { povcorpus_ui : "POVCorpus_HtmlUI" };
			options["clustering"] = $(this.id+"-options-form-clustering").val();
			options["clustering_dist"] = $(this.id+"-options-form-clustering-distance").val();
			options["groups"] = $(this.id+"-radio-groups input:checked").val();
			options["styleset"] = $(this.id+"-options-form-styleset").val();
			options["styleset_parti"] = $(this.id+"-options-form-partitionneur").val();
			var param = $(this.id+"-options-form-parametre-partitionneur").val();
			if (param === undefined) { param = "null"; };
			options["styleset_param"] = param;
		
			if ($("#"+id+"-documentlist :checked").length > 1) {
				options["corpus_sub"] = $("#"+id+"-documentlist :checked").map(function() {
					return $(this).val();}
				).get();
			};
			return options;
		}
	}
	// Initilisation du conteneur
	$("div.radio").buttonset();
	
	$('#'+id+'-accordion h3.accordion > a').click(function() {
		$(this).parent().next().slideToggle(150);
		return false;
	});
	// Ferme toutes les sections puis ouvre la première ( la matrice de couleur )
	$('#'+id+'-accordion h3.accordion').next().hide();
	$('#'+id+'-accordion h3.accordion').first().next().show();
}

PompOView.UI.initDiffView = function ( url , id ) {
	PompOView.UI.vars_map[url] = {
		"url" : url,
		"id"  : id,
		align : function ( G ) {
			var id1 = "#"+this.id +"-"+G+"-left";
			var id2 = "#"+this.id +"-"+G+"-right";
			
			var el1 = $(id1);
			var el2 = $(id2);
			
			var o1 = el1.parent().scrollTop();
			var o2 = el2.parent().scrollTop();
			
			
			el1.parent().scrollTop(0);
			el2.parent().scrollTop(0);
			
			var dist1 = el1.offset().top - el1.parent().offset().top;
			var dist2 = el2.offset().top - el2.parent().offset().top;
			
			el1.parent().scrollTop(o1);
			el2.parent().scrollTop(o2);
			
			
			var ajust1 =  el1.height()/2 - 500/2;
			var ajust2 =  el2.height()/2 - 500/2;
			
			el1.parent().animate({scrollTop : (dist1 + ajust1)},500);
			el2.parent().animate({scrollTop : (dist2 + ajust2)},500);
			
		}
	}
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
		
		js["cid"] = tabid;
		js["curl"] = url;
		
		jQuery.post( url , js , function ( data ) { $("#"+tabid).html(data); }, "html" );
		
		PompOView.UI.openTab( url );
	};
};

PompOView.UI.newCorpusView = function (js) {
	PompOView.UI.openTab(PompOView.ajax("pompoview-corpusview.php?json="+JSON.stringify(js)),js.corpus);
}

PompOView.UI.newDiffView = function (js) {
	PompOView.UI.openTab(PompOView.ajax("pompoview-diffview.php?json="+JSON.stringify(js)),js.corpus + " "+js[1]+" X "+js[2]);
}

PompOView.UI.vars = function (id) {
	if ( ! PompOView.UI.vars_map[id] ){
		PompOView.UI.vars_map[id] = {};
	}; return PompOView.UI.vars_map[id];
}
