<?php
	/**
	 * 
	 */
	class POVDiff {
		
		function __construct(Corpus $corpus, $id1, $id2, $options = false) {
			
			$this->corpus = $corpus;
			$this->doc1   = $corpus->getFileByID($id1);
			$this->doc2   = $corpus->getFileByID($id2);
			
			if ($options) {
				$options = array_merge(self::getDefaultsOptions(),$options);
			} else {
				$options = self::getDefaultsOptions();
			}
			
			
		}
		
		public static function getDefaultsOptions() {
			if (is_file(DATA_DIR."POVDiff_Options.json")) {
				return Json::decode(DATA_DIR."POVDiff_Options.json");
			} else {
				file_put_contents(DATA_DIR."POVDiff_Options.json",'{
	"traitement" : ["ColorationSyntaxique","..."]
}');
				return self::getDefaultsOptions();
			}
		}
	}

?>
