<?php
	/**
	 * Basic Controller Command
	 * Update and Credits @ https://github.com/Larandar/RoutingController
	 */
	class RoutingController_Command {
		
		protected $name;
		protected $args;
		
		public function __construct($name,$args) {
			$this->name = $name;
			$this->args = $args;
			
			$this->preventGET();
		}
		
		public function preventGET() {
			$falseurl = "http://anyhost.net/";
			$falseurl .= $this->join('/');
			$getarray = array();
			parse_str( parse_url($falseurl,PHP_URL_QUERY), $getarray) ;
			$_REQUEST = array_merge($_REQUEST,$getarray);
			
			foreach ($this->args as $key => $value) {
				$s = explode("?", $value);
				$this->args[$key] = $s[0];
			}
		}
		
		public function join($g,$o=0) { 
			$args = array_merge(array($this->name),$this->args);
			return join(array_slice($args,$o),$g);
		}
		public function arg($v) { return $this->args[$v]; }
		public function getName() { return $this->name; }
		public function getArgs() { return $this->args; }
	}
	

?>
