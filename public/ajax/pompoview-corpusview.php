<?php
	//
	$currenturl = $_REQUEST['currenturl'];
	$currentid = $_REQUEST['currentid'] ;
	
	$json = $_REQUEST['json'];
	$corpus = Corpus::fromAjax($json); 
	
	if (!$corpus->exist()) {
		die('<p class="error">Une erreur c\'est produite car le corpus n\'a pas été charger correctement.</p>');
	}
	
	$povcorpus = new POVCorpus($corpus);
	
	
?>
<div>
	<h2 class="pretty" >Comparaison d'un corpus</h2>
	<?php echo POV_HtmlUI::getCloseButton($currenturl,$currentid); ?>
</div>

<div id="<?php echo $currentid ?>-accordion">
	<h3 class="pretty accordion"><a href="#">Matrice de valeur</a><button style="font-size:.8em;position:absolute;right:2px;top:2px;" onclick="PompOView.UI.vars('<?php echo $currenturl ; ?>').load();return false;">Recharger</button></h3>
	<div> 
		<div id="<?php echo $currentid ?>-result"></div>
	</div>
	<h3 class="pretty accordion"><a href="#">Selection des éléments</a></h3>
	<div>
		<div class="radio" id="<?php echo $currentid ?>-radio-groups">
				<input type="radio" value="false" id="<?php echo $currentid ?>-radio-groups-false" name="<?php echo $currentid ?>-radio-groups" checked="checked"/><label for="<?php echo $currentid ?>-radio-groups-false">Ne pas regrouper par groupes</label>
				<input type="radio" value="true" id="<?php echo $currentid ?>-radio-groups-true" name="<?php echo $currentid ?>-radio-groups" /><label for="<?php echo $currentid ?>-radio-groups-true">Regrouper par groupes</label>
		</div>
		<?php echo $povcorpus->makeCorpusContent($currenturl,$currentid); ?>
		<button onclick="PompOView.UI.vars('<?php echo $currenturl ; ?>').load();return false;">Valider ces options</button>
	</div>
	<h3 class="pretty accordion"><a href="#">Options de génération</a></h3>
	<div>
		<?php echo $povcorpus->makePOVCorpusForm($currenturl,$currentid); ?>
	</div>
	<!--<h3 class="pretty"><a href="#">Statistiques</a></h3>
	<div>
	<?php echo $povcorpus->makeCorpusStats($currenturl,$currentid); ?>
	</div>-->
</div>
<script type="text/javascript" charset="utf-8">
	
	$('<?php echo '#'.$currentid ?>-accordion h3.accordion > a').click(function() {
		$(this).parent().next().slideToggle(150);
		return false;
	});
	// Ferme toutes les sections puis ouvre la première ( la matrice de couleur )
	$('<?php echo '#'.$currentid ?>-accordion h3.accordion').next().hide();
	$('<?php echo '#'.$currentid ?>-accordion h3.accordion').first().next().show();
	
	$("div.radio").buttonset();
	
	PompOView.UI.vars("<?php echo $currenturl ; ?>").getoptions = function () {
		var options = { povcorpus_ui : "POVCorpus_HtmlUI" };
		options["clustering"] = $("#<?php echo $currentid ; ?>-options-form-clustering").val();
		options["clustering_dist"] = $("#<?php echo $currentid ; ?>-options-form-clustering-distance").val();
		options["groups"] = $("#<?php echo $currentid ; ?>-radio-groups input:checked").val();
		options["styleset"] = $("#<?php echo $currentid ; ?>-options-form-styleset").val();
		options["styleset_parti"] = $("#<?php echo $currentid ; ?>-options-form-partitionneur").val();
		var param = $("#<?php echo $currentid ; ?>-options-form-parametre-partitionneur").val();
		if (param === undefined) { param = "null"; };
		options["styleset_param"] = param;
		
		console.log($("#<?php echo $currentid ; ?>-radio-groups input:checked"));
		return options;
	}
	
	PompOView.UI.vars("<?php echo $currenturl ; ?>").load = function () {
		var js = JSON.parse('<?php echo addslashes(Json::encode($_REQUEST)); ?>');
		js["options"] = PompOView.UI.vars("<?php echo $currenturl ; ?>").getoptions();
		jQuery.post("<?php echo URL_AJAX; ?>fragment/pompoview-corpusview.result.php",js,function (data) {
			$("#<?php echo $currentid ; ?>-result").html(data);
		});
		
	};
	
	PompOView.UI.vars("<?php echo $currenturl ; ?>").load();
	
</script>
