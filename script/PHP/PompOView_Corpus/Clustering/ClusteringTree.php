<?
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
