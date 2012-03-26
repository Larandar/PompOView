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
		
		public function applyTo($filename,$doc,$ali) {
			foreach ($doc as $key => $str) {
				$doc[$key] = $this->applyOne($str[0],$ali[$key]);
			}
			return $doc;
		}
		
		public function applyOne($str,$ali) {
			$str =  htmlentities( $str ) ;
			return preg_replace($this->regin, $this->regout, $str );
		}
		
	}
	
?>