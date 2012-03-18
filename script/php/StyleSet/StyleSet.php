<?php
	/**
	 * 
	 */
	abstract class StyleSet {
		
		public static function getAll() {
			$all = array(
				"StyleSet_ColorHSL" => "Coloration HSL des valeurs"
			);
			return $all;
		}
		
		
		protected $part_name;
		protected $part_data;
		protected $part_parm;
		
		protected $partition = false;
		
		public function __construct($part_name, $part_data = null, $part_parm = null) {
			$this->part_name = $part_name;
			$this->part_data = $part_data;
			$this->part_parm = $part_parm;
		}
		
		abstract public static function genereStyle($I,$N);
		abstract public static function errorStyle();
		
		protected function generer() {
			$partition = call_user_func($this->part_name.'::generer',$this->part_data,$this->part_parm);
			$N = count($partition);
			
			$this->partition = array();
			foreach ($partition as $I => $value) {
				$value["style"] = $this::genereStyle($I,$N);
				$this->partition[$I] = $value;
			}
		}
		public function getStyleOf($val) {
			if (!$this->partition) { $this->generer(); }
			
			foreach ($this->partition as $part) {
				if ( $part["min"] <= $val && $val <= $part["max"] ) {
					return $part["style"];
				}
			}
			
			return $this::errorStyle();
		}
		
		public function setPartitionneur($name) { $this->part_name = $name; $this->partition = false; }
		public function getPartitionneur() { return $this->part_name ; }
		
		public function setData($data,$parm = null) { $this->part_data = $data; $this->part_parm = $parm; $this->partition = false; }
	}
	
?>