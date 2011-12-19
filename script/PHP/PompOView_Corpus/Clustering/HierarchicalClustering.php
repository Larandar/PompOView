<?
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
