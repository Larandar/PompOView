<?php
	/**
	* 
	*/
	class Embellissement {
		
		public static function getTraitement($str) {
			$all = array(
				"align" => "Embellissement_TraitementAlign",
				"color" => "Embellissement_TraitementGeSHi",
				"space" => "Embellissement_TraitementWSpace"
			);
			return (string)$all[$str];
		}
		
		protected $stack = array();
		
		public function __construct(array $traitement,$url) {
			
			foreach ($traitement as $t) {
				$traitement = Embellissement::getTraitement($t);
				$this->stack[] = new $traitement($url);
			}
			
		}
		
		public function make($filename,$doc,$ali,$side) {
			
			foreach ($this->stack as $maker) {
				$doc = $maker->applyTo($filename,$doc,$ali,$side);
			}
			
			return join($doc,"");
		}
	}
	
?>