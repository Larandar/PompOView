<?php
	/**
	 * 
	 */
	class Corpus_ProjetExtractor {
		
		protected $filenames;
		protected $projets;
		
		public function __construct(Corpus $corpus) {
			$this->filenames = $corpus->getFileNames();
			
			$this->compute();
		}
		
		public function compute() {
			$projets = array();
			
			foreach ($this->filenames as $name) {
				$projets[] = explode("/", $name );
			}
			
			$projets = $this->fusionPath($projets);
			
			$this->groups = $projets;
		}
		
		protected function fusionPath($projets) {
			$fusion = array();
			$root = array();
			$inroot = true;
			
			while ($inroot) {
				$rootp = current($projets[0]);
				foreach ($projets as $file) {
					$inroot = $inroot && (current($file) == $rootp);
				}
				if ($inroot) {
					foreach ($projets as $key => $_) {
						next($projets[$key]);
					}
					$root[] = $rootp."/";
				}
			}
			
			$rootc = count($root);
			foreach ($projets as $key => $file) {
				$filename = join($file, "/");
				$proot = '{'.$file[$rootc].'/}';
				if (!isset($fusion[$proot])) {
					$fusion[$proot] = array();
				}
				$fusion[$proot][] = $filename;
			}
			
			$fusion = array("root" => join($root, ""), "groups" => $fusion);
			return $fusion;
		}
		
		public function getProjets() { return $this->groups["groups"] ; }
		public function getRoot() { return $this->groups["root"] ; }
	}
	
?>