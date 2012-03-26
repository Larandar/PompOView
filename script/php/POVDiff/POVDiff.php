<?php
	/**
	 * 
	 */
	class POVDiff {
		
		protected $corpus;
		protected $doc1;
		protected $doc2;
		
		protected $alignement;
		
		protected $embellisement;
		
		function __construct(Corpus $corpus, $id1, $id2, $options = false) {
			
			$this->corpus = $corpus;
			
			$this->id1 = $id1;
			$this->id2 = $id2;
			
			$this->doc1   = $corpus->getFileByID($id1);
			$this->doc2   = $corpus->getFileByID($id2);
			
			if ($options) {
				$options = array_merge(self::getDefaultsOptions(),$options);
			} else {
				$options = self::getDefaultsOptions();
			}
			
			$this->options = $options;
			
			
			$factory = new FiltrageDoc_Factory($corpus->getSignature("documentFilter"),$corpus->getSignature("segmenter"));
			
			$this->doc1 = $factory->make($this->doc1);
			$this->doc2 = $factory->make($this->doc2);
			
			
			$log = $corpus->getLogNameByID($id1,$id2);
			$cseg1 = count($this->doc1);
			$cseg2 = count($this->doc2);
			
			$this->alignement = new Aligneur($log,$cseg1,$cseg2);
			$this->povdiffui = new POVDiff_HtmlUI();
		}
		
		public function computeDocs($curl) {
			$this->embellisement = new Embellissement($this->options["traitement"],$curl);
			
			$this->filename1 = $this->corpus->getFileName($this->id1);
			$this->filename2 = $this->corpus->getFileName($this->id2);
			
			$this->doc1 = $this->embellisement->make($this->filename1, $this->doc1, $this->alignement->getRelation1(),"left");
			$this->doc2 = $this->embellisement->make($this->filename2, $this->doc2, $this->alignement->getRelation2(),"right");
			
		}
		
		
		public function makeDiff( $curl,$cid ) {
			return $this->povdiffui->makeDiff($this,$curl,$cid);
		}
		
		public function getDoc1() { return $this->doc1; }
		public function getDoc2() { return $this->doc2; }
		
		
		public static function getDefaultsOptions() {
			if (@is_file(DATA_DIR."POVDiff_Options.json")) {
				return Json::decode(DATA_DIR."POVDiff_Options.json");
			} else {
				file_put_contents(DATA_DIR."POVDiff_Options.json",'{
	"traitement" : ["ColorationSyntaxique","..."]
}');
				return self::getDefaultsOptions();
			}
		}
	}

?>
