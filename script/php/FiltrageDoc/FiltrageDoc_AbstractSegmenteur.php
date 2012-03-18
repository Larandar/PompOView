<?php
	/**
	 * 
	 */
	abstract class FiltrageDoc_AbstractSegmenteur {
		
		protected $hashtable = array();
		protected $iscompute = false;
		
		protected $segmenthash = array();
		
		protected $complete_doc;
		protected $filtered_doc;
		
		protected $regex_matchin;
		protected $regex_replace = " ";
		
		protected $param;
		
		public function __construct($param) {
			$this->param = $param;
		}
		
		public function applyTo($text) {
			$this->setDocument($text);
			$this->compute();
		}
		
		public function fusionWith($basetable) {
			$hashtable = array();
			
			foreach ($this->hashtable as $key => $back) {
				$values = array();
				foreach ($back as $value) {
					$tmp = array_merge($values,$basetable[$value]);
					$values = $tmp;
				}
				$hashtable[$key] = $values;
			}
			
			$this->hashtable = $hashtable;
			
			// On ne garde que le maximum et le minimum
			foreach ($hashtable as $key => $value) {
				$hashtable[$key] = array(
					"s" => min($value),
					"e" => max($value),
					"l" => 1 + max($value) - min($value) 
				);
			}
			
			$this->segmenthash = $hashtable;
			
			$this->computeSegment();
			
		}
		
		public function compute() {
			$hashtable = array();
			
			$matchin = $this->getAllMatchin();
			
			$count_orig = 0;
			$count_nouv = 0;
			
			foreach ($matchin[0] as $match) {
				$strlen = mb_strlen($match[0]);
				$offset = $match[1];
				
				if ($offset > $count_orig) {
					$hashtable[$count_nouv] = range( $count_orig, $offset -1 );
					$count_orig  = $offset;
					$count_nouv += 1;
				}
				
				$hashtable[$count_nouv] = range( $count_orig, $count_orig + $strlen -1 );
				$count_nouv += 1 ;
				$count_orig += $strlen ;
				
			}
			
			if ($count_orig <  mb_strlen($this->complete_doc) ) {
				$hashtable[$count_nouv] = range( $count_orig, mb_strlen($this->complete_doc) - 1 );
			}
			
			// On stocke la hashtable obtenu ainsi
			$this->hashtable = $hashtable;
			
		}
		
		public function computeSegment($document) {
			$segmenthash = $this->getHashSegment();
			
			$segmentation = array();
			
			foreach ($segmenthash as $key => $seg) {
				$segmentation[$key] = array(mb_substr($document, $seg["s"], $seg["l"]));
			}
			
			$this->segmented_doc = $segmentation;
		}
		
		public function getSegmentedDoc($document) {
			$this->computeSegment($document);
			return $this->segmented_doc;
		}
		
		public function getHashTable() {
			return $this->hashtable;
		}
		
		public function getHashSegment() {
			return $this->segmenthash;
		}
		
		protected function setDocument($text) { $this->complete_doc = $text ; }
		
		protected function getAllMatchin() {
			$matchin = array();
			preg_match_all($this->getMatchinRegex(), $this->complete_doc, $matchin, PREG_OFFSET_CAPTURE );
			return $matchin;
		}
		
		public function getMatchinRegex() {
			return sprintf($this->param_regex,$this->param);
		}
		
	}
?>