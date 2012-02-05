<?php
	/**
	 * Partionneur qui coupe en N segment de longueur 1/N
	 */
	abstract class Partitionneur_Linear extends Partitionneur {
		
		public static function generer($list,$param = null) {
			// Ne pas définir le paramètre fait appel au paramètre recommandé
			// par le biais de la méthode statique "recommended"
			if ($param == null) {
				$param = Partitionneur_Linear::recommended(count($list));
			}
			$partition = array();
			for ($i=0; $i < $param; $i++) { 
				$partition[] = array(
					"min" =  $i/$param ,
					"max" = ($i+1)/$param
				);
			}
			
			return $partition;
		}
		
		public static function estimation($N) { return $N ; }
		public static function recommended($N) { return floor($N/2) + 3 ; }
	}
	
?>