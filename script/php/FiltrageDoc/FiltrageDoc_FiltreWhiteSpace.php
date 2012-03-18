<?php
	/**
	 * 
	 */
	class FiltrageDoc_FiltreWhiteSpace extends FiltrageDoc_AbstractFiltre {
		
		protected $regex_matchin = '/[[:blank:]]{2,}|\t{1,}/';
		protected $regex_replace = ' ';
		
	}
?>
