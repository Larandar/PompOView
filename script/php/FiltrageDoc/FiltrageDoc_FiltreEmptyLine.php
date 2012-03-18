<?php
	/**
	 * 
	 */
	class FiltrageDoc_FiltreEmptyLine extends FiltrageDoc_AbstractFiltre {
		
		protected $regex_matchin = '/([[:blank:]]*\r?\n){2,}/';
		protected $regex_replace = "\n";
		
	}
?>
