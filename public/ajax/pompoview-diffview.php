<?php
	//
	$currenturi = $_REQUEST['currenturi'];
	$currentid = $_REQUEST['currentid'] ;
	
	echo POV_HtmlUI::getCloseButton($currenturi,$currentid);
?>
<h2>Comparaison de document deux a deux</h2>
<pre><?php print_r($_REQUEST) ?></pre>

<script type="text/javascript" charset="utf-8">
	PompOView.UI.initCloseButton();
</script>
