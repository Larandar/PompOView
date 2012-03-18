<?php
	/**
	 * 
	 */
	class FiltrageDoc_SegmenteurFixedChar extends FiltrageDoc_AbstractSegmenteur {
		
		protected $param_regex = "/(.{%s})/s"; // La feinte : . ne match pas \n
		
	}
	
?>
