<?php 
	////
	$currenturl = $_REQUEST['currenturl'];
	$currentid = $_REQUEST['currentid'] ;
	
	$json = $_REQUEST['json'];
	$corpus = Corpus::fromAjax($json);
	
	if (!$corpus->exist()) {
		die('<p class="error">Une erreur c\'est produite car le corpus n\'a pas été charger correctement.</p>');
	}
	
	$options = $_REQUEST['options'];
	
	$povcorpus = new POVCorpus($corpus,$options);
	
	echo $povcorpus->makeTable($currenturl,$currentid);
?>