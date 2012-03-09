<?php
	// Basic error page
	
?><!DOCTYPE html>
<html>
	<head>
		<title>Une erreur <?php echo $_ERROR['code'] ; ?> c'est produite !</title>
		<meta charset="utf-8" author="Adrien DUDOUIT-EXPOSITO"/>
		<style>
		  body {background:#EFEFEF; font-family: "Lucida Grande", serif;}
		  div#error { background:#DFDFDF; border-radius:30px; padding: 30px; margin: 100px }
		</style>
	</head>
	<body>
		<div id="error">
			<h1>Attention une erreur <?php echo $_ERROR['code'] ; ?> c'est produite.</h1>
			<p>Veuillez contacté un agent de service pour régler ce problème.</p>
			<p>Source: <?php echo $_ERROR['source'] ; ?></p>
		</div>
	</body>
</html>