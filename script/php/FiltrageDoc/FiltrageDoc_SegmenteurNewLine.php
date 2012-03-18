<?php
	/**
	 * 
	 */
	class FiltrageDoc_SegmenteurNewLine extends FiltrageDoc_AbstractSegmenteur {
		
		protected $param_regex = "/(([^\n]*\n){%s})/";
		
	}
	
?>