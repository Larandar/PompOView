<?
	/* Fonctions de fusion des lignes:
	 * déja disponible : 'min' 'max'
	 * potentiellement toute fonction de R2 -> R (Des test sur 'pow' on été effectuer... pas trés concluant)
	 * Ajouté ici : 'med' x,y -> x+y/2, 'add' x,y -> x+y, 'dif' x,y -> abs(x-y)
	 */
	function med($x,$y){
		return ($x+$y)/2;
	}
	function add($x,$y){
		return $x+$y;
	}
	function dif($x,$y){
		return abs($x-$y);
	}
	
	/**
	* 
	*/
	class ClusteringTree
	{
		public $level;
		public $value;
		public $name;
		public $child = array();
		public $contains;
		public $isLeave = false;

		public function __construct($ch1,$ch2,$value = null,$level = 1){
			$this->name = $ch1->name .':'. $ch2->name;
			$this->contains = array_merge($ch1->contains,$ch2->contains);
			$this->child[0] = $ch1;
			$this->child[1] = $ch2;
			$this->value = $value;
			$this->level = $level;
		}

		public function makeOrder(){
			$order1 = $this->child[0]->makeOrder();
			$order2 = $this->child[1]->makeOrder();
			$level1 = $this->child[0]->level;
			$level2 = $this->child[1]->level;
			if (($level1 == null || $level2 == null) || $level1 < $level2) {
				$order = array_merge($order1,$order2);
			}
			else {
				$order = array_merge($order2,$order1);
			}

			return $order;
		}
	}

	/**
	* 
	*/
	class ClusteringLeave
	{
		public $level = null;
		public $name;
		public $contains;
		public $value;
		public $isLeave = true;

		public function __construct($value)
		{
			$this->name = (string)$value;
			$this->value = (int)$value;
			$this->contains = array($value);
		}

		public function makeOrder(){
			return array($this->value);
		}
	}
	/**
	* 
	*/
	abstract class Clustering
	{
		
		
		public $data = array(array());
		public $order = array();
		public $hide = array();
		
		
		public $dist;
		
		
		public function __construct($dist = 'min'){
			$this->dist = $dist;
		}
		
		public static function clusteringMatrix($matrice){
			$retour = array();
			foreach($matrice as $key => $sub){
				$sretour = array();
				foreach($sub as $skey => $val){
					$sretour[(string)$skey] = $val;
				}
				$retour[(string)$key] = $sretour;
			}
			return $retour;
		}
		
		public static function fusionLigne($matrice, $l1, $l2, $call = 'min'){
			$ligne1 = $matrice[$l1];
			$ligne2 = $matrice[$l2];
			$ligneret = array();
			foreach($ligne1 as $key => $value){
				$ligneret[$key] = $call($ligne1[$key],$ligne2[$key]);
			}
			unset($matrice[$l1],$matrice[$l2]);
			$matrice[$l1.':'.$l2] = $ligneret;
			
			foreach($matrice as $key => $array){
				$matrice[$key][$l1.':'.$l2] = $call($array[$l1],$array[$l2]);
				unset($matrice[$key][$l1],$matrice[$key][$l2]);
			}
			return $matrice;
		}
		
		public function setData($data)
		{
			$this->data = $this->clusteringMatrix($data);
			$this->data_back = $this->data;
		}
		
		public function toShow($show){
			$toHide = array();
			foreach($this->order as $ind){
				if(!in_array($ind,$show)){
					$toHide[] = $ind;
				}
			}
			$this->setHide($toHide);
		}
		
		public function setHide($hide){
			$this->hide = (array) $hide;
		}
		public function getOrder(){
			$order = $this->order;
			foreach($this->hide as $val){
				$ind = array_search($val,$order);
				if($ind !== FALSE){
					unset($order[$ind]);
				}
			}
			return $order;
		}
	}
	
	
	/**
	* 
	*/
	class HierarchicalClustering extends Clustering
	{
		public function generation($data = null){
			if ($data == null){
				$this->data = $this->data_bak;
			}
			else{
				$this->setData($data);
			}
			
			$toAsign = array();
			$last = 0;
			
			foreach($this->data as $key=>$_){
				$toAsign[$key] = new ClusteringLeave($key);
			}
			$level = 0;
			while(count($toAsign)>1){
				$level++;
				$pos = $this->chooseGood();
				$a = $pos[0];
				$b = $pos[1];
				$o = $a.':'.$b;
				$toAsign[$o] = new ClusteringTree(
					$toAsign[$a],
					$toAsign[$b],
					$this->data[$a][$b],
					$level
					);
				
				unset($toAsign[$a]);
				unset($toAsign[$b]);
				$this->data = $this->fusionLigne($this->data,$a,$b,$this->dist);
				$last=$o;
			}
			$order = $toAsign[$last]->makeOrder();
			$this->order = $order;
		}
		
		function chooseGood(){
			$min = null;
			$pos = array();
			foreach($this->data as $i=>$sarray){
				foreach($sarray as $j=>$val){
					if($i!=$j and ($min==null || $val<$min)){
						$min = $val;
						$pos = array($i,$j);
					}
				}
			}
			return $pos;
		}
	}
	
	