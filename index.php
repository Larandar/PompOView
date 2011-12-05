<? 
	// Index.php -> Controleur du site
	
	$GLOBALS['INDEX_DIR'] = getcwd().'/';
	$GLOBALS["SCRIPT_DIR"] = getcwd().'/'.'script/';
	
	// On charge les option => conf.ini
	include_once('script/php/get_options.module.php');
	// Récupération des paramètres
	include_once('script/php/get_param.module.php');
	
	// En fonction des paramètre on affiche le bon élément
	$cond1 = in_array( $param['page'], array('index','tarifs','classique','contemporain','design','capucine','contact','linattendu','honfleur') );
	$cond2 = in_array( $param['lang'],array('fr') );
	if( $cond1 and $cond2 ){
		// Récupère la vue pour les page conserné
		include_once('vue/vitrine.php');
	}
	else {
		// Ou renvoie une erreur 404 dans le cas d'une non cohérence
		header("Status: 404 Not Found");
		header("Location: 404.html");
	}