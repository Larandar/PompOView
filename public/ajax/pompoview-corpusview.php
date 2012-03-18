<?php
	//
	$currenturl = $_REQUEST['currenturl'];
	$currentid = $_REQUEST['currentid'] ;
	
	echo POV_HtmlUI::getCloseButton($currenturl,$currentid);
	
	$json = $_REQUEST['json'];
	$corpus = Corpus::fromAjax($json); 
	
	if (!$corpus->exist()) {
		die('<p class="error">Une erreur c\'est produite car le corpus n\'a pas été charger correctement.</p>');
	}
	
	$povcorpus = new POVCorpus($corpus);
?>
<h2>Comparaison d'un corpus</h2>
<div id="<?php echo $currentid ?>-accordion">
	<h3 class="pretty"><a href="#">Matrice de valeur</a></h3>
	<div> 
		<div id="<?php echo $currentid ?>-result"></div>
	</div>
	<h3 class="pretty"><a href="#">Selection des éléments</a></h3>
	<div>
		<?php echo $povcorpus->makeCorpusContent($currenturl,$currentid); ?>
	</div>
	<h3 class="pretty"><a href="#">Options de génération</a></h3>
	<div>
		<?php echo $povcorpus->makePOVCorpusForm($currenturl,$currentid); ?>
	</div>
	<!--<h3 class="pretty"><a href="#">Statistiques</a></h3>
	<div>
	<?php echo $povcorpus->makeCorpusStats($currenturl,$currentid); ?>
	</div>-->
</div>
<script type="text/javascript" charset="utf-8">
	
	//$("<?php echo '#'.$currentid ?>-accordion").accordion({autoHeight: false});
	
	PompOView.UI.vars("<?php echo $currenturl ; ?>").getoptions = function () {
		var options = { povcorpus_ui : "POVCorpus_HtmlUI" };
		options["clustering"] = $("#<?php echo $currentid ; ?>-options-form-clustering").val();
		options["clustering_dist"] = $("#<?php echo $currentid ; ?>-options-form-clustering-distance").val();
		options["styleset"] = $("#<?php echo $currentid ; ?>-options-form-styleset").val();
		options["styleset_parti"] = $("#<?php echo $currentid ; ?>-options-form-partitionneur").val();
		var param = $("#<?php echo $currentid ; ?>-options-form-parametre-partitionneur").val();
		if (param === undefined) { param = "null"; };
		options["styleset_param"] = param;
		return options;
	}
	
	PompOView.UI.vars("<?php echo $currenturl ; ?>").load = function () {
		var js = JSON.parse('<?php echo addslashes(Json::encode($_REQUEST)); ?>');
		js["options"] = PompOView.UI.vars("<?php echo $currenturl ; ?>").getoptions();
		jQuery.post("<?php echo URL_AJAX; ?>fragment/pompoview-corpusview.result.php",js,function (data) {
			$("#<?php echo $currentid ; ?>-result").html(data);
		});
		
		//$("<?php echo '#'.$currentid ?>-accordion").accordion("activate",0);
	};
	
	PompOView.UI.vars("<?php echo $currenturl ; ?>").load();
	
</script>
