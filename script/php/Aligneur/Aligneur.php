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
			$log = new LogImage($this->logfile);
			
			$groups = array();
			$x = 0; $y = 0;
			$g = 0;
			
			while ( $x < $this->numseg1 ) {
				$cond = false;
				while ( !$cond && $y < $this->numseg2) {
					$cond = $log->getValue($x,$y);
					$y += $cond ? 0 : 1;
				}
				
				if ($cond) {
					$group = array("x" => array(), "y" => array());
					$group["x"][] = $x;
					$group["y"][] = $y;
					while ($log->getValue($x+1,$y+1)) {
						$x++ ; $y++;
						$group["x"][] = $x;
						$group["y"][] = $y;
						$group["k"][] = $g;
					}
					$groups[$g++] = $group;
				}
				
				$x++; $y=0;
			}
			
			$this->segrel1 = array_fill(0,$this->numseg1,array(false));
			$this->segrel2 = array_fill(0,$this->numseg2,array(false));
			
			foreach ($groups as $g => $values) {
				foreach ($values["k"] as $key => $_) {
					$this->segrel1[$values["x"][$key]] = array(true,$g);
					$this->segrel2[$values["y"][$key]] = array(true,$g);
				}
			}
			
		}
		
		public function getRelation1() { return $this->segrel1 ; }
		public function getRelation2() { return $this->segrel2 ; }
	}
	
?>