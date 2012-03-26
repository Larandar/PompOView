<?php
	//
	$curl = $_REQUEST['curl'];
	$cid = $_REQUEST['cid'] ;

?>
<div>
	<h2 class="pretty" >Comparaison d'un corpus</h2>
	<?php echo POV_HtmlUI::getCloseButton($curl,$cid); ?>
</div>
<?php	
	$json = $_REQUEST['json'];
	$corpus = Corpus::fromAjax($json); 
	
	if (!$corpus->exist()) {
		die('<p class="error">Une erreur c\'est produite car le corpus n\'a pas été charger correctement.</p>');
	}
	
	$povcorpus = new POVCorpus($corpus);
?>

<div id="<?php echo $cid ?>-accordion">
	<h3 class="pretty accordion"><a href="#">Matrice de valeur</a><button style="font-size:.8em;position:absolute;right:1px;top:1px;" onclick="PompOView.UI.vars('<?php echo $curl ; ?>').load();return false;">Recharger</button></h3>
	<div> 
		<div id="<?php echo $cid ?>-result"></div>
	</div>
	<h3 class="pretty accordion"><a href="#">Selection des éléments</a></h3>
	<div>
		<div class="radio" id="<?php echo $cid ?>-radio-groups">
				<input type="radio" value="false" id="<?php echo $cid ?>-radio-groups-false" name="<?php echo $cid ?>-radio-groups" checked="checked"/><label for="<?php echo $cid ?>-radio-groups-false">Ne pas regrouper par groupes</label>
				<input type="radio" value="true" id="<?php echo $cid ?>-radio-groups-true" name="<?php echo $cid ?>-radio-groups" /><label for="<?php echo $cid ?>-radio-groups-true">Regrouper par groupes</label>
		</div>
		<div class="pretty" id="<?php echo $cid ?>-documentlist"></div>
		<button class="fat" onclick="PompOView.UI.vars('<?php echo $curl ; ?>').load();return false;">Valider ces options</button>
	</div>
	<h3 class="pretty accordion"><a href="#">Options de génération</a></h3>
	<div>
	<div class="pretty">
		<?php echo $povcorpus->makePOVCorpusForm($curl,$cid); ?>
	</div>
		<button class="fat" onclick="PompOView.UI.vars('<?php echo $curl ; ?>').load();return false;">Valider ces options</button>
	</div>
	<!--<h3 class="pretty"><a href="#">Statistiques</a></h3>
	<div>
	<?php echo $povcorpus->makeCorpusStats($curl,$cid); ?>
	</div>-->
</div>
<script type="text/javascript" charset="utf-8">
	
	PompOView.UI.initCorpusView('<?php echo $curl ; ?>','<?php echo $cid ; ?>','<?php echo print_r($json,true); ?>');
	
	PompOView.UI.vars("<?php echo $curl ; ?>").load();
	
</script>