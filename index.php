<?php
	$INDEX_DIRECTORY = getcwd()."/";
	$SCRIPT_DIRECTORY = getcwd()."/script/";
	
	$mode = (isset($_GET['mode'])?$_GET['mode']:'pompoview_index');

	switch ($mode) {
		case 'pompoview_corpus':
			include_once($INDEX_DIRECTORY."/vue/pompoview_corpus.php") ; break;
		case 'pompoview_diff':
			include_once($INDEX_DIRECTORY."/vue/pompoview_diff.php") ; break;
		default:
			include_once($INDEX_DIRECTORY."/vue/pompoview_index.php"); break;
	}

