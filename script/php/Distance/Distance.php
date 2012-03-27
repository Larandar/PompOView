<?php
	/**
	 * La classe des distances utilisé, pour un ajour il suffit de l'ajouter ici et
	 * dans le formulaire l'utilisé en paramètre des fonction qui l'utilise.
	 */
	class Distance {
		
		public static function getAll() {
			$all = array(
				"Distance::min" => "Minimum",
				"Distance::max" => "Maximum",
				"Distance::med" => "Médiane",
				"Distance::avg" => "Moyenne"
			);
			return $all;
		}
		
		public static function min($a, $b = false){
			if (!$b) { $b = $a; }
			if ((count($a)+count($b)) == 0) { throw new Exception("Empty pototoes for null distance");}
			return min(array_merge($a,$b));
		}
		
		public static function max($a, $b = false){
			if (!$b) { $b = $a; }
			if ((count($a)+count($b)) == 0) { throw new Exception("Empty pototoes for null distance");}
			return max(array_merge($a, $b));
		}
		
		public static function med($a, $b = false){
			if (!$b) { $b = array(); }
			if ((count($a)+count($b)) == 0) { throw new Exception("Empty pototoes for null distance");}
			return (Distance::min($a,$b) + Distance::max($a,$b))/2;
		}
		
		public static function avg($a, $b = false) {
			if (!$b) { $b = array(); }
			if ((count($a)+count($b)) == 0) {
				return 0;
			} else {
				return (array_sum($a)+array_sum($b))/(count($a)+count($b));
			}
		}
	}
	
?>