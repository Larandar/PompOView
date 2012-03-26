<?php
	/**
	 * 
	 */
	class Embellissement_TraitementWSpace extends Embellissement_AbstractTraitement {
		
		protected $regin = array(
			"/ /", "/\t/", "/\r?\n/"
		);
		
		protected $regout = array(
			"&nbsp;", "&nbsp;&nbsp;", "</br>"
		);
		
		public function apply($str,$ali) {
			$str =  htmlentities( $str ) ;
			return preg_replace($this->regin, $this->regout, $str );
		}
		
	}
	
?>