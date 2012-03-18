<?php
	/**
	 * 
	 */
	class FiltrageDoc_HashTableTool {
		
		static public function prettyPrint($hashtable) {
			$print = "";
			foreach ($hashtable as $key => $value) {
				$print .= sprintf("[ %s ] %s\n",$key,self::prettyListPrint($value));
			}
			return $print;
		}
		
		static protected function prettyListPrint($array) {
			$print  = "{ "; $first = true;
			foreach ($array as $value) {
				if ($first) { $first = false; }
				else { $print .= ", "; }
				$print .= $value;
				
			}
			$print .= " }";
			return $print;
		}
		
	}
?>
