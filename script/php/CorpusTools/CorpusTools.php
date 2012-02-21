<?php
	/**
	 * 
	 */
	class CorpusTools {
		
		public static function constructCorpus($filename) {
			$groups = CorpusTools::factorize($filename);
			
			$root = array_keys($groups);
			$root = $root[0];
			
			$groups = $groups[$root];
			
			foreach ($groups as $key => $group) {
				if (!is_array($group)) {
					// Il s'agit d'un document isolé a la racinne
					// On lui crée alors un groupe
					$name = explode(".", $group);
					$name = $name[0];
					
					unset($groups[$key]);
					$groups[$name] = array( $key => $group);
				}
			}
			
			return array(
				"root"   => $root,
				"groups" => $groups
			);
		}
		
		
		public static function factorize($corpus) {
			$groups = array();
			
			$corpus = array_map( function($a){return explode('/',$a);},
				$corpus);
			
			$groups = CorpusTools::computePath($corpus);
			$groups = CorpusTools::factorPaths($groups);
			$groups = CorpusTools::finalPath($groups);
			
			return $groups;
		}
		
		protected static function computepath($corpus) {
			if (!is_array($corpus)) { return $corpus; }
			elseif (count($corpus) == 1) {
				// Une unique valeur mais ou donc ?
					return array_pop($corpus);
				}
			
			$groups = array();
			
			foreach ($corpus as $value) {
				if (is_string($value) or !is_array($value)) {
					$groups[] = $value;
				} elseif (count($value) == 1) {
					// Une unique valeur mais ou donc ?
					$groups[] = array_pop($value);
				} else {
					$key = array_shift($value).DIRECTORY_SEPARATOR;
					$groups[$key][] = $value ;
				}
			}
			foreach ($groups as $key => $value) {
				$groups[$key] = CorpusTools::computePath($value);
			}
			
			
			return $groups;
		}
		
		protected static function factorPaths($corpus) {
			if (!is_array($corpus) or count($corpus) != 1) {
				return $corpus;
			} else {
				$root = "";
				
				do {
					$dir = array_keys($corpus);
					$root .= $dir[0];
					
					$corpus = $corpus[$dir[0]];
				} while(count($corpus) == 1);
				
				return array($root => $corpus);
			}
		}
		
		protected static function finalPath($corpus,$root = "") {
			foreach ($corpus as $key => $value) {
				if (is_array($value)) {
					$sroot = $root . $key;
					$corpus[$key] = CorpusTools::finalPath($value,$sroot);
				} else {
					unset($corpus[$key]);
					$corpus[$root.$value] = $value;
				}
			}
			return $corpus;
		}
	}
	
?>