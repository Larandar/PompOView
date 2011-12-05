<?
	// Demande une variable $SCRIPT_DIRECTORY
	// Fonction diverses 
	function array_moy($ar){return (float)(array_sum($ar)/count($ar));}
	function array_getdef($options, $param, $def = null){return ( isset($options[$param]) )?$options[$param]:$def ;}
	
	require_once($GLOBALS['SCRIPT_DIRECTORY'].'PHP/class/Coloration.php');
	
	class Pompoview{
		
		public $data = array();
		public $trace = array();
		public $corpus = array();
		
		public $col;
		public $lig;
		
		public $option;
		
		public $prof;
		public $color;
		
		public function __construct($options = array()){
			$this->setOptions($options);
		}
		
		function setOptions($options){
			$this->options['color'] = array_getdef($options,'color','ColorationEmb');
			$this->color            = new $this->options['color']();
			$this->prof             = array_getdef($options,'prof',3);
			
			$this->options = $options;
			
		}
		
		function fromJSON($filePath){
			require_once($GLOBALS['SCRIPT_DIRECTORY'].'PHP/utils/JSON.php');
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
		
		public function exportMatrix(){
			function segment($nb,$max,$min = 0){
				$ret = array($min);
				for($i=1;$i<$nb;$i++){
					$ret[] = $min + ($i+1) * ($max - $min) / $nb ;
				}
				return $ret;
			}
			print('<table>'.PHP_EOL);
			$header = '<tr><td style="text-align:center;">*</td>';
			foreach($this->corpus as $key => $value){
				$header .= sprintf('<td><abbr title="%s">%d</abbr></td>',$value,$key+1);
			}
			$header .= '</tr>'.PHP_EOL;
			print($header);
			foreach($this->data as $key => $subarray){
				$join = '<tr>';
				$join .= sprintf('<td><abbr title="%s">%d</abbr></td>',$this->corpus[$key],$key+1);
				foreach($subarray as $value){
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