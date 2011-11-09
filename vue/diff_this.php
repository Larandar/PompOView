<?
  include_once('../script/php/Diff.class.php');
?>
<?php
	$diff = new Diff();
	$text = $diff->inline('../'.$_POST['D1'],'../'.$_POST['D2']);
?>
<!DOCTYPE html>
<html lang="fr">
<head>
	<meta charset="UTF-8">
	<link rel="stylesheet" href="../css/diff.css">
	<title><?= count($diff->changes).' changements';?></title>
</head>
<body>
<?= utf8_encode($text); ?>
</body>
</html>