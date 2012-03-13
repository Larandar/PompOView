	<?php foreach (scandir(DATA_DIR) as $value): if (!preg_match("/(^\.)|(\.json$)/",$value)) :?>
	<option value="<?php echo $value; ?>"><?php echo $value; ?></option>
	<?php  endif ; endforeach ;?>
