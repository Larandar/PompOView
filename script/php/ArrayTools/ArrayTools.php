<?php
	/**
	 * ArrayTools est une classe regroupant diverses fonction s'appliquant aux tableaux en PHP
	 */
	abstract class ArrayTools {
		/**
		 * Aplatit un tableau multi-dimmensionnel en un tableau uni-dimmensionnel
		 */
		public static function flatizer($array) {
			// Ce n'ai pas un array => on retourne la valeur
			if (!is_array($array)){return $array;};
			
			$flated = array();
			$toflat = array();
			
			foreach ($array as $value) {
				if (! is_array($value) ) {
					$flated[] = $value;
				} else {
					$toflat = array_merge($toflat,$value);
				}
			}
			
			if (count($toflat) > 0) {
				$toflat = ArrayTools::flatizer($toflat);
			}
			
			return $flated ;
		}
		
		/**
		 * Retourne la moyenne d'un tableau
		 */
		public static function average($array) {
			if (count($array) == 0) {
				return 0;
			} else {
				return array_sum($array)/count($array);
			}
		}
		
		/**
		 * Coupe un tableau en deux avec d'un côté les éléments inférieurs ou égaux
		 * à la moyenne de l'autres les éléments supérieurs.
		 */
		public static function averageCut($array) {
			$_avg = ArrayTools::average($array);
			$return = array();
			foreach ($array as $value) {
				if ($value <= $_avg) {
					$return[0][] = $value;
				} else {
					$return[1][] = $value;
				}
			}
			print_r($return);
			return $return;
		}
	}
	
?>