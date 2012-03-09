<?php
	/**
	 * Basic URL Interpreter
	 * Update and Credits @ https://github.com/Larandar/RoutingController
	 */
	class RoutingController_UrlInterpreter {
		
		protected $command;
		
		public function __construct() {
			$requestURI = explode("/",$_SERVER['REQUEST_URI']);
			$scriptName = explode("/",$_SERVER['SCRIPT_NAME']);
			
			for($i= 0;$i < sizeof($scriptName);$i++) {
				if ($requestURI[$i] == $scriptName[$i]) {
					unset($requestURI[$i]);
				}
			}
			$commandArray = array_values($requestURI);
			$commandName = $commandArray[0];
			$parameters = array_slice($commandArray,1);
			$this->command = new RoutingController_Command($commandArray[0],$parameters);
		}
		
		public function getCommand() { return $this->command; }
	}
	
?>