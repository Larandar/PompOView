<?
	/**
	* 
	*/
	
	class Tableau
	{
		public static function cutMoyenne($array){
			if(count($array) <= 1){return (array)$array;}
			$_return = array(array(),array());
			$moy = array_sum($array)/count($array);
			
			foreach($array as $val){
				$k = ($val<=$moy)?0:1;
				$_return[$k][] = $val;
			}
			
			return $_return;
		}
		public static function recMoyenne($arg,$prof=2){
			$return = array($arg);
			for( $i=1; $i<=$prof; $i++){
				$stock = array();
				foreach($return as $array){
					$moy = Tableau::cutMoyenne($array);
					foreach($moy as $_){
						$stock[] = (array)$_;
					}
				}
				$return = $stock;
			}
			return $return;
		}
	}
