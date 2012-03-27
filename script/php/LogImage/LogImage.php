<?php
	/**
	 * LogImage Class
	 * Un "Magic Wrapper" pour les image de log du Pomp-o-metre
	 * 
	 * @package PompOView/LogImage
	 * @author Adrien Dudouit-Exposito
	 */
	class LogImage {
		
		protected $image;
		protected $info = array();
		
		public function __construct($name, $sizex = false, $sizey = false) {
			
			$this->image = @imagecreatefrompng($name);
			
			if ( !$this->image ) {
				print("LogImage '$name' not loaded");
				throw new LogImageException("LogImage '$name' not loaded");
			}
			
			$this->info = getimagesize($name);
			
			$sizex = $sizex ? $sizex : $this->info[0];
			$sizex = $sizex ? $sizex : $this->info[0];
			
			if ($this->info[0] != $sizex) {
				$this->order = false;
				$this->size  = array("x"=>$sizey,"y"=>$sizex);
			} else {
				$this->order = true;
				$this->size  = array("x"=>$sizex,"y"=>$sizey);
			}
			
			print_r($this->size);
		}
		
		public function getValue($x,$y) {
			$nx = $this->order ? $x : $y;
			$ny = $this->order ? $y : $x;
			
			if ($nx > $this->size["x"] || $ny > $this->size["y"]) {
				printf("%d x %d hors limite (%d x %d)", $nx, $ny, $this->size["x"] , $this->size["y"] );
			}
			
			return (bool) imagecolorat($this->image, $nx, $ny);
		}
		
		
		public function printImage() {
			header("Content-type: image/png");
			imagepng($this->image);
		}
		
		public function __destruct() {
			imagedestroy($this->image);
		}
		
	}
	
	/**
	 * LogImage Exception class
	 * Rien de particulier.
	 * 
	 * @package PompOView/LogImage
	 * @author Adrien Dudouit-Exposito
	 */
	class LogImageException extends Exception {
		
	}
	
	
?>