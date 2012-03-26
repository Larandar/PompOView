<?php
	//
	$curl = $_REQUEST['curl'];
	$cid = $_REQUEST['cid'] ;
	
	echo POV_HtmlUI::getCloseButton($curl,$cid);
?>
<h2 class="pretty">Nouveau Corpus</h2>
<h3 class="pretty"><a href="<?php echo URL_AJAX ; ?>corpus-uploader.form.php" onclick="window.open(this.href); return false;">Importer un nouveau corpus</a></h3>

<h3 class="pretty">Selectionner un corpus déjà existant</h2>

<form>
	<select id="<?php echo $_REQUEST['cid'] ?>-corpus-select">
	
	</select>
	<button onclick="PompOView.UI.newCorpusView({corpus:$('#<?php echo $_REQUEST['cid'] ; ?>-corpus-select').val()});return false;">Ouvrir ce corpus</button>
	<button style="float:right;" onclick="PompOView.UI.vars('<?php echo $_REQUEST['cid'] ; ?>').load();return false;">Recharger la liste</button>
</form>


<script type="text/javascript" charset="utf-8">
	PompOView.UI.vars("<?php echo $_REQUEST['cid'] ; ?>").load = function () {
		jQuery.post( 
			"<?php echo URL_AJAX ; ?>fragment/pompoview-newcorpus.select.php" , 
			{} , function ( data ) { 
				$("#<?php echo $_REQUEST['cid'] ; ?>-corpus-select").html(data); 
			}, "html" ); 
		};
	PompOView.UI.vars("<?php echo $_REQUEST['cid'] ; ?>").load();
</script>

