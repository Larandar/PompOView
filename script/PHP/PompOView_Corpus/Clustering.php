<?php
	/* Fonctions de fusion des lignes:
	 * déja disponible : 'min' 'max'
	 * potentiellement toute fonction de R2 -> R (Des test sur 'pow' on été effectuer... pas trés concluant)
	 * Ajouté ici : 'med' x,y -> x+y/2, 'add' x,y -> x+y, 'dif' x,y -> abs(x-y)
	 */
	function med($x,$y){
		return ($x+$y)/2;
	}
	
	require_once('Clustering/ClusteringTree.php');
	
	include_once('Clustering/NullClustering.php');
	include_once('Clustering/HierarchicalClustering.php');
	
	/**
	* 
	*/
	abstract class Clustering
	{
		
		
		public $data = array(array());
		public $order = array();
		public $hide = array();
		
		
		public $dist;
		
		
		public function __construct($dist = 'min'){
			$this->dist = $dist;
		}
		
		public static function clusteringMatrix($matrice){
			$retour = array();
			foreach($matrice as $key => $sub){
				$sretour = array();
				foreach($sub as $skey => $val){
					$sretour[(string)$skey] = $val;
				}
				$retour[(string)$key] = $sretour;
			}
			return $retour;
		}
		
		public static function fusionLigne($matrice, $l1, $l2, $call = 'min'){
			$ligne1 = $matrice[$l1];
			$ligne2 = $matrice[$l2];
			$ligneret = array();
			foreach($ligne1 as $key => $value){
				$ligneret[$key] = $call($ligne1[$key],$ligne2[$key]);
			}
			unset($matrice[$l1],$matrice[$l2]);
			$matrice[$l1.':'.$l2] = $ligneret;
			
			foreach($matrice as $key => $array){
				$matrice[$key][$l1.':'.$l2] = $call($array[$l1],$array[$l2]);
				unset($matrice[$key][$l1],$matrice[$key][$l2]);
			}
			return $matrice;
		}
		
		public function setData($data)
		{
			$this->data = $this->clusteringMatrix($data);
			$this->data_back = $this->data;
		}
		
		public function toShow($show){
			$toHide = array();
			foreach($this->order as $ind){
				if(!in_array($ind,$show)){
					$toHide[] = $ind;
				}
			}
			$this->setHide($toHide);
		}
		
		public function setHide($hide){
			$this->hide = (array) $hide;
		}
		public function getOrder(){
			$order = $this->order;
			foreach($this->hide as $val){
				$ind = array_search($val,$order);
				if($ind !== FALSE){
					unset($order[$ind]);
				}
			}
			return $order;
		}
	}