<?
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
