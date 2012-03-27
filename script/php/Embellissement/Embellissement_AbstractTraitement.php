<?php
	/**
	 * 
	 */
	abstract class Embellissement_AbstractTraitement {
		protected $url;
		protected $side = "left";
		
		public function __construct($url,$id) {
			$this->url = $url;
			$this->id = $id;
		}
		
		abstract public function applyTo($filename,$doc,$ali,$side);
	}
?>