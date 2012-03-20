<?php
	/**
	 * 
	 */
	class Json {
		
		public static function decode($json) {
			if (@is_file($json)) {
				$json = file_get_contents($json);
			}
			$json = self::clear($json);
			$decode = json_decode($json,true);
			if (json_last_error()) {
				$json_error = array(
					JSON_ERROR_NONE => "Aucune erreur n'est survenue", 
					JSON_ERROR_DEPTH => "La profondeur maximale de la pile a été atteinte", 
					JSON_ERROR_STATE_MISMATCH => "JSON invalide ou mal formé", 
					JSON_ERROR_CTRL_CHAR => "Erreur lors du contrôle des caractères ; probablement un encodage incorrect", 
					JSON_ERROR_SYNTAX =>" Erreur de syntaxe", 
					JSON_ERROR_UTF8 => "Caractères UTF-8 malformés, possiblement mal encodés"
				);
				throw new JSON_Exception($json_error[json_last_error()]);
			}
			$decode = (array) $decode;
			return $decode;
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
				'/True/',                      // On change les "True" en "true"
				'/\s*/'
			);
			$to = array( '{\1}', '"','\1\2"\3"\4' , '\1', 'true', '' );
			$json = preg_replace($from,$to,$json);
			return $json;
		}
	}
	
	class JSON_Exception extends Exception {} ;
?>