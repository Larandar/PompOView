<?php
	// Redéfinition de l'autoload PHP
	
	function __autoload($name){
		
		// Modèle personnel soit : PHP_LIBDIR/ Package/ClassName.php avec ClassName ~ Package_*
		//                  soit : PHP_LIBDIR/ ClassName.php
		$simplefile  = LIBDIR_PHP.$name.'.php';
		
		$classdir = explode('_',$name);
		$complexfile = LIBDIR_PHP.$classdir[0].'/'.$name.'.php';
		
		if ( is_file($simplefile) ) {
			require_once $simplefile ;
		} elseif ( is_file($complexfile) ) {
			require_once $complexfile ;
		} else {
			$exception = 'Erreur Autoload : la classe "'. $name .'" n\'a pas été trouver. Cherché en ["'.$simplefile.'","'.$complexfile.'"].';
			throw new Exception($exception);
		}
	}
	
?>