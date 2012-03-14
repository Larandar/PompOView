<?php
	/**
	 * Conposante visuel du POVCorpus , pour une nouvelle UI il suffit d'hérité celle-ci est de l'appeller dans le POVCorpus
	 */
	class POVCorpus_HtmlUI {
		
		public static function makeTable(POVCorpus $povc) {
			$data = $povc->getData();
			$style = $povc->getStyleSet();
			$filenames = $povc->getFilenames();
			
			$order = $povc->getClustering()->getOrder();
			
			$html = "";
			$html .= '<table class="pompoview-table">'.PHP_EOL;
			
			$html .= "<thead><tr><th></th>";
			foreach ($order as $o => $i) {
				$html .= sprintf('<th><abbr title="%s">%s</abbr></th>',$filenames[$i],$o+1);
			}
			$html .= "</tr></thead>".PHP_EOL;
			
			$html .= "<tbody>".PHP_EOL;
			foreach ( $order as $o => $i ) {
				$html .= "<tr>";
				$html .= sprintf('<th><abbr title="%s">%s</abbr></th>',$filenames[$i],$o+1);
				foreach ( $order as $j ) {
					$cour = $data[$i][$j];
					$html .= sprintf('<td style="%s"><abbr title="%f">%.2f</abbr></td>',$style->getStyleOf($cour),$cour,$cour);
				}
				$html .= "</tr>".PHP_EOL;
			}
			$html .= "</tbody>".PHP_EOL;
			$html .= "</table>".PHP_EOL;
			return $html;
		}
		
		public static function makeCorpusContent(POVCorpus $povc) {
			$filenames = $povc->getFilenames();
			$order = $povc->getClustering()->getOrder();
			
			$html = "";
			$html .= '<ul style="list-style:none;">'.PHP_EOL;
			foreach ($order as $o => $i) {
				$html .= sprintf('<li><strong>%d</strong>: %s',$o+1,$filenames[$i]).PHP_EOL;
			}
			$html .= "</ul>".PHP_EOL;
			
			return $html;
		}
	}
	
?>