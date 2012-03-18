<?php
	/**
	* 
	*/
	class FiltrageDoc_Factory {
		
		protected function getFiltre($str) {
			$correspondance = array(
				"id" => "FiltrageDoc_FiltreIdentite",
				"el" => "FiltrageDoc_FiltreEmptyLine",
				"s"  => "FiltrageDoc_FiltreWhiteSpace",
				"t"  => "FiltrageDoc_FiltreTTraitement"
			);
			return $correspondance[$str];
		}
		
		
		public function getSegmenteur($str) {
			$correspondance = array(
				"nl" => "FiltrageDoc_SegmenteurNewLine",
				"c" => "FiltrageDoc_SegmenteurFixedChar"
			);
			return $correspondance[$str];
		}
		
		
		protected $init;		
		protected $filtres;
		protected $segmenteur;
		
		public function __construct(array $filtres,array $seg) {
			
			$this->filtres = array();
			$this->init = new FiltrageDoc_FiltreIdentite();
			
			foreach ($filtres as $code) {
				$filtre = $this->getFiltre($code);
				$this->filtres[] = new $filtre();
			}
			
			$segmenteur = $this->getSegmenteur($seg[0]);
			$this->segmenteur = new $segmenteur($seg[1]);
		}
		
		public function make($document) {
			$doc_original = $document;
			$hashtable = array();
			
			$this->init->applyTo($document);
			$hashtable = $this->init->getHashTable();
			
			foreach ($this->filtres as $filtre) {
				$filtre->applyTo($document);
				$document = $filtre->getFilteredDocument();
				
				$filtre->fusionWith($hashtable);
				$hashtable = $filtre->getHashTable();
			}
			
			$this->segmenteur->applyTo($document);
			$this->segmenteur->fusionWith($hashtable);
			$hashtable = $this->segmenteur->getSegmentedDoc($doc_original);
			return $hashtable;
		}
	}
	
?>