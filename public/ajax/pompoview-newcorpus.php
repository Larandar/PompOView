<?php
	//
	$currenturi = $_REQUEST['currenturi'];
	$currentid = $_REQUEST['currentid'] ;
	
	echo POV_HtmlUI::getCloseButton($currenturi,$currentid);
?>
<h2>Nouveau Corpus</h2>
<h3><a href="<?php echo URL_AJAX ; ?>corpus-uploader.form.php" onclick="window.open(this.href); return false;">Importer un nouveau corpus</a></h3>

<h2>Selectionner un corpus déjà existant</h2>

<form>
	<select id="<?php echo $_REQUEST['currentid'] ?>-corpus-select">
	
	</select>
	<button onclick="PompOView.UI.newCorpusView({corpus:$('#<?php echo $_REQUEST['currentid'] ; ?>-corpus-select').val()}); return false;">Ouvrir ce corpus</button>
	<button style="float:right;" onclick="PompOView.UI.vars('<?php echo $_REQUEST['currentid'] ; ?>').load();">Recharger la liste</button>
</form>


<script type="text/javascript" charset="utf-8">
	PompOView.UI.vars("<?php echo $_REQUEST['currentid'] ; ?>").load = function () {
		jQuery.post( 
			"<?php echo URL_AJAX ; ?>fragment/pompoview-newcorpus.select.php" , 
			{} , function ( data ) { 
				$("#<?php echo $_REQUEST['currentid'] ; ?>-corpus-select").html(data); 
			}, "html" ); 
		return false; };
	PompOView.UI.vars("<?php echo $_REQUEST['currentid'] ; ?>").load();
	PompOView.UI.initCloseButton();
</script>

