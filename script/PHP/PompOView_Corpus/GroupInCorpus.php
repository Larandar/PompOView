<?
	/**
	 * GroupInCorpus est un package qui permet de détecter et isoler les groupes de documents dans une arborescence
	 * La fonction principale est "computeGroupIn" qui prend en argument une liste de chemin de fichiers et retourne
	 * une arborescence d'array où les chaine finale est le nom de fichier et sa clef associative est son chemin dans
	 * le corpus étudié.
	 * @package GroupInCorpus
	 * @author Adrien Dudouit-Exposito
	 */
	class GroupInCorpus
	{
		/**
		 * computeGroupIn
		 * 
		 * @param Array corpus : une liste de document représentant un corpus
		 * @return Array
		 * @author Adrien Dudouit-Exposito
		 **/
		
		public static function computeGroupIn($corpus){
			$corpus = (array) GroupInCorpus::treePath($corpus);
			$corpus = GroupInCorpus::corpusFactorize($corpus);
			$corpus = GroupInCorpus::computePath($corpus);
			return $corpus;
		}
		
		public static function treePath($corpus){
			$treeCorpus = array();
			
			if (!is_array($corpus)) {
				return $corpus;
			}
			
			foreach ($corpus as $key => $value) {
				if ($value === "") {
					unset($corpus[$key]);
				} elseif (!preg_match("[/]",$value)) {
					$treeCorpus[] = $value;
					unset($corpus[$key]);
				}
				
			}
			
			foreach( $corpus as $file ) {
				$file = explode( "/", $file );
				$key = array_shift($file);
				$treeCorpus[$key."/"][] = join($file,"/");
			}
			
			$treeCorpus = array_map('GroupInCorpus::treePath', $treeCorpus);
			
			return $treeCorpus;
		}
		
		public static function corpusFactorize($corpus){
			if (count($corpus) != 1) {
				return $corpus;
			}
			
			$root = array_keys($corpus);
			$root = $root[0];
			
			$corpus = $corpus[$root];
			
			while ( is_array($corpus) and count($corpus) == 1 ) {
				$dir = array_keys($corpus);
				$dir = $dir[0];
				
				// Si la clef n'est pas un dossier alors on arrètes (n'est pas terminé par un "/")
				if ( !preg_match("[/]",$dir) )
					break;
				
				$root .= $dir;
				$corpus = $corpus[$dir];
			}
			return array($root => $corpus);
		}
		
		public static function computePath($corpus,$root = "") {
			foreach ($corpus as $key => $value) {
				if ((bool)preg_match("[/]",$key) and is_array($value)) {
					$sroot = $root . $key;
					$corpus[$key] = GroupInCorpus::computePath($value,$sroot);
				} else {
					unset($corpus[$key]);
					$corpus[$root.$value] = $value;
				}
				
			}
			return $corpus;
		}
	}
