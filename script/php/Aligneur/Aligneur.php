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
			$this->segrel1 = array_fill(0,$this->numseg1,array(false));
			$this->segrel2 = array_fill(0,$this->numseg2,array(false));
			
			foreach ( $this->segrel1 as $key => $_) {
				$this->segrel1[$key] = $this->calcule(1,$key);
			}
			foreach ( $this->segrel2 as $key => $_) {
				$this->segrel2[$key] = $this->calcule(2,$key);
			}
		}
		
		protected function calcule($n,$k) {
			if (((int)$k/5) % 3) {
				return false;
			} else {
				return array( true, (int) ($k/5) , (int) ($k/5) );
			}
		
		}
		
		public function getRelation1() { return $this->segrel1 ; }
		public function getRelation2() { return $this->segrel2 ; }
	}
	
?>