<?
	// Fonction diverses 
	function array_moy($ar){return (float)(array_sum($ar)/count($ar));}
	function array_getdef($options, $param, $def = null){return ( isset($options[$param]) )?$options[$param]:$def ;}
	
	require_once('./PompOView_Corpus/Coloration.php');
	require_once('./PompOView_Corpus/Clustering.php');
	
	class PompOView_Corpus{
		
		public $data = array();
		public $trace = array();
		public $corpus = array();
		
		public $col;
		public $lig;
		
		public $option;
		
		public $color;
		public $prof;
		public $clustering;
		
		public function __construct($options = array()){
			$this->setOptions($options);
		}
		
		function setOptions($options){
			$this->options = array(
				'clustering'      => array_getdef($options,'clustering','HierarchicalClustering'),
				'clustering_dist' => array_getdef($options, 'clustering_dist','min'),
				'coloration'           => array_getdef($options,'coloration','ColorationEmb'),
				'coloration_prof'      => array_getdef($options,'coloration_prof',3)
			);
			
			$this->clustering_dist  = $this->options['clustering_dist'];
			$this->clustering       = new $this->options['clustering']($this->clustering_dist);
			
			
			$this->coloration_prof  = $this->options['coloration_prof'];
			$this->coloration       = new $this->options['coloration']($this->coloration_prof);
		}
		
		function fromJSON($filePath){
			require_once('./PompOView_Corpus/JSON.php');
			require_once('./PompOView_Corpus/Zend/Json.php');
			
			
			$out_json = file_get_contents($filePath);
			
			$out_json = JSON::serialize($out_json);
			
			$json = Zend_Json::decode($out_json);
			
			$this->data   = $json['corpus_scores'];
			$this->trace  = $json['signature'];
			$this->corpus = $json['filenames'];
			
			
			$this->genereColor();
		}
		
		public function genereColor()
		{
			$this->coloration->genereColor($this->data,$this->coloration_prof);
		}
		
		public function setHide($toHide)
		{
			$this->clustering->setHide($toHide);
		}
		
		public function traitement($value){
			return sprintf('<td style="background:%s;">%.3f</td>',$this->coloration->getColorOf($value),$value);
		}
		
		public function exportMatrix(){
			
			$this->clustering->generation($this->data);
			$order = $this->clustering->getOrder();
			
			print('<table>'.PHP_EOL);
			
			// Première ligne :: Header
			$header = '<tr><td style="text-align:center;">*</td>';
			foreach($order as $key){
				$value = $this->corpus[$key];
				$header .= sprintf('<td><abbr title="%s">%d</abbr></td>',$value,$key+1);
			}
			$header .= '</tr>'.PHP_EOL;
			print($header);
			
			foreach($order as $key){
				$subarray = $this->data[$key];
				
				$join = '<tr>';
				$join .= sprintf('<td><abbr title="%s">%d</abbr></td>',$this->corpus[$key],$key+1);
				
				foreach($order as $key){
					$value = $subarray[$key];
					$join .= $this->traitement($value);
				}
				$join .= '</tr>';
				print($join.PHP_EOL);
			};
			print('</table>'.PHP_EOL);
		}
		
		public function exportChart(){
			
		}
	};
?>