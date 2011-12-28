<?
	$INDEX_DIRECTORY = getcwd()."/";
	$SCRIPT_DIRECTORY = getcwd()."/script/";
	$requestURI = explode('/', $_SERVER["REQUEST_URI"]);
	$scriptName = explode('/', $_SERVER["SCRIPT_NAME"]);
		for($i= 0;$i < sizeof($scriptName);$i++){
				if ($requestURI[$i] == $scriptName[$i]){
					unset($requestURI[$i]);
				}
			}
	$command = array_values($requestURI);
	
	$app = $command[0].'_'.$command[1];
	$arg = array_slice($command,2);
	
	switch ($app) {
		case 'pompoview_corpus':
			include_once($INDEX_DIRECTORY."/vue/pompoview_corpus.php") ; break;
		case 'pompoview_diff':
			include_once($INDEX_DIRECTORY."/vue/pompoview_diff.php") ; break;
		default:
			include_once($INDEX_DIRECTORY."/vue/pompoview_index.php"); break;
	}
