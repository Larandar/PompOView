<?
	// Fonction diverses 
	function array_moy($ar){return (float)(array_sum($ar)/count($ar));}
	function array_getdef($options, $param, $def = null){return ( isset($options[$param]) )?$options[$param]:$def ;}
	function println($el){print($el.PHP_EOL);};
	
	class Pompoview{
		
		var $data = array();
		var $trace = array();
		var $corpus = array();
		
		var $col;
		var $lig;
		
		var $option;
		
		public function __construct($options = array()){
			$this->setOptions($options);
		}
		
		function setOptions($options){
			$this->options = $options;
		}
		
		function fromJSON($filePath){
			$out_json = (array)json_decode(file_get_contents($filePath));
			$this->data = (array)$out_json['corpus_scores'];
			$this->trace = (array)$out_json['signature'];
			$this->corpus = (array)$out_json['filenames'];
		}
		
		function export(){
			function segment($nb,$max,$min = 0){
				$ret = array($min);
				for($i=1;$i<$nb;$i++){
					$ret[] = $min + ($i+1) * ($max - $min) / $nb ;
				}
				return $ret;
			}
			function couleur($el,$pas = 4){
				$segments = segment($pas,120,0);
				return sprintf('hsl(%d,100%%,50%%)',$segments[round($el*$pas)-1]);
			}
			function traitement($el){
				return '<td style="background:'.couleur($el,4).';">'.sprintf('%.3f',$el).'</td>';
			}
			println('<table>');
			foreach($this->data as $key => $subarray){
				println( '<tr>'.join(array_map('traitement',$subarray)).'</tr>' );
			};
			println('</table>');
		}
		function exportAll(){
			print_r($this->trace);
			print_r($this->corpus);
			print_r($this->data);
		}
	};
?>