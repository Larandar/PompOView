<?php
	/**
	 * 
	 */
	class Json {
		
		public static function decode($json) {
			if (is_file($json)) {
				$json = file_get_contents($json);
			}
			$json = self::clear($json);
			$decode = json_decode($json);
			return (array) $decode;
		}
		
		public static function encode($json) {
			return json_encode($json);
		}
		
		public static function clear($json) {
			$from = array(
				'/\"\s*\{(.*)\}\s*\"/',       // On remplace les dictionnaire "{}" par {} directement
				'/\'/',                       // Les ' par ""
				'/(\{|\[)(\s*)\"?([^"]*)\"?(\s*:)/',
				'/\,\s*(\]|\})/',             // On suprime les , de type ,] et ,}
				'/True/'                      // On change les "True" en "true"
			);
			$to = array( '{\1}', '"','\1\2"\3"\4' , '\1', 'true' );
			$json = preg_replace($from,$to,$json);
			return $json;
		}
	}
	
?>