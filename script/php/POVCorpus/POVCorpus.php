<?php
	/**
	 * 
	 */
	class POVCorpus {
		/**
		 * Données primaires
		 */
		public $corpus;
		
		protected $cluste;
		protected $cluste_dist;
		
		protected $styles;
		protected $styles_parti;
		protected $styles_param;
		
		protected $povc_ui;
		
		/**
		 * Données dérivés
		 */
		protected $data_list;
		
		public function __construct(Corpus $corpus, $options = false) {
			
			$this->corpus = $corpus;
			$this->corpus->setParent($this);
			
			if ($options) {
				$options = array_merge(self::getDefaultsOptions(),$options);
			} else {
				$options = self::getDefaultsOptions();
			}
			
			$this->setClustering($options["clustering"],$options["clustering_dist"]);
			$this->setStyleSet($options["styleset"],$options["styleset_parti"],$options["styleset_param"]);
			$this->setUI($options["povcorpus_ui"]);
			
			$this->group = $options['groups'];
			if ($this->group === "true") {
				$this->corpus->emuleProjet($this->group);
			}
			
			$this->reloadCorpus();
			
		}
		
		public function setCorpus($corpus) {
			$this->corpus = $corpus;
			$this->reloadCorpus();
		}
		public function reloadCorpus() {
			
			$this->cluste->setData($this->getData());
			
			$data_list = ArrayTools_Matrix::triangularValues($this->getData());
			$this->data_list = $data_list;
			$this->styles->setData($data_list,$this->styles_param);
		}
		
		public function setClustering($cluste_name, $cluste_dist = null) {
			$this->cluste_dist = (is_null($cluste_dist))?$this->cluste_dist:$cluste_dist;
			$this->cluste = new $cluste_name($this->getData(),$this->cluste_dist);
		}
		
		public function setStyleSet($styles,$styles_parti = null,$styles_param = null) {
			$this->styles_parti = ( is_null($styles_parti) ? $this->styles_parti : $styles_parti );
			$this->styles_param = ( is_null($styles_param) ? $this->styles_param : $styles_param );
			
			$this->styles = new $styles($this->styles_parti,$this->data_list,$this->styles_param);
		}
		
		public function setUI($ui_name) {
			$this->povc_ui = new $ui_name();
		}
		public function makeTable($curl,$cid) {
			return $this->povc_ui->makeTable($this,$curl,$cid);
		}
		public function makeCorpusContent($curl,$cid) {
			return $this->povc_ui->makeCorpusContent($this,$curl,$cid);
		}
		public function makeCorpusStats($curl,$cid) {
			return $this->povc_ui->makeCorpusStats($this,$curl,$cid);
		}
		public function makePOVCorpusForm($curl,$cid) {
			return $this->povc_ui->makePOVCorpusForm($this,$curl,$cid);
		}
		
		public function getClustering() { return $this->cluste; }
		public function getStyleSet() { return $this->styles; }
		
		public function getData() { return $this->corpus->getScores(); }
		public function getDataList() { return $this->data_list ; }
		
		public function getFilenames() { return $this->corpus->getFilenames(); }
		
		public static function getDefaultsOptions() {
			if (@is_file(DATA_DIR."POVCorpus_Options.json")) {
				return Json::decode(DATA_DIR."POVCorpus_Options.json");
			} else {
				file_put_contents(DATA_DIR."POVCorpus_Options.json",'{
	"clustering"      : "Clustering_Hierarchical",
	"clustering_dist" : "Distance::min",
	"povcorpus_ui"    : "POVCorpus_HtmlUI",
	"styleset"        : "StyleSet_ColorHSL",
	"styleset_param"  : null,
	"styleset_parti"  : "Partitionneur_EntangledKMeans",
	"groups"          : "false"
}');
				return self::getDefaultsOptions();
			}
		}
		
	}
	
?>