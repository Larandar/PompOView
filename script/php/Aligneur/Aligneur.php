<?php
	/**
	* 
	*/
	class Aligneur {
		
		protected $logfile;
		protected $numseg1;
		protected $numseg2;
		
		protected $segrel1;
		protected $segrel2;
		
		
		public function __construct($logfile,$numseg1,$numseg2) {
			
			$this->logfile = $logfile;
			$this->numseg1 = $numseg1;
			$this->numseg2 = $numseg2;
			
			$this->compute();
		}
		
		public function compute() {
			$this->segrel1 = array_fill(0,$this->numseg1,false);
			$this->segrel2 = array_fill(0,$this->numseg2,false);
		}
		
		public function getRelation1() { return $this->segrel1 ; }
		public function getRelation2() { return $this->segrel2 ; }
	}
	
?>