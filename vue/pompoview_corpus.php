<!DOCTYPE html>
<?
	if (! isset($INDEX_DIRECTORY)) {
		global $INDEX_DIRECTORY;
		global $SCRIPT_DIRECTORY;
		
		$INDEX_DIRECTORY = getcwd().'/../';
		$SCRIPT_DIRECTORY = $INDEX_DIRECTORY.'script/';
	}
	
	include_once($SCRIPT_DIRECTORY.'PHP/PompOView_Corpus.php');
	
    $UNDEFINE = FALSE;
    
	if (isset($_POST['json']) and isset($_POST['clustering'])) {
		// L'ensemble des options est passer par formulaire
		$pompoview = new PompOView_Corpus(array(
			'clustering'	  => $_POST['clustering'],
			'clustering_dist' => $_POST['clustering_dist'],
			'coloration'	  => $_POST['coloration'],
			'coloration_prof' => $_POST['coloration_prof']
		));
		$pompoview->fromJSON($INDEX_DIRECTORY.$_POST['json']);
	}
	elseif (isset($_POST['json'])) {
		$pompoview = new PompOView_Corpus(array());
		$pompoview->fromJSON($INDEX_DIRECTORY.$_POST['json']);
	}
	else {
		$UNDEFINE = TRUE;
	}
?>
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
			<?php if ($UNDEFINE): ?>
			<div id="form_container">
				<h1>
					<a>Pomp O View</a>
				</h1>
				<form method="post" action="pompoview_corpus.php">
					<div class="form_description">
						<h2>
							Pomp O View
						</h2>
						<p>
							Choisissez les paramètre de générations
						</p>
					</div>
					<ul style="list-style: none">
						<li>
							<label class="description" for="json">Fichier JSON sources</label>
							<div>
								<input id="json" name="json" type="text" maxlength="255" value="data/corpus_haskell/out.test.json">
							</div>
						</li>
						<li>
							<h3>
								Option de coloration
							</h3>
						</li>
						<li>
							<label class="description" for="coloration">Type de coloration</label>
							<div>
								<select name="coloration">
									<option value="ColorationEmb">Par moyennes emboitées</option>
									<option value="ColorationLin">De façon linéaire</option>
								</select>
							</div>
						</li>
						<li>
							<label class="description" for="coloration_prof">Classes de couleur (2^N)</label>
							<div>
								<input name="coloration_prof" type="text" maxlength="255" value="3">
							</div>
						</li>
						<li>
							<h3>
								Options de clustering
							</h3>
						</li>
						<li>
							<label class="description" for="clustering">Type de clustering</label>
							<div><select name="clustering">
								<option value="HierarchicalClustering">Clustering Hiérarchique</option>
								<option value="NullClustering">Pas de Clustering</option>
							</select></div>
						</li>
						<li>
							<label class="description" for="clustering_dist">Fonction de fusion</label>
							<div><select name="clustering_dist">
								<option value="min">Minimum</option>
								<option value="max">Maximum</option>
								<option value="med">Médiane</option>
							</select></div>
						</li>
						<li>
							<input id="saveForm" class="button_text" type="submit" name="submit" value="Submit">
						</li>
					</ul>
				</form>
			</div>
			<?php else: ?>
				<div id="main" role="main">
					<?if(json_last_error() != JSON_ERROR_NONE){?><div class="error"><?=string_json_last_error().' ['.json_last_error().']';?></div><?};?>
					<?$pompoview->exportMatrix();?>
					<?$pompoview->exportChart();?>
					<div id="form_container">
						<?$pompoview->exportForm();?>
					</div>
				</div>
			<?php endif ?>
				<footer>
					   
				</footer>
			</div>
		</div>
	</body>
</html>
