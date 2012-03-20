<?php
	//
	/**
	 * 
	 */
	class Corpus_Uploader {
		
		protected $return;
		
		function __construct() {
			if (!isset($_FILES['corpus_upload']) || $_FILES['corpus_upload']['error'] != 0) {
				$this->return = array("state" => "error" , "message" => $_FILES['corpus_upload']['error']);
			} else if ( !preg_match('/(tar\.gz|tgz|targz|zip)$/',$_FILES['corpus_upload']["name"])) {
				$this->return = array("state" => "error" , "message" => "Only:{tar.gz, targz, tgz, zip} file");
			} else {
				$file = $_FILES['corpus_upload'];
				$newfile = Corpus_Uploader::getFreeName($file["name"]);
				$move = move_uploaded_file($file["tmp_name"],DATA_DIR.$newfile);
				$test_corpus = new Corpus(DATA_DIR.$newfile);
				if ( $test_corpus->exist()) {
					$this->return = array("state" => "success" , "message" => 'File upload is a success. Save as: <a href="'.DATA_URL.$newfile.'" >'.DATA_URL.$newfile.'</a>');
				} else {
					unlink(DATA_DIR.$newfile);
					$this->return = array("state" => "error" , "message" => "The tar must have a out.js file on is root");
				}
			}
		}
		
		public function getReturn($name = null) {
			if (is_null($name) || !isset($this->return[$name])) {
				return $this->return;
			} else {
				return $this->return[$name];
			}
		}
		
		
		public static function getFreeName($name) {
			
			if (!@is_file(DATA_DIR.$name)) {
				return $name;
			} else {
				$crc = crc32($name.microtime());
				$replace = '${1}.'.$crc.'${2}';
				return preg_replace('/(.*)(\.(tar\.gz|targz|zip))/',$replace,$name);
			}
		}
		
		public static function getForm() {
			$form = '<form method="post" action="'.URL_AJAX.'corpus-uploader.form.php" enctype="multipart/form-data">';
			$form .= '<input class="button" type="file" name="corpus_upload" style="width:500px" />';
			$form .= '<input class="button" type="submit" value="Envoyer" />';
			$form .= '</form>';
			return $form;
		}
	}
	
?>