<?php
	/**
	 * La classe des distances utilisé, pour un ajour il suffit de l'ajouter ici et
	 * dans le formulaire l'utilisé en paramètre des fonction qui l'utilise.
	 */
	class Distance {
		
		public static $manifest = array(
			"Distance::min" => "Minimum",
			"Distance::max" => "Maximum",
			"Distance::med" => "Médiane",
			"Distance::avg" => "Moyenne"
		);
		
		public static function min($a, $b){
			return min(min($a,$b));
		}
		
		public static function max($a, $b){
			return max(max($a, $b));
		}
		
		public static function med($a, $b){
			return (Distance::min($a,$b) + Distance::max($a,$b))/2;
		}
		
		public static function avg($a, $b) {
			if ((count($a)+count($b)) == 0) {
				return 0;
			} else {
				return (array_sum($a)+array_sum($b))/(count($a)+count($b));
			}
		}
	}
	
?>