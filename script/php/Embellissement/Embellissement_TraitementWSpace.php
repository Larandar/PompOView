<?php
	/**
	 * 
	 */
	class Embellissement_TraitementWSpace extends Embellissement_AbstractTraitement {
		
		protected $regin = array(
			"/\n /"
		);
		
		protected $regout = array(
			""
		);
		
		public function applyTo($filename,$doc,$ali) {
			foreach ($doc as $key => $str) {
				$doc[$key] = $this->applyOne($str,$ali[$key]);
			}
			return $doc;
		}
		
		public function applyOne($str,$ali) {
			return preg_replace($this->regin, $this->regout, $str );
		}
		
	}
	
?>