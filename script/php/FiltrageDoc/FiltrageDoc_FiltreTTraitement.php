<?php
	/**
	 * 
	 */
	class FiltrageDoc_FiltreTTraitement extends FiltrageDoc_AbstractFiltre {
		
		protected $regex_matchin = '/[[:alnum:]]{1,}/';
		protected $regex_replace = 'T';
		
	}
?>
