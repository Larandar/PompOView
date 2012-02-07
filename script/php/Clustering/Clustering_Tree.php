<?php
	/**
	 * Clustering_Tree est une factory pour Clustering_Node et Clustering_Lead
	 */
	class Clustering_Tree {
		public static function node($child1,$child2,$level) {
			return new Clustering_Node($child1,$child2,$level);
		}
		public static function leaf($name,$value,$level) {
			return new Clustering_Leaf($name,$value,$level);
		}
	}
	
	/**
	 * Les classe qui représente les donnée de clustering
	 */
	class Clustering_Leaf {
		
		protected $_name ;
		protected $_level;
		protected $_value;
		
		public function __construct( $name, $value, $level = NULL ) {
			$this->_name  = $name;
			$this->_level = $level;
			
			unset($value[$name]);
			$this->_value = $value;
		}
		
		public function getOrder() {
			return (array) $this->_name;
		}
		public function getValue($in) {
			$return = array();
			foreach ($in as $val) {
				if (array_key_exists($val, $this->_value)) {
					$return[] = $this->_value[$val];
			$in = explode(':',$in);
				}
			}
			return $return;
		}
		
		public function toArray() { return $this->_name; }
		
		public function getName()  { return $this->_name; }
		public function getLevel() { return $this->_level; }
	}
	
	class Clustering_Node extends Clustering_Leaf {
		
		protected $_child1;
		protected $_child2;
		
		public function __construct( $child1, $child2, $level = NULL ) {
			$this->_level = $level;
			$this->_child1 = $child1;
			$this->_child2 = $child2;
			$this->_name = join($this->getOrder(),":");
		}
		
		public function getOrder() {
			if ( $this->_child1->getLevel() <= $this->_child2->getLevel()) {
				return array_merge($this->_child1->getOrder(),$this->_child2->getOrder());
			} else {
				return array_merge($this->_child2->getOrder(),$this->_child1->getOrder());
			}
		}
		
		public function getValue($name) {
			return array_merge($this->_child1->getValue($name),$this->_child2->getValue($name));
		}
		
		public function toArray() { return array($this->_child1->toArray(),$this->_child2->toArray()); }
		
		public function getChild1() { return $this->_child1; }
		public function getChild2() { return $this->_child2; }
	}
?>