<?
	$INDEX_DIRECTORY = getcwd().'/../';
	$SCRIPT_DIRECTORY = $INDEX_DIRECTORY.'script/';

	global $INDEX_DIRECTORY;
	global $SCRIPT_DIRECTORY;
	
	include_once($INDEX_DIRECTORY.'script/PHP/package/PompOView.php');
	
	if (isset($_POST['json']) and isset($_POST['clustering'])) {
		// L'ensemble des options est passer par formulaire
		$pompoview = new Pompoview(array(
			'clustering'      => $_POST['clustering'],
			'clustering_dist' => $_POST['clustering_dist'],
			'coloration'           => $_POST['coloration'],
			'coloration_prof'      => $_POST['coloration_prof']
		));
		$pompoview->fromJSON($INDEX_DIRECTORY.$_POST['json']);
	}
	elseif (isset($_POST['json'])) {
		$pompoview = new Pompoview(array());
		$pompoview->fromJSON($INDEX_DIRECTORY.$_POST['json']);
	}
	else {
		$hide = TRUE;
	}

	
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
		<?php
			if(!$hide){?>
		<div id="main" role="main">
			<?if(json_last_error() != JSON_ERROR_NONE){?><div class="error"><?=string_json_last_error().' ['.json_last_error().']';?></div><?};?>
			<?$pompoview->exportMatrix();?>
			<?$pompoview->exportChart();?>
		</div>
		<?php
			}
		?>
		<div id="form_container">
			<h1>
				<a>Pomp O View</a>
			</h1>
			<form method="post" action="pompoview.php">
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
								<option value="ColorationEmb">
									Par moyenne emboitée
								</option>
								<option value="ColorationLin">
									De façon linéaire
								</option>
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
						<div>
							<select name="clustering">
								<option value="HierarchicalClustering">
									Clustering Hiérarchique
								</option>
								<option value="NullClustering">
									Pas de Clustering
								</option>
							</select>
						</div>
					</li>
					<li>
						<label class="description" for="clustering_dist">Fonction de fusion</label>
						<div>
							<select name="clustering_dist">
								<option value="min">
									Minimum
								</option>
								<option value="max">
									Maximum
								</option>
								<option value="med">
									Médiane
								</option>
								<option value="pow">
									Puissance
								</option>
							</select>
						</div>
					</li>
					<li>
						<input id="saveForm" class="button_text" type="submit" name="submit" value="Submit">
					</li>
				</ul>
			</form>
		</div>
		<footer>
		
		</footer>
	</div> <!--! end of #container -->
</body>
</html>
