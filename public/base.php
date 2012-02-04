<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "DTD/xhtml1-strict.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="fr" lang="fr">
<head>
	<meta http-equiv="Content-Type" content="text/html;charset=utf-8" >
	<title><?php echo $titre ; ?></title>
	<link rel="stylesheet" type="text/css"  href="<?php echo SERVER_URL ; ?>/public/ui/css/base.css" />
	<link rel="stylesheet" type="text/css" media="screen" href="<?php echo SERVER_URL ; ?>public/ui/css/screen.css" />
	<link rel="stylesheet" type="text/css" media="print" href="<?php echo SERVER_URL ; ?>public/ui/css/print.css" />
</head>
<body>
	<div id="header">
<?php include "ui/header.php" ; ?>
	</div>
	<div class="menu">
<?php include "ui/menu.php" ; ?>
	</div>
	<div id="content" role="main">
<?php echo $main_content ; ?>
	</div>
	<div id="footer">
<?php include "ui/footer.php" ?>
	</div>
</body>
</html>
