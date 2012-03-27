<?php
	/**
	 * 
	 */
	class Embellissement_TraitementAlign extends Embellissement_AbstractTraitement {
		
		public function applyTo($filename,$doc,$ali) {
			
			foreach ($doc as $key => $value) {
				$curt = $ali[$key][0];
				
				$prev = $curt && ( !isset($ali[$key-1]) || !$ali[$key-1][0] || $ali[$key-1][1] != $ali[$key][1] );
				$suiv = $curt && ( !isset($ali[$key+1]) || !$ali[$key+1][0] || $ali[$key+1][1] != $ali[$key][1] );
				
				$prefix = ! $prev ? '' : sprintf( 
					'<div class="copycat" onclick="PompOView.UI.vars(\'%s\').align(%d)">', 
					$this->url, $ali[$key][1] 
				);
				$suffix = ! $suiv ? '' : sprintf(
					'<span class="info">G:%d</span></div>',
					$ali[$key][1]
				);
				
				$value = sprintf("%s%s%s",$prefix,$value,$suffix);
				
				$doc[$key] = $value;
				
			}
			
			
			return $doc;
		}
		
	}
	
?>