<?php
	/**
	 * Un partionneur par moyenne emboitée sucécive
	 */
	abstract class Partitionneur_KMeans extends Partitionneur {
		public static function generer($list, $param = null) {
			// Ne pas définir le paramètre fait appel au paramètre recommandé
			// par le biais de la méthode statique "recommended"
			if ($param == null) {
				$param = Partitionneur_KMeans::recommended(count($list));
			}
			
			$list = array($list);
			for ( $prof = $param; $prof > 0; $prof-- ) {
				$stock = array();
				foreach ($list as $subarray) {
					$stock[] = ArrayTools::averageCut($subarray);
				}
				$list = array();
				foreach ($stock as $value) {
					if (isset($value[0])) { $list[] = $value[0] ; }
					if (isset($value[1])) { $list[] = $value[1] ; }
				}
			}
			
			print_r($list);
			
			$partition = array();
			foreach ($list as $subarray) {
				$partition[] = array(
					"min" => min($subarray),
					"max" => max($subarray)
				);
			}
			
			if ($partition[0]['min'] > 0) {
				$partition[0]['min'] = 0;
			}
			
			return $partition;
		}
		
		public static function estimation($N) { return pow(2,$N) ; }
		public static function recommended($N) { return floor(log($N)/log(2) + 1) ; }
	}
	
?>