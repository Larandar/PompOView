<?php
	/*
	 * PompOView :: Coloration
	 * Module de gestion de la coloration des sorties en tableaux.
	 */
	
	require_once('Tableau.php');
	require_once('Matrice.php');
	
	include_once('Coloration/ColorationEmb.php');
	include_once('Coloration/ColorationLin.php');
	
	abstract class Coloration
	{
		
		public $param = 5;
		public $min = 0;
		public $max = 120;
		
		public $matrice = array(array(0));
		public $color;
		
		public function __construct($param = NULL){
			($param != NULL)?($this->param = $param):1;
			$this->genereColor();
		}
		
		public abstract function genereColor($matrice = NULL,$param = NULL);
		
		public function getColorOf($value){
			if($value == 0){
				return $this->color[0]['color'];
			}
			
			foreach($this->color as $color){
				if($color['min'] <= $value and $color['max'] >= $value){
					return $color['color'];
				}
			}
			// Indique une érreur dans le parcours.
			return "hsl(0,100%,10%)";
		}
	}

