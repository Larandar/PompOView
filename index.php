<?php
	// Conguration du serveur
	require_once "config/config.php";
	
	if (isset($_GET["main"])) {
		$main_action = $_GET["main"];
	} else {
		$main_action = "index";
	}
	
	include "public/main.php"
?>