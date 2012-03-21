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
		
		public function __construct(array $traitement) {
			
			foreach ($traitement as $t) {
				$traitement = Embellissement::getTraitement($t);
				$this->stack[] = new $traitement();
			}
			
		}
		
		public function make($doc,$ali) {
			
			foreach ($doc as $key => $val) {
				$doc[$key] = $this->apply($val[0],$ali[$key]);
			}
			
			return join($doc,"");
		}
		
		protected function apply($seg,$ali) {
			
			foreach ($this->stack as $maker) {
				$seg = $maker->apply($seg,$ali);
			}
			
			return $seg;
		}
	}
	
?>