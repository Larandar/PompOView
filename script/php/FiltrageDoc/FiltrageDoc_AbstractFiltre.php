<?php
	/**
	 * 
	 */
	abstract class FiltrageDoc_AbstractFiltre {
		
		protected $hashtable = array();
		protected $iscompute = false;
		
		protected $complete_doc;
		protected $filtered_doc;
		
		// Les deux attribut qu'il faut redéfinir pour 
		protected $regex_matchin;
		protected $regex_replace;
		
		
		public function __construct() {
			if (!(isset($this->regex_matchin) && isset($this->regex_replace))) {
				throw new Exception('Un filtre doit avoir les deux attributs $regex_matchin et $regex_replace de définis dans sa déclaration.');
			}
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
		}
		
		
		public function compute() {
			$hashtable = array();
			
			$matchin = $this->getAllMatchin();
			
			$count_orig = 0;
			$count_nouv = 0;
			
			foreach ($matchin[0] as $match) {
				$strlen = mb_strlen($match[0]);
				$newlen = mb_strlen($this->replace($match[0]));
				$offset = $match[1];
				
				if ($offset > $count_orig) {
					for ($count_orig = $count_orig; $count_orig < $offset ; $count_orig++) { 
						$hashtable[$count_nouv] = array($count_orig);
						$count_nouv++;
					}
				}
				for ($i=$count_nouv; $i < ($count_nouv + $newlen ) ; $i++) {
					$hashtable[$i] = range( $count_orig, $count_orig + $strlen -1 );
				}
				$count_nouv += $newlen ;
				$count_orig += $strlen ;
				
			}
			
			for ($i = $count_orig; $i < mb_strlen($this->complete_doc) ; $i++) {
				$hashtable[$count_nouv] = array($i);
				$count_nouv++;
			}
			
			
			// On stocke la hashtable obtenu ainsi
			$this->hashtable = $hashtable;
			
			// Pour finir on applique le filtre sur le document et on stocke la chaine résultante
			$this->filtered_doc = $this->replace($this->complete_doc);
		}
		
		public function replace($string) {
			return preg_replace($this->getMatchinRegex(), $this->getReplaceRegex(), $string );
		}
		
		
		
		public function getHashTable() {
			return $this->hashtable;
		}
		
		public function getFilteredDocument() { return $this->filtered_doc; }
		public function getMatchinRegex() { return $this->regex_matchin; }
		public function getReplaceRegex() { return $this->regex_replace; }
		
		protected function setDocument($text) { $this->complete_doc = $text ; }
		
		protected function getAllMatchin() {
			$matchin = array();
			preg_match_all($this->getMatchinRegex(), $this->complete_doc, $matchin, PREG_OFFSET_CAPTURE );
			return $matchin;
		}
	}
?>
