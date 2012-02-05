<?php
	/**
	 * 
	 */
	class StyleSet_ColorHSL extends StyleSet {
		
		public static function genereStyle($I,$N) {
			$hsl = 'hsl('.(120*$I/($N-1)).',100,50)'    ;
			return "background-color:".$hsl.";"         ;
		}
		
		public static function errorStyle() {
			return "background-color:black; color:red;" ;
		}
	}
	
?>