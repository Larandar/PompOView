<?

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
