<?php
	/**
	* 
	*/
	
	class Matrice
	{
		public static function triangularValues($matrix, $sort = false){
			$values = array();
			foreach($matrix as $i => $sub){
				foreach($sub as $j => $elem){
					if($i>$j){$values[]=$elem;};
				}
			}
			if($sort){
				sort($values);
			}
			return $values;
		}
	}