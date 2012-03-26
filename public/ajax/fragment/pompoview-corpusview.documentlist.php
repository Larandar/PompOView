<?php 
	////
	$curl = $_REQUEST['curl'];
	$cid = $_REQUEST['cid'] ;
	
	$json = $_REQUEST['json'];
	$options = $_REQUEST['options'];
	if (isset($options["corpus_sub"])) {
		$corpus = Corpus::fromAjax($json,$options["corpus_sub"]);
	} else {
		$corpus = Corpus::fromAjax($json);
	}
	
	
	if (!$corpus->exist()) {
		die('<p class="error">Une erreur c\'est produite car le corpus n\'a pas été charger correctement.</p>');
	}
	
	$options = $_REQUEST['options'];
	
	$povcorpus = new POVCorpus($corpus,$options);
	
	echo $povcorpus->makeCorpusContent($curl,$cid);
?>
