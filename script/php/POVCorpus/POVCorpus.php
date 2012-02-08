<?php
	/**
	 * 
	 */
	class POVCorpus {
		/**
		 * Données primaires
		 */
		protected $corpus;
		
		protected $cluste;
		protected $cluste_dist  = "Distance::min";
		
		protected $styles;
		protected $styles_parti = "Partitionneur_Linear";
		protected $styles_param = null;
		
		protected $povc_ui;
		
		/**
		 * Données dérivés
		 */
		protected $data;
		protected $data_list;
		
		protected $filenames;
		protected $subproject;
		
		public function __construct() {
			$this->cluste = new Clustering_Hierarchical(null,$this->cluste_dist);
			$this->styles = new StyleSet_ColorHSL($this->styles_parti);
			$this->povc_ui = new POVCorpus_HtmlUI();
		}
		
		public function fromJSON($name) {
			if (is_file($name)) {
				$json = file_get_contents($name);
				$json = Json_Clear::clear($json);
				$json = Zend_Json::decode($json);
				
				$this->corpus = $json;
				$this->data = $json['corpus_scores'];
				
				$this->cluste->setData($this->data);
				
				$data_list = ArrayTools_Matrix::triangularValues($json['corpus_scores']);
				$this->data_list = $data_list;
				$this->styles->setData($data_list,$this->styles_param);
				
				$this->filenames = $json['filenames'];
			} else {
				throw new Exception('File "'.$name.'" does not exist !!');
			}
		}
		
		public function setClustering($cluste_name, $cluste_dist = null) {
			$this->cluste_dist = (is_null($cluste_dist))?$this->cluste_dist:$cluste_dist;
			$this->cluste = new $cluste_name($this->data,$this->cluste_dist);
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
		
		public function getData() { return $this->data; }
		public function getDataList() { return $this->data_list ; }
		
		public function getFilenames() { return $this->filenames; }
		public function getSubProject() { return $this->subproject; }
		
	}
	
?>