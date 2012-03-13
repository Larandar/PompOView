<?php if (isset($_FILES['corpus_upload'])) { $handler = new Corpus_Uploader(); } ?>
<!DOCTYPE html>
<html>
	<head>
		<title>PompOView</title>
		<meta charset="utf-8" lang="fr_FR"/>
		
		<link rel="stylesheet" href="<?php echo URL_CSS ; ?>master.css" type="text/css" media="screen" charset="utf-8"/>
		
		<link rel="icon" type="image/ico" href="<?php echo URL_IMG ; ?>favicon.ico" />
		<link rel="apple-touch-icon" href="<?php echo URL_IMG ; ?>pompoview-iphone.png" />
		<link rel="apple-touch-icon" sizes="72x72" href="<?php echo URL_IMG ; ?>pompoview-ipad.png" />
		<link rel="apple-touch-icon" sizes="114x114" href="<?php echo URL_IMG ; ?>pompoview-iphone4.png" />
		
		<script type="text/javascript" src="<?php echo URL_JS ; ?>jquery.min.js"></script>
		<script type="text/javascript" src="<?php echo URL_JS ; ?>jquery-ui.min.js"></script>
		
		<script type="text/javascript" src="<?php echo URL_JS ; ?>PompOView.js"></script>
	</head>
	<body>
		<header>
			<img class="logo" src="<?php echo URL_IMG ; ?>pompoview.png"></img>
			<h1>PompOView <span class="grey">: Comparateur de codes sources</span></h1>
		</header>
		<div id="main">
			<?php echo Corpus_Uploader::getForm(); ?>
			<?php if (isset($_FILES['corpus_upload'])): ?>
				<p class="return <?php echo $handler->getReturn("state") ?>">
					<?php echo $handler->getReturn("message"); ?>
				</p>
			<?php endif ?>
		</div>
	</body>
</html>
