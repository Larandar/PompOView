<?php
	//
	$currenturi = $_REQUEST['currenturi'];
	$currentid = $_REQUEST['currentid'] ;
	
	echo POV_HtmlUI::getCloseButton($currenturi,$currentid);
	
	$json = Zend_Json::decode($_REQUEST['json']);
	$corpus = new Corpus(DATA_DIR.$json["corpus"]);
	
	$povcorpus = new POVCorpus($corpus);
?>

<pre><?php print_r($_REQUEST) ?></pre>
<h2>Comparaison d'un corpus</h2>
<script type="text/javascript" charset="utf-8">
	$("<?php echo '#'.$currentid ?>-accordion").accordion();
</script>
<div id="<?php echo $currentid ?>-accordion">
	<h3><a href="#">Section 1</a></h3>
	<div id="#<?php echo $currentid ?>-result">
		<?php echo $povcorpus->makeTable(); ?>
	</div>
	<h3><a href="#">Section 2</a></h3>
	<div>
		<ul style="list-style:none;">
		<li><strong>1</strong>: corpus/test/3/other/output.py
		<li><strong>2</strong>: corpus/test/3/html.py
		<li><strong>3</strong>: corpus/test/3/tp.py
		<li><strong>4</strong>: corpus/test/3/plot.py
		<li><strong>5</strong>: corpus/test/1/Source/nuage.py
		<li><strong>6</strong>: corpus/test/3/other/tools.py
		<li><strong>7</strong>: corpus/test/1/Source/tp_1_2.py
		<li><strong>8</strong>: corpus/test/1/Source/cnt_char.py
		<li><strong>9</strong>: corpus/test/4/LTAL_1_2.py
		<li><strong>10</strong>: corpus/test/1/Source/graph.py
		<li><strong>11</strong>: corpus/test/5/TP_1_2.py
		<li><strong>12</strong>: corpus/test/2/tp_1-2.py
		<li><strong>13</strong>: corpus/test/6/script.py
		<li><strong>14</strong>: corpus/test/1/Source/tool_ltal.py
		<li><strong>15</strong>: corpus/test/4/Boitoutils.py
		<li><strong>16</strong>: corpus/test/5/Boitoutils.py
		</ul>
	</div>
	<h3><a href="#">Section 3</a></h3>
	<div>
		<p>
		Nam enim risus, molestie et, porta ac, aliquam ac, risus. Quisque lobortis.
		Phasellus pellentesque purus in massa. Aenean in pede. Phasellus ac libero
		ac tellus pellentesque semper. Sed ac felis. Sed commodo, magna quis
		lacinia ornare, quam ante aliquam nisi, eu iaculis leo purus venenatis dui.
		</p>
		<ul>
			<li>List item one</li>
			<li>List item two</li>
			<li>List item three</li>
		</ul>
	</div>
	<h3><a href="#">Section 4</a></h3>
	<div>
		<p>
		Cras dictum. Pellentesque habitant morbi tristique senectus et netus
		et malesuada fames ac turpis egestas. Vestibulum ante ipsum primis in
		faucibus orci luctus et ultrices posuere cubilia Curae; Aenean lacinia
		mauris vel est.
		</p>
		<p>
		Suspendisse eu nisl. Nullam ut libero. Integer dignissim consequat lectus.
		Class aptent taciti sociosqu ad litora torquent per conubia nostra, per
		inceptos himenaeos.
		</p>
	</div>
</div>
<script type="text/javascript" charset="utf-8">
	$("<?php echo '#'.$currentid ?>-accordion").accordion();
	PompOView.UI.initCloseButton();
</script>
