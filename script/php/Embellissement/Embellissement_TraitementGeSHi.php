<?php
	/**
	 * 
	 */
	class Embellissement_TraitementGeSHi extends Embellissement_AbstractTraitement {
		
		function __construct() {
			# code...
		}
		
		public function applyTo($filename,$str,$ali) {
			$ext = pathinfo($filename, PATHINFO_EXTENSION);
		
		}
		
		public function apply($str,$ali) {
			return $str;
		}
		
	}
	
?>