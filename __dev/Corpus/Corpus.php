<?php
	/**
	 * Arboraissance :
	 * $corpus_name$.tar.gz ->
	 *   > $corpus_name$/ ->
	 *     > main.json
	 *     > corpus/ > Tout les fichier documents <
	 *     > log/    > Tout les log de génération <
	 */
	class Corpus {
		
		protected static $manifest = "out.js";
		
		protected $corpus_path;
		protected $corpus_name;
		protected $corpus_exte;
		protected $corpus_phar;
		
		protected $corpus_manifest;
		
		function __construct($corpus_path) {
			$this->corpus_path = $corpus_path;
			preg_match("_.*/(?P<name>.*)\.(?P<exte>tar\.gz|targz|zip)_",$corpus_path,$corpus_preg);
			$this->corpus_name = $corpus_preg["name"];
			$this->corpus_exte = $corpus_preg["exte"];
			
			$this->corpus_phar = 'phar://'.$corpus_path .'/'. $corpus_preg["name"] . '/';
			
			$load = file_get_contents($this->corpus_phar.self::$manifest);
			$load = json_decode($load);
			$this->corpus_manifest = $load["filenames"];
		}
		
		public function fileName($id) {
			
		}
		
		public function exist() {
			return is_file($this->corpus_phar.self::$manifest);
		}
		
		
	}
	
?>