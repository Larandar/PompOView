<?php
	
	class CorpusTools_SubCorpus {
		/* 
		 * Fonction SubCorpus
		 * @param  string jsonOrig : Chemin du fichier JSON a l'origine du corpus
		 * @param  array toErase : Liste des index de fichier a enlevé du json
		 * @return JSON Formated String
		 */
		public static function subCorpusJSON($jsonOrig, array $toErase) {
			$corpus = Json::decode($jsonOrig);
				
			$corpus_filename = (array)$corpus["filenames"];
			foreach($toErase as $key){
				unset($corpus_filename[$key]);
			}
			$corpus["filenames"] = array_values($corpus_filename);
				
			$corpus_scores = (array)$corpus["corpus_scores"];
			$corpus["corpus_scores"] = array();
			foreach($toErase as $key){
				unset($corpus_scores[$key]);
			}
				
			foreach($corpus_scores as $col){
				foreach($toErase as $key){
					unset($col[$key]);
				}
				$corpus["corpus_scores"][] = array_values($col);
			}
				
			return json_encode($corpus);
		}
	}
	
?>