<?
	/**
	* 
	*/
	class NullClustering extends Clustering
	{
		public function generation($data = null)
		{
			if ($data == null){
				$this->data = $this->data_bak;
			}
			else{
				$this->setData($data);
			}
			$this->order = array_keys($data);
		}
	}
