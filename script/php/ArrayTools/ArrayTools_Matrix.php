<?php
	/**
	 * ArrayTools_Matrix regroupe certaines fonctions s'utilisant sur des tableaux bi-dimensionnels
	 */
	abstract class ArrayTools_Matrix {
		/**
		 * Retourne la valeur et les indices du minimum d'une matrice
		 */
		public static function whereIsMin( $matrix ) {
			if ( count($matrix) == 0 ) {
				throw new Exception("Can not find maximum a an empty matrix.");
			}
			
			$_return = array(false,false);
			$_maxval = false;
			foreach ($matrix as $i => $subarray) {
				foreach ($subarray as $j => $value) {
					if ( $i != $j && ($_maxval > $value || $_maxval === false) ) {
						$_return = array($i,$j,'val'=>$value);
						$_maxval = $value;
					}
				}
			}
			return $_return;
		}
		
		/**
		 * Renvoie une matrice ou l'on a suprimer la ligne et la colonne indiqué
		 */
		public static function unsetIndice($matrix,$i) {
			unset($matrix[$i]);
			foreach ( $matrix as $key => $_ ) {
				unset($matrix[$key][$i]);
			}
			return $matrix;
		}
		
		/**
		 * 
		 */
		public static function triangularValues($matrix) {
			$values = array();
			foreach($matrix as $i => $sub){ 
				foreach($sub as $j => $elem){
					if($i>$j){$values[]=$elem;};
				}
			}
			return $values;
		}
	}
	
?>