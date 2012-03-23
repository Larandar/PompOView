<?php
	/**
	 * 
	 */
	class POVDiff_HtmlUI {
		
		public static function makeDiff(POVDiff $povdiff, $currenturl, $currentid) {
			$html = '<table style="">';
			
			$html .= '<td class="align-left"  id="'.$currentid.'-alignleft">';
			$html .= $povdiff->getDoc1();
			$html .= '</td>';
			
			$html .= '<td class="align-right" id="'.$currentid.'-alignright">';
			$html .= $povdiff->getDoc2();
			$html .= '</td>';
			$html .= "</table>";
			return $html;
		}
	}
	
?>