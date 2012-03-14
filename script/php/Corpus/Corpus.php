<?php
	/**
	 * Arboraissance :
	 * $corpus_name$.tar.gz ->
	 *     > out.js / out.json / main.json << $manifest
	 *     > corpus/ > Tout les fichier documents <
	 *     > log/    > Tout les log de génération <
	 */
	class Corpus {
		
		protected static $manifest = "out.js";
		
		protected $corpus_path;
		protected $corpus_name;
		protected $corpus_exte;
		protected $corpus_stream;
		
		protected $json;
		
		function __construct($corpus_path) {
			
			$this->corpus_path = $corpus_path;
			
			if ( is_file($corpus_path.'/'.self::$manifest) ) {
				$this->corpus_stream = $corpus_path .'/';
			} else {
				$this->corpus_stream = 'phar://'.$corpus_path .'/';
			}
			
			
			if ($this->exist()) {
				$load = Json::decode($this->corpus_stream.self::$manifest);
			}
		}
		
			$json = Json::clear($json);
			$corpus_opt = Json::decode($json);
		public function exist() {
			return is_file($this->corpus_stream.self::$manifest);
		}
		
		public function subCorpus($toKeep) {
			$toErase = array_diff(array_keys($this->corpus["filenames"]),$toKeep);
			$newjs = CorpusTools_SubCorpus::subCorpusJSON($this->corpus_stream.self::$manifest,$toErase);
			$this->corpus = Json::decode($newjs);
		}
		
		public function getScores() {
			return $this->corpus["corpus_scores"];
		}
		
		public function getFileNames() {
			return $this->corpus["filenames"];
		}
		
		public function getFileName($id) {
			return $this->corpus["filenames"][$id];
		}
		
		public function getFile($name) {
			return file_get_contents($this->corpus_stream.$name);
		}
		
		public function getFileByID($id) {
			$name = $this->getFileName($id);
			return $this->getFile($name);
		}
		
		public function getLogName($name_1,$name_2) {
			$name_1 = preg_replace("#/#", "#", $name_1);
			$name_2 = preg_replace("#/#", "#", $name_2);
			return $name_1 .'_x_'. $name_2 .'.png';
		}
		
		public function getLogNameByID($id_1,$id_2) {
			$name_1 = $this->getFileName($id_1);
			$name_2 = $this->getFileName($id_2);
			return $this->getLogName($name_1,$name_2);
		}
	}
	
?>