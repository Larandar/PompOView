<?php
	define( "DS"          , DIRECTORY_SEPARATOR );
	// Configuration général du serveur
	
	
	
	// Ajouter en fin de SERVER_URL le chemin a partir du serveur web
	$protocol = ( !isset($_SERVER['HTTPS']) ? "https" : "http" );
	define( "SERVER_URL"   , $protocol.'://'.$_SERVER["SERVER_NAME"].DS."PompOView/" );
	
	//
	define( "BASE_DIR"     , getcwd().DS );
	define( "LIBDIR_PHP"   , BASE_DIR."script/php/");
	define( "LIBDIR_AJAX"  , BASE_DIR."public/ajax/");
	
	define( "URL_AJAX"  , SERVER_URL."ajax/");
	define( "URL_CSS"   , SERVER_URL."public/css/");	
	define( "URL_IMG"   , SERVER_URL."public/img/");
	define( "URL_JS"    , SERVER_URL."script/js/");
	
	//
	define('DATA_URL', SERVER_URL . 'data/');
	define('DATA_DIR', BASE_DIR . 'data/');
	
	// Configuration de la Base de donnée
	require_once BASE_DIR."config/config_db.php";
	
	// Configuration de l'autoload
	require_once BASE_DIR."config/autoload.php";
	
?>