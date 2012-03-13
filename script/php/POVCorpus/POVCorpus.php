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
			
			
			if ($options) {
				$options = array_merge(self::getDefaultsOptions(),$options);
			} else {
				$options = self::getDefaultsOptions();
			}
			
			$this->setClustering($options["clustering"],$options["clustering_dist"]);
			$this->setStyleSet($options["styleset"],$options["styleset_parti"],$options["styleset_param"]);
			$this->setUI($options["povcorpus_ui"]);
			
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
		public function makeTable() {
			return $this->povc_ui->makeTable($this);
		}
		public function makeCorpusContent() {
			return $this->povc_ui->makeCorpusContent($this);
		}
		public function makeCorpusStats() {
			return $this->povc_ui->makeCorpusStats($this);
		}
		public function makePOVCorpusForm() {
			return $this->povc_ui->makePOVCorpusForm($this);
		}
		
		public function getClustering() { return $this->cluste; }
		public function getStyleSet() { return $this->styles; }
		
		public function getData() { return $this->corpus->getScores(); }
		public function getDataList() { return $this->data_list ; }
		
		public function getFilenames() { return $this->corpus->getFilenames(); }
		
		public static function getDefaultsOptions() {
			if (is_file(DATA_DIR."POVCorpus_Options.json")) {
				$json = Json_Clear::clear(file_get_contents(DATA_DIR."POVCorpus_Options.json"));
				return Zend_Json::decode($json);
			} else {
				file_put_contents(DATA_DIR."POVCorpus_Options.json",'{
	"clustering"      : "Clustering_Hierarchical",
	"clustering_dist" : "Distance::min",
	"povcorpus_ui"    : "POVCorpus_HtmlUI",
	"styleset"        : "StyleSet_ColorHSL",
	"styleset_param"  : null,
	"styleset_parti"  : "Partitionneur_EntangledKMeans"
}');
				return self::getDefaultsOptions();
			}
		}
		
	}
	
?>