<?
	$INDEX_DIRECTORY = getcwd().'/../';
	$SCRIPT_DIRECTORY = $INDEX_DIRECTORY.'script/';
	
	global $INDEX_DIRECTORY;
	global $SCRIPT_DIRECTORY;
?>
<?

	include_once($INDEX_DIRECTORY.'script/PHP/package/PompOView.php');
	$pompoview = new Pompoview();
	
	$pompoview->fromJSON($INDEX_DIRECTORY.(($_POST['json']!=NULL)?$_POST['json']:'file/out.test.json'));
?>
<!DOCTYPE html>
<html lang="fr">
<head>
	<meta charset="utf-8">
	<meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">

	<title>Pomp-O-View :: Phase de test</title>
	<meta name="description" content="">
	<meta name="author" content="Adrien 'Larandar' Dudouit-Exposito, Alexandre 'Bibi' Legoupil">

	<meta name="viewport" content="width=device-width,initial-scale=1">

	<link rel="stylesheet" href="../css/style.css" type="text/css" media="screen" charset="utf-8">
</head>
<body>
	<div id="container">
		<header>
			<h1>Pomp-O-View</h1>
		</header>
		<div id="main" role="main">
			<?if(json_last_error() != JSON_ERROR_NONE){?><div class="error"><?=string_json_last_error().' ['.json_last_error().']';?></div><?};?>
			<?$pompoview->export();?>
		</div>
		<footer>
		
		</footer>
	</div> <!--! end of #container -->
</body>
</html>
