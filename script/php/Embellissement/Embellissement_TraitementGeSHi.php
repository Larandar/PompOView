<?php
	/**
	 * 
	 */
	class Embellissement_TraitementGeSHi extends Embellissement_AbstractTraitement {
		
		function __construct() {
			__autoload("GeSHi");
		}
		
		public function applyTo($filename,$doc,$ali) {
			
			$ext = pathinfo($filename, PATHINFO_EXTENSION);
			$lang = self::$langs[$ext];
			
			
			foreach ($doc as $key => $str) {
				$doc[$key] = $this->applyGeShi($str[0],$lang);
			}
			return $doc;
		}
		
		protected function applyGeShi($str,$lang) {
			$g = new GeSHi($str,$lang);
			$g->set_header_type(GESHI_HEADER_NONE);
			
			return $g->parse_code();
		}
		
		protected static $langs = array(
			"c"    => "c",
			"h"    => "c",
			"cpp"  => "cpp",
			"css"  => "css",
			"html" => "xml",
			"hs"   => "haskell",
			"java" => "java",
			"js"   => "javascript",
			"json" => "javascript",
			"lua"  => "lua",
			"php"  => "php",
			"py"   => "python",
			"xml"  => "xml"
		);
		
	}
	
?>