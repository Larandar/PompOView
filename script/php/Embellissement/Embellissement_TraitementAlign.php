<?php
	/**
	 * 
	 */
	class Embellissement_TraitementAlign extends Embellissement_AbstractTraitement {
		
		public function applyTo($filename,$doc,$ali,$side) {
			$this->side = $side;
			
			
			foreach ($doc as $key => $value) {
				$curt = $ali[$key][0];
				
				$prev = $curt && ( !isset($ali[$key-1]) || !$ali[$key-1][0] || $ali[$key-1][1] != $ali[$key][1] );
				$suiv = $curt && ( !isset($ali[$key+1]) || !$ali[$key+1][0] || $ali[$key+1][1] != $ali[$key][1] );
				
				$prefix = ! $prev ? '' : sprintf( 
					'<div class="copycat" onclick="PompOView.UI.vars(\'%s\').align(%s,%d,%d)">', 
					$this->url, $this->side, $ali[$key][1], $ali[$key][2] 
				);
				$suffix = ! $suiv ? '' : '</div>';
				
				$value = sprintf("%s%s%s",$prefix,$value,$suffix);
				
				$doc[$key] = $value;
				
			}
			
			
			return $doc;
		}
		
	}
	
?>