<!DOCTYPE html>
<html lang="fr">
<head>
	<meta charset="utf-8">
	<meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
	<title>Pomp-O-View :: Phase de test</title>
	<meta name="description" content="">
	<meta name="author" content="Adrien 'Larandar' Dudouit-Exposito, Alexandre 'Bibi' Legoupil">
	<meta name="viewport" content="width=device-width,initial-scale=1">
	<link rel="stylesheet" href="css/style.css" type="text/css" media="screen" charset="utf-8">
</head>
<body>
	<div id="container">
		<header>
			<h1>Pomp-O-View :: Phase de test</h1>
		</header>
		<div id="main" role="main">
			<div>
				<h2>Pomp-O-View :: Tableau de bord</h2>
				<form action="vue/pompoview_corpus.php" method="post" accept-charset="utf-8">
					<table class="input">
						<col width="25%"/><col width="70%"/>
						<tr><td>Fichier Sources :</td><td><input type="text" value="data/corpus_haskell/out.test.json" name="json"></td></tr>
					</table>
					<p><input type="submit" value="Continue &rarr;"></p>
				</form>
			</div>
			<div>
				<h2>Pomp-O-View :: Diff</h2>
				<form action="vue/diff_this.php" method="post" accept-charset="utf-8">
					<table class="input">
						<col width="25%"/><col width="70%"/>
						<tr><td>Premier Document :</td><td><input type="text" value="data/haskell_1/_01.hs" name="D1"></td></tr>
						<tr><td>Deuxième Document :</td><td><input type="text" value="data/haskell_1/_02.hs" name="D2"></td></tr>
					</table>
					<p><input type="submit" value="Continue &rarr;"></p>
				</form>
			</div>
		</div>
		<footer>
		
		</footer>
	</div> <!--! end of #container -->
</body>
</html>
