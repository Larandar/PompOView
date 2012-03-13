<?php
	// Conguration du serveur
	require_once "config/config.php";
	
	$route = new RoutingController();
	
	switch ( $route->command->getName() ) {
		// >> Règles basiques >>
		case "pompoview":
			include BASE_DIR."public/master.php";
			break;
			
		case "error":
			$_ERROR = array( "code" => $route->command->arg(0), "source" => $route->command->join('/',2) );
			include( BASE_DIR."public/error.php" );
			break;
			
		case "ajax":
			include_once LIBDIR_AJAX.$route->command->join('/',1);
			exit(0); break; // << On est jamais trop prudent
		
		case "__dev":
			include_once SERVEUR_URL.$route->command->join('/');
			break;
		
		// >> Règles de redirections >>
		
		case "":
			header("Location: ".SERVER_URL."pompoview/");
			break;
			
		default:
			header("Location: ".SERVER_URL."error/404/".$route->command->join('/'));
			break;
	}
	
?>
