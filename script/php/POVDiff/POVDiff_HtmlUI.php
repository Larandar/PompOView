<?php
	/**
	 * 
	 */
	class POVDiff_HtmlUI {
		
		public static function makeDiff(POVDiff $povdiff, $curl, $cid) {
			$html = '<div class="diff-code">';
			
			$povdiff->computeDocs($curl);
			
			$html .= '<div class="align-left"  id="'.$cid.'-alignleft">';
			$html .= $povdiff->getDoc1();
			$html .= '</div>';
			
			$html .= '<div class="align-right" id="'.$cid.'-alignright">';
			$html .= $povdiff->getDoc2();
			$html .= '</div>';
			
			$html .= "</div>";
			return $html;
		}
	}
	
?>