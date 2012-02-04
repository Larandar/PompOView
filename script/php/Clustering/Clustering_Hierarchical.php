<?php
	/* Requiert la classe Clustering, Clustering_Tree et ArrayTools_Matrix */
	
	/**
	 * Une classe de Clustering Hiérachique
	 */
	class Clustering_Hierarchical extends Clustering {
		
		public function generer( $matrix = False ) {
			
			if ( $matrix ) {
				$this->setData($matrix);
			} else {
				$matrix = $this->getData();
			}
			
			$toAsign = array();
			foreach ($matrix as $key => $value) {
				$toAsign[$key] = Clustering_Tree::leaf($key,$value,0);
			}
			
			$last  = 0;
			$level = 1;
			while (count($toAsign) > 1) {
				$_maxpos = ArrayTools_Matrix::whereIsMin($matrix);
				
				$pos_1  = $_maxpos[0];
				$child1 = $toAsign[$pos_1];
				$pos_2  = $_maxpos[1];
				$child2 = $toAsign[$pos_2];
				unset($toAsign[$pos_1],$toAsign[$pos_2]);
				
				$matrix = ArrayTools_Matrix::unsetIndice($matrix,$pos_1);
				$matrix = ArrayTools_Matrix::unsetIndice($matrix,$pos_2);
				
				$newnode  = Clustering_Tree::node($child1,$child2,$level);
				$nodename = $newnode->getName();
				
				$last = $nodename;
				
				$distof = array();
				foreach ($toAsign as $name => $othernode) {
					$distof[$name] = $this->useDist($newnode->getValue($name),$othernode->getValue($nodename));
				}
				
				foreach ($matrix as $name => $_) {
					$matrix[$nodename] = $distof[$name];
				}
				$matrix[$nodename] = $distof;
				
				$toAsign[$nodename] = $newnode;
				$level++;
			}
			
			$this->tree = $toAsign[$last];
		}
		
	}
	
?>