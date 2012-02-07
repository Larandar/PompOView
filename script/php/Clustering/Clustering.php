<?php
	/**
	 * Package : Clustering
	 * Auteurs : Adrien "Larandar" Dudouit-Exposito
	 * Utilisation 
	 */
	
	/**
	 * 
	 */
	abstract class Clustering {
		
		protected $data;
		protected $tree;
		protected $dist;
		
		/* Constructeur unique pour toutes les classes sauf cas exeptionnels */
		public function __construct($data,$dist = "Distance::min") {
			$this->data = $data;
			$this->dist = $dist;
		}
		
		/* Fonction principale de la classe dérivé */
		abstract public function generer($matrice);
		
		/* Pour obtenir l'ordre obtenu aprés clustering on décompose l'arbre en suivant le niveaux de fusion */
		public function getOrder() { 
			if (!$this->tree) { $this->generer() ; }
			return $this->tree->getOrder();
		}
		
		/* Accesseurs et mutateurs */
		public function useDist( $node1, $node2 ) { return call_user_func($this->dist,$node1,$node2); }
		public function getDist() { return $this->dist; }
		public function setDist($dist) { $this->dist = $dist; $this->tree = false;}
		
		public function getData() { return $this->data; }
		public function setData($data) { $this->data = $data ; $this->tree = false; }
		
		public function getTree() { return $this->tree ; }
	}
	
?>