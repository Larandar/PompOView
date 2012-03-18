<?php
	/**
	 * 
	 */
	abstract class Partitionneur {
		
		public static function getAll() {
			$all = array(
				"Partitionneur_EntangledKMeans" => "Partition par moyennes emboitées",
				"Partitionneur_Linear"          => "Partition de façon linéaire"
			);
			return $all;
		}
		
		/**
		 * Fonction principale qui produit un partitionnage choisie de la liste 
		 * paramètré par le second paramètre.
		 */
		abstract public static function generer($list,$param);
		
		public static function estimation($N) { return static::calc_estima($N) ;}
		public static function recommended($N) { return static::calc_recomm($N) ;}
		
		abstract protected static function calc_estima($N) ;
		abstract protected static function calc_recomm($N) ;
		
	}
	
?>