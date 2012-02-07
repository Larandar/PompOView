<?php
	/**
	 * 
	 */
	class StyleSet_ColorHSL extends StyleSet {
		
		public static function genereStyle($I,$N) {
			$col = floor( (120*$I/($N-1)) );
			$hsl = 'hsl('.$col.',100%,50%)';
			return "background-color:".$hsl.";";
		}
		
		public static function errorStyle() {
			return "background-color:black; color:red;" ;
		}
	}
	
?>