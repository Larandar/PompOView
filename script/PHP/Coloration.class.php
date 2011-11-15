<?
	/*
	 * PompOView :: Coloration
	 * Module de gestion de la coloration des sorties en tableaux.
	 */
	
	require_once('Tableau.package.php');
	require_once('Matrice.package.php');
	
	class Coloration
	{
		public $profondeur;
		public $matrice;
		public $color;
		
		public $min = 40;
		public $max = 180;
		
		public function __construct($matrice = array(array(0)),$profondeur = 2){
			$this->profondeur = $profondeur;
			$this->matrice = $matrice;
			$this->genereColor();
		}
		
		public function genereColor($matrice = NULL,$profondeur = NULL){
			$this->matrice = ($matrice !== NULL)?$matrice:$this->matrice;
			$this->profondeur = ($matrice !== NULL)?$profondeur:$this->profondeur;
			$values = Matrix::triangularValues($this->matrice,true);
			$values[] = 0; // Un unique 0 pour le minimum
			$moy = Tableau::recMoyenne($values,$this->profondeur);
			foreach($moy as $i => $arr){
				$color = array(
					'min' => min($arr),
					'max' => max($arr),
					'color' => sprintf("hsl(%d,100%%,60%%)",$this->min+($this->max-$this->min)*($i)/(count($moy)))
				);
				$moy[$i] = $color;
			}
			
			$this->color = $moy;
		}
		
		public function getColorOf($value){
			foreach($this->color as $color){
				if(max(0,$color['min']) <= $value and $color['max'] >= $value){
					return $color['color'];
				}
			}
			echo '...'.$value.' not in range??'.PHP_EOL;
			return $this->color[0];
		}
	}