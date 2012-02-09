<?php
	/**
	* 
	*/
	class Json_Clear {
		
		public static function clear($json) {
			$from = array(
				'/\"\s*\{(.*)\}\s*\"/',       // On remplace les dictionnaire "{}" par {} directement
				'/\'/',                       // Les ' par ""
				'/\,\s*(\]|\})/',             // On suprime les , de type ,] et ,}
				'/True/'                      // On change les "True" en "true"
			);
			$to = array( '{\1}', '"', '\1', 'true' );
			preg_replace($from,$to,$json);
			return $json;
		}
	}
	
?>