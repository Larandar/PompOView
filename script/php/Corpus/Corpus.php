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
		protected $projetroot = '';
		
		protected $json;
		
		protected $projet;
		
		protected $parent = false;
		protected $projet_dist = "Distance::min";
		
		function __construct($corpus_path) {
			$this->corpus_path = $corpus_path;
			
			$this->corpus_name = str_replace( DATA_DIR, "", $corpus_path );
			
			if ( @is_file($corpus_path.'/'.self::$manifest) ) {
				$this->corpus_stream = $corpus_path .'/';
			} else if ( @is_file('phar://'.$corpus_path .'/'.self::$manifest)){
				$this->corpus_stream = 'phar://'.$corpus_path .'/';
			} else {
				$stream = 'phar://'.$corpus_path .'/';
				$dirs = scandir($stream);
				$dirs = array_filter($dirs,function ($a) { 
					return !preg_match("/^[._]|\.json$/",$a); 
				});
				$this->corpus_stream = $stream.array_pop($dirs)."/";
			}
			
			if ($this->exist()) {
				
				$load = Json::decode($this->corpus_stream.self::$manifest);
				$this->corpus_base = $load;
				$this->corpus = $load;
				$this->filename_base = $load["filenames"];
			}
			
		}
		
		
		public static function fromAjax($json,$sub_opt = false) {
			$corpus_opt = Json::decode($json);
			$corpus = new Corpus(DATA_DIR.$corpus_opt["corpus"]);
			
			if ($sub_opt && !empty($sub_opt)) {
				$corpus_opt['corpus_sub'] = $sub_opt;
			} else {
				$corpus_opt['corpus_sub'] = array_keys($corpus->getFileNames());
			}
			
			$corpus->subCorpus($corpus_opt['corpus_sub']);
			return $corpus;
		}
		
		
		public function subCorpus($toKeep) {
			$toErase = array_diff(array_keys($this->corpus["filenames"]),$toKeep);
			$newjs = CorpusTools_SubCorpus::subCorpusJSON($this->corpus_stream.self::$manifest,$toErase);
			$this->corpus = Json::decode($newjs);
		}
		
		
		public function emuleProjet() { 
			$this->projetmode = true; 
			$projets = new Corpus_ProjetExtractor($this);
			
			$this->projets = $projets->getProjets();
			$this->projetroot = $projets->getRoot();
			$matrice = $this->getScores();
			
			foreach ($projets->getProjets() as $projet => $files) {
				$ids = array();
				foreach ($files as $f) { 
					if ($this->isActive($f)) {
						$ids[] = $this->getNewIDOfFile($f);
					}
				}
				
				$gname = $projet;
				$matrice = ArrayTools_Matrix::fusionValues($matrice,$ids,$this->getProjetsDist(),$gname);
				
				
				$gstring = $gname.' : { ';
				$gstring .= join($files," : ");
				$gstring .= ' }';
				
				$this->corpus_base["filenames"][$gname] = $gstring;
				$this->corpus["filenames"][$gname]      = $gstring;
				
			}
			
			
			$this->corpus["corpus_scores"] = $matrice;
		}
		
		
		public function exist() {
			return @is_file($this->corpus_stream.self::$manifest);
		}
		
		
		public function getFileByID($id) {
			$name = $this->getFileName($id);
			return $this->getFile($name);
		}
		
		public function getLogName($name_1,$name_2) {
			$name_1 = preg_replace("#/#", "#", $name_1);
			$name_2 = preg_replace("#/#", "#", $name_2);
			$nb = count($this->corpus["signature"]["documentDistanceFilter"]);
			return $this->corpus_stream."log/".$name_1 .'_x_'. $name_2 . $nb .'.png';
		}
		
		public function getLogNameByID($id_1,$id_2) {
			$name_1 = $this->getFileName(min($id_1,$id_2));
			$name_2 = $this->getFileName(max($id_1,$id_2));
			return $this->getLogName($name_1,$name_2);
		}
		
		public function getProjets() {
			if ($this->projetmode) {
				return $this->projets;
			} else {
				$projets = new Corpus_ProjetExtractor($this);
				$this->projetroot = $projets->getRoot();
				return $projets->getProjets();
			}
		}
		
		public function getProjetsDist() {
			if ($this->parent && $this->parent->getClustering()) {
				return $this->parent->getClustering()->getDist();
			} else {
				return $this->projet_dist;
			}
		}
		
		public function ProjetMode() { return $this->projetmode; }
		public function getProjetsRoot() { return $this->projetroot; }
		public function getProjet() { return $this->projets ;}
		
		
		public function getCorpusName() { return $this->corpus_name; }
		public function getScores() { return $this->corpus["corpus_scores"]; }
		public function getBaseScores() { return $this->corpus_base["corpus_scores"]; }
		public function getSignature($val = false) { 
			if ($val) {
				return $this->corpus_base["signature"][$val];
			} else {
				return $this->corpus_base["signature"]; 
			}
		}
		
		public function getFileNames() { return $this->corpus["filenames"]; }
		public function getBaseFileNames() { return $this->filename_base; }
		public function getAllFileNames() { return $this->corpus_base["filenames"]; }
		
		public function getNewIDOfFile($name) {
			$i = array_search($name,$this->getFileNames()) ;
			return $i !== false ? $i : false ;
		}
		public function getIDOfFile($name) {
			return array_search($name,$this->getAllFileNames());
		}
		
		public function isActive($filename) { return $this->getNewIDOfFile($filename) !== false; }
		
		public function getFileName($id) { return $this->corpus_base["filenames"][$id]; }
		public function getFile($name) {
			return file_get_contents($this->corpus_stream.$name);
		}
		
		public function setParent($povc) { $this->parent = $povc; }
		
		
	}
	
?>