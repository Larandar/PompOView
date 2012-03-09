<?php
	/**
	 * Basic Routing Controller that get the command
	 * Update and CreUpdate and Creditsdits @ https://github.com/Larandar/RoutingController
	 */
	class RoutingController {
		
		public $command;
		
		function __construct() {
			$url = new RoutingController_UrlInterpreter();
			$this->command = $url->getCommand();
		}
	}
	
?>