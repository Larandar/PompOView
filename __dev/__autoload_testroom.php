<?php
	function __autoload($name){
		
		// Modèle personnel soit : PHP_LIBDIR/ Package/ClassName.php avec ClassName ~ Package_*
		//                  soit : PHP_LIBDIR/ ClassName.php
		$classdir = explode('_',$name);
		
		$simplefile  = $classdir[0].'/'.$name.'.php';
		$complexfile = '../script/php/'.$classdir[0].'/'.$name.'.php';
		
		$zendfile = '../script/php/'.join($classdir, DIRECTORY_SEPARATOR).DIRECTORY_SEPARATOR.join($classdir, "_").'.php';
		
		if ( is_file($simplefile) ) {
			require_once $simplefile ;
		} elseif ( is_file($complexfile) ) {
			require_once $complexfile ;
		} elseif ( is_file($zendfile)) {
			require_once $zendfile;
		} else {
			$exception = 'Erreur Autoload : la classe "'. $name .'" n\'a pas été trouver. Cherché en ["'. $simplefile.'","'. $complexfile.'","'. $zendfile.'"].';
			throw new Exception($exception);
		}
	}
?>