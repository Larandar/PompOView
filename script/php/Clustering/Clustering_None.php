<?php
	/* Requiert la classe Clustering au minimum */
	require_once "Clustering.php";
	
	/**
	 * Une classe de clustering qui ne fait rien du tout !
	 */
	class Clustering_None extends Clustering {
		
		public function generer($matrix=null) { ($matrix)?$this->setData($matrice):null; }
		public function getOrder() { return array_keys($this->data); }
		
	}
	
?>