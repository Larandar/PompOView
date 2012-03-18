<?php
	/**
	 * Capture le premier caractère et le remplace par lui même, ainsi le 
	 * le document n'est pas modifier.
	 */
	
	class FiltrageDoc_FiltreIdentite extends FiltrageDoc_AbstractFiltre {
		
		protected $regex_matchin = '/^$/';
		protected $regex_replace = '';
		
	}
?>