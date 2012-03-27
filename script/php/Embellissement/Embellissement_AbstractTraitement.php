<?php
	/**
	 * 
	 */
	abstract class Embellissement_AbstractTraitement {
		protected $url;
		protected $side = "left";
		
		public function __construct($url) {
			$this->url = $url;
		}
		
		abstract public function applyTo($filename,$doc,$ali);
	}
?>