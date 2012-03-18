<?php
	//
	$currenturl = $_REQUEST['currenturl'];
	$currentid = $_REQUEST['currentid'] ;
	
	$json = $_REQUEST['json'];
	//$corpus = Corpus::fromAjax($json); 
	
	$corpus = new Corpus(DATA_DIR."corpus_projet.tar.gz");
	
	echo POV_HtmlUI::getCloseButton($currenturl,$currentid);
?>
<h2>Comparaison de document deux a deux</h2>
<pre><?php print_r($_REQUEST) ?></pre>
<pre><?php print_r($corpus) ?></pre>
<pre><?php echo $corpus->getLogNameByID(0,1); ?></pre>

<script type="text/javascript" charset="utf-8">
	PompOView.UI.initButton();
</script>
