<h2>Nouveau Corpus</h2>
<h3><a href="<?php echo URL_AJAX ; ?>corpus-uploader.form.php" onclick="window.open(this.href); return false;">Importer un nouveau corpus</a></h3>

<h2>Selectionner un corpus déjà existant</h2>

<select id="<?php echo $_REQUEST['currentid'] ?>-corpus-select">
	<?php foreach (scandir(DATA_DIR) as $value): if (!preg_match("/(^\.)|(\.json$)/",$value)) :?>
	<option value="<?php echo $value; ?>"><?php echo $value; ?></option>
	<?php  endif ; endforeach ;?>
</select>
<a href="#" onclick="PompOView.UI.newCorpusView({corpus:$('#<?php echo $_REQUEST['currentid'] ?>-corpus-select').val()}); return false;">Ouvrir ce corpus</a>


