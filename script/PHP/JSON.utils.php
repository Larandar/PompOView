<?
	/*
	 * JSON Tools by Adrien 'Larandar' Dudouit-Exposito
	 * Licences MIT
	 * Copyright © 08/11/2011, Adrien 'Larandar' Dudouit-Exposito
	 * Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
	 * The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
	 * The Software is provided "as is", without warranty of any kind, express or implied, including but not limited to the warranties of merchantability, fitness for a particular purpose and noninfringement. In no event shall the authors or copyright holders be liable for any claim, damages or other liability, whether in an action of contract, tort or otherwise, arising from, out of or in connection with the software or the use or other dealings in the Software.
	 * Except as contained in this notice, the name of the Adrien 'Larandar' Dudouit-Exposito shall not be used in advertising or otherwise to promote the sale, use or other dealings in this Software without prior written authorization from the Adrien 'Larandar' Dudouit-Exposito
	 */
	
	class JSON{
		static public function lastError(){
			$a = array(
				JSON_ERROR_NONE => 'JSON_ERROR_NONE: Aucune erreur n\'est survenue'.PHP_EOL,
				JSON_ERROR_DEPTH => 'JSON_ERROR_DEPTH: La profondeur maximale de la pile a été atteinte'.PHP_EOL,
				JSON_ERROR_STATE_MISMATCH => 'JSON_ERROR_STATE_MISMATCH: JSON invalide ou mal formé'.PHP_EOL,
				JSON_ERROR_CTRL_CHAR => 'JSON_ERROR_CTRL_CHAR: Erreur lors du contrôle des caractères ; probablement un encodage incorrect'.PHP_EOL,
				JSON_ERROR_SYNTAX => 'JSON_ERROR_SYNTAX: Erreur de syntaxe'.PHP_EOL,
				JSON_ERROR_UTF8 => 'JSON_ERROR_UTF8: Caractères UTF-8 malformés, possiblement mal encodés'.PHP_EOL
			);
			return $a[json_last_error()];
		}
		static public function serialize($JSONPath){
			$JSON = file_get_contents($JSONPath);
			
			// PHP suporte:
			//  - Les dictionnaires emboité
			// PHP ne suporte pas:
			//  - les attributs marquer via ' '   -_-'
			//  - "," en fin de dictionnaire/list ;)
			//  - True a la place de true
			$JSON = preg_replace(array('/\"\s*\{(.*)\}\s*\"/','/\'/','/\,\s*(\]|\})/','/True/'),array('{\1}','"','\1','true'),$JSON);
			
			return $JSON;
		}
	}