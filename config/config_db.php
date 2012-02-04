<?php
	// Configuration de la base de donnée
	
	define("DB_SERVER"     , "");
	define("DB_USER"       , "");
	define("DB_PASSWD"     , "");
	
	define("DB_NAME"       , "");
	
	
	define("DB_PORT"       , "3306");
	define("PDO_DSN"       , "mysql:host=" . DB_SERVER . ";port=" . DB_PORT . ";dbname=" . DB_NAME);
	
?>