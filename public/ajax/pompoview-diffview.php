<?php
	//
	$curl = $_REQUEST['curl'];
	$cid = $_REQUEST['cid'] ;
?>
<div>
	<h2 class="pretty" >Comparaison de deux documents en vis à vis</h2>
	<?php echo POV_HtmlUI::getCloseButton($curl,$cid); ?>
</div>
<?php
	$json = $_REQUEST['json'] ;
	$corpus = Corpus::fromAjax($json); 
	
	if (!$corpus->exist()) {
		die('<p class="error">Une erreur c\'est produite car le corpus n\'a pas été charger correctement.</p>');
	}
	
	$json = Json::decode($json);
	
	$povdiff = new POVDiff($corpus,$json[1],$json[2]);
	
?>
<h3 class="pretty"><?php echo $corpus->getFileName($json[1]) ; ?> VS <?php echo $corpus->getFileName($json[2]) ; ?></h3>
<div class="pretty">
	<?php echo $povdiff->makeDiff($curl,$cid) ; ?>
</div>
<script type="text/javascript" charset="utf-8">
	PompOView.UI.initButton();
	PompOView.UI.initDiffView("<?php echo $curl; ?>","<?php echo $cid; ?>");
</script>
