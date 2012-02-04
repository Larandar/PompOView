<?php
	// La vue principale, 
	// Chaque action est une fonction qui retourne une chaine de caractère
	
	function index() {
		$return = "";
		$return .= file_get_contents(BASE_DIR."public/in/index-main.php");
		return $return;
	}
	
	// Le corps de la page est définie par la variable $main_content
	$titre        = "EnsWEB TP";
	$main_content = "	<!-- Main content -->".PHP_EOL;
	
	switch ($main_action) {
		case 'index':
			$tire = "EnsWeb";
			$main_content .= index();
			break;
			
		default:
			$main_content .= index();
			break;
	}
	
	// Finalement on inclus le squelette
	include "base.php" ;
?>