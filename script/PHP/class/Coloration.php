<?
	/*
	 * PompOView :: Coloration
	 * Module de gestion de la coloration des sorties en tableaux.
	 */
	
	require_once($GLOBALS['SCRIPT_DIRECTORY'].'PHP/utils/Tableau.php');
	require_once($GLOBALS['SCRIPT_DIRECTORY'].'PHP/utils/Matrice.php');
	
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
			foreach($this->color as $color){
				if($color['min'] <= $value and $color['max'] >= $value){
					return $color['color'];
				}
				elseif($value == 0){
					return $this->color[0]['color'];
				}
			}
			return $this->color[0];
		}
	}
	
	/**
	* 
	*/
	class ColorationEmb extends Coloration
	{
		
		public $param = 3;
		public $min = 25;
		public $max = 120;
		
		public function genereColor($matrice = NULL,$param = NULL)
		{
			$this->matrice = ($matrice !== NULL)?$matrice:$this->matrice;
			$this->param = ($matrice !== NULL)?$param:$this->param;
			$values = Matrice::triangularValues($this->matrice,true);
			$moy = Tableau::recMoyenne($values,$this->param);
			foreach($moy as $i => $arr){
				$color = array(
					'min' => min($arr),
					'max' => max($arr),
					'color' => sprintf("hsl(%d,100%%,60%%)",$this->min+($this->max-$this->min)*($i)/(count($moy)-1))
				);
				$moy[$i] = $color;
			}
			$this->color = $moy;
		}
	}
	
	class ColorationLin extends Coloration
	{
		
		public $param = 3;
		public $min = 0;
		public $max = 120;
		
		public function genereColor($matrice = NULL,$param = NULL)
		{
			$this->matrice = ($matrice !== NULL)?$matrice:$this->matrice;
			$this->param = ($matrice !== NULL)?$param:$this->param;
			$values = Matrice::triangularValues($this->matrice,true);
			$color = array();
			for($i = 0; $i < $this->param; $i++){
				$color[] = array(
					'min' => $i/$this->param,
					'max' => ($i+1)/$this->param,
					'color' => sprintf("hsl(%d,100%%,60%%)",$this->min+($this->max-$this->min)*$i/($this->param))
				);
			}
			
			$this->color = $color;
		}
	}