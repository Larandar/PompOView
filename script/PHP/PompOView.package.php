<?
	// Demande une variable $SCRIPT_DIRECTORY
	// Fonction diverses 
	function array_moy($ar){return (float)(array_sum($ar)/count($ar));}
	function array_getdef($options, $param, $def = null){return ( isset($options[$param]) )?$options[$param]:$def ;}
	
	require_once($GLOBALS['SCRIPT_DIRECTORY'].'PHP/Coloration.class.php');
	
	class Pompoview{
		
		public $data = array();
		public $trace = array();
		public $corpus = array();
		
		public $col;
		public $lig;
		
		public $option;
		
		public $prof = 3;
		public $color;
		
		public function __construct($options = array()){
			$this->color = new Coloration();
			$this->setOptions($options);
		}
		
		function setOptions($options){
			$this->options = $options;
		}
		
		function fromJSON($filePath){
			require_once($GLOBALS['SCRIPT_DIRECTORY'].'PHP/JSON.utils.php');
			require_once($GLOBALS['SCRIPT_DIRECTORY'].'PHP/Zend/Json.php');
			
			
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
			$this->color->genereColor($this->data,$this->prof);
		}
		
		public function traitement($value){
			return sprintf('<td style="background:%s;">%.3f</td>',$this->color->getColorOf($value),$value);
		}
		
		public function export(){
			function segment($nb,$max,$min = 0){
				$ret = array($min);
				for($i=1;$i<$nb;$i++){
					$ret[] = $min + ($i+1) * ($max - $min) / $nb ;
				}
				return $ret;
			}
			print('<table>'.PHP_EOL);
			foreach($this->data as $key => $subarray){
				$join = '<tr>';
				foreach($subarray as $value){
					$join .= $this->traitement($value);
				}
				$join .= '</tr>';
				print($join.PHP_EOL);
			};
			print('</table>'.PHP_EOL);
		}
		
		function exportAll(){
			print_r($this->trace);
			print_r($this->corpus);
			print_r($this->data);
		}
	};
?>