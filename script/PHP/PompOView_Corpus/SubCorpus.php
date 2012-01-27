<?php
	// Fonctions Incternes
	function file_set($file,$content){
		$file = fopen($file,'w');
		$rez = fputs($file,$content);
		fclose($file);
		return $rez;
	}
	
	
	/* 
	 * Fonction SubCorpus
	 * @param  string jsonOrig : Chemin du fichier JSON a l'origine du corpus
	 * @param  array toErase : Liste des index de fichier a enlevé du json
	 * @return JSON Formated String
	 */
	function subCorpusJSON($jsonOrig, array $toErase)
	{
		require_once("JSON.php");
		$json = JSON::serialize(file_get_contents($jsonOrig));
		$corpus = (array)json_decode($json);
		
		// CHANGED Supression des noms de fichier qui ne sont pas dans le sous-corpus
		$corpus_filename = (array)$corpus["filenames"];
		foreach($toErase as $key){
			unset($corpus_filename[$key]);
		}
		$corpus["filenames"] = array_values($corpus_filename);
		
		// CHANGED Supressions des lignes et colonnes qui n'apartiennent pas au sous-corpus
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

