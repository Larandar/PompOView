<?php
	//
	/**
	 * 
	 */
	class POV_HtmlUI {
		
		public static function getCloseButton($url,$id) {
			$button = '<button class="ui-close-button" ';
			$button .='onclick="PompOView.UI.closeTab('."'".$url."','".$id."'".')"';
			$button .='>Fermer</button>';
			return $button;
		}
		
	}
	
?>