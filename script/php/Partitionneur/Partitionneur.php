<?php
	/**
	 * 
	 */
	abstract class Partitionneur {
		/**
		 * Fonction principale qui produit un partitionnage choisie de la liste 
		 * paramètré par le second paramètre.
		 */
		abstract public static function generer($list,$param);
		
		abstract public static function estimation($N);
		abstract public static function recommended($N);
	}
	
?>