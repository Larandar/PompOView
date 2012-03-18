<?php
	////
	$currenturl = $_REQUEST['currenturl'];
	$currentid = $_REQUEST['currentid'] ;
	
	$partitionneur = $_REQUEST['partitionneur'];
	
	$json = $_REQUEST['json'];
	$corpus = Corpus::fromAjax($json);
	
	if (!$corpus->exist()) {
		die('<p class="error">Une erreur c\'est produite car le corpus n\'a pas été charger correctement.</p>');
	}
	
	if ($options["groups"] === "true") {
		$corpus->emuleProjet();
		$countf = count($corpus->getProjet());
	} else {
		$countf = count($corpus->getFileNames());
	}
	$recommended = $partitionneur.'::recommended';
	$recommended = call_user_func($recommended,$countf);
	$estimation = $partitionneur.'::estimation';
?>
	<option value="<?php echo $recommended; ?>"><?php echo call_user_func($estimation,$recommended); ?></option>
	<option value="<?php echo $recommended; ?>"><?php echo str_repeat('-',strlen((string)call_user_func($estimation,$recommended + 3))); ?></option>
<?php for ($i = $recommended - 3; $i <= $recommended + 3; $i++): if ($i>0): ?>
	<option value="<?php echo $i; ?>"><?php echo call_user_func($estimation,$i); ?></option>
<?php endif; endfor; ?>