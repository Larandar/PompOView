<?php
	// Test room 1
	require_once "__autoload_testroom.php";
	
	
	
	$povc = new POVCorpus();
	$povc->fromJSON("../data/corpus_projet/out.js");
	$povc->setClustering("Clustering_None","Distance::med");
	$povc->setStyleSet("StyleSet_ColorHSL","Partitionneur_KMeans");
	$povc->setUI("POVCorpus_HtmlUI");
	
	$corpus = $povc->getFilenames();
	
	
	$result = CorpusTools::constructCorpus($corpus);
?>
<!DOCTYPE html>
<html>
	<head>
		<title>PompOView :: Corpus test</title>
		<style type="text/css" media="screen">
		.frame {
			border: 1px solid #999;
			margin: 5px ;
		}
		.table table {
			border-collapse: collapse;
		}
		.table td {
			margin: 0px;
			padding:1px;
			-moz-border-radius: 3px;
			-webkit-border-radius: 3px;
			border-radius: 3px;
		}
		</style>
	</head>
	<body>
		<pre class="frame"><?php print_r( $result ); ?></pre>
		<div class="frame table"><?php echo $povc->makeTable() ; ?></div>
		<div class="frame plist"><?php echo $povc->makeCorpusContent() ; ?></div>
	</body>
</html>