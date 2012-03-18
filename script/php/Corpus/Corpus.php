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
		
		protected $projetmode = false;
		
		protected $json;
		
		protected $parent = false;
		protected $projet_dist = "Distance::min";
		
		function __construct($corpus_path) {
			$this->corpus_path = $corpus_path;
			
			$this->corpus_name = str_replace( DATA_DIR, "", $corpus_path );
			
			if ( is_file($corpus_path.'/'.self::$manifest) ) {
				$this->corpus_stream = $corpus_path .'/';
			} else {
				$this->corpus_stream = 'phar://'.$corpus_path .'/';
			}
			
			if ($this->exist()) {
				$load = Json::decode($this->corpus_stream.self::$manifest);
				$this->corpus_base = $load;
				$this->corpus = $load;
				
			}
			
			
		}
		
		public function setParent($povc) {
			$this->parent = $povc;
		}
		
		public function getProjetsDist() {
			if ($this->parent && $this->parent->getClustering()) {
				return $this->parent->getClustering()->getDist();
			} else {
				return $this->group_dist;
			}
		}
		
		public static function fromAjax($json) {
			$json = Json::clear($json);
			$corpus_opt = Json::decode($json);
			$corpus = new Corpus(DATA_DIR.$corpus_opt["corpus"]);
			if (!isset($corpus_opt['corpus_sub'])) {
				$corpus_opt['corpus_sub'] = array_keys($corpus->getFileNames());
			}
			$corpus->subCorpus($corpus_opt['corpus_sub']);
			return $corpus;
		}
		
		public function exist() {
			return is_file($this->corpus_stream.self::$manifest);
		}
		
		public function subCorpus($toKeep) {
			$toErase = array_diff(array_keys($this->corpus["filenames"]),$toKeep);
			$newjs = CorpusTools_SubCorpus::subCorpusJSON($this->corpus_stream.self::$manifest,$toErase);
			$this->corpus = Json::decode($newjs);
		}
		
		
		public function emuleProjet() { 
			$this->groupmode = true; 
			$projets = new Corpus_ProjetExtractor($this);
			
			$matrice = $this->getScores();
			
			foreach ($projets->getProjets() as $projet => $files) {
				$ids = array();
				foreach ($files as $f) { $ids[] = $this->getIDOfFile($f); }
				
				$gname = 'G{'.join($ids,":").'}';
				$matrice = ArrayTools_Matrix::fusionValues($matrice,$ids,$this->getProjetsDist(),$gname);
				
				$gstring = $gname.' : { ';
				$gstring .= join($files," : ");
				$gstring .= ' }';
				$this->corpus_base["filenames"][$gname] = $gstring;
			}
			
			$this->corpus["corpus_scores"] = $matrice;
		}
		
		public function getIDOfFile($name) {
			return array_search($name,$this->getAllFileNames());
		}
		public function getCorpusName() { return $this->corpus_name; }
		
		public function getScores() { return $this->corpus["corpus_scores"]; }
		public function getAllFileNames() { return $this->corpus_base["filenames"]; }
		public function getFileNames() { return $this->corpus_base["filenames"]; }
		
		public function getFileName($id) {
			return $this->corpus_base["filenames"][$id];
		}
		
		public function getFile($name) {
			return file_get_contents($this->corpus_stream.$name);
		}
		
		public function getFileByID($id) {
			$name = $this->getFileName($id);
			return $this->getFile($name);
		}
		
		public function getSignature() { return $this->corpus_base["signature"]; }
		
		public function isActive($filename) {
			return in_array($filename, $this->corpus['filenames']);
		}
		
		public function getLogName($name_1,$name_2) {
			$name_1 = preg_replace("#/#", "#", $name_1);
			$name_2 = preg_replace("#/#", "#", $name_2);
			$nb = count($this->corpus["signature"]["documentDistanceFilter"]);
			return $this->corpus_stream."log/".$name_1 .'_x_'. $name_2 . $nb .'.png';
		}
		
		public function getLogNameByID($id_1,$id_2) {
			$name_1 = $this->getFileName($id_1);
			$name_2 = $this->getFileName($id_2);
			return $this->getLogName($name_1,$name_2);
		}
	}
	
?>