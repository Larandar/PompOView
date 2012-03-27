<?php
	/**
	 * Conposante visuel du POVCorpus , pour une nouvelle UI il suffit d'hérité celle-ci est de l'appeller dans le POVCorpus
	 */
	class POVCorpus_HtmlUI {
		
		public static function makeTable(POVCorpus $povc,$curl,$cid) {
			$data = $povc->getData();
			$style = $povc->getStyleSet();
			$filenames = $povc->corpus->getFileNames();
			
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
				$html .= sprintf('<th><abbr title="%s">%s</abbr></th>',htmlentities($filenames[$i]),$o+1);
				foreach ( $order as $j ) {
					$cour = $data[$i][$j];
					
					$action = (!$povc->corpus->ProjetMode() && $i != $j ) ? sprintf(
						'onclick="PompOView.UI.vars(\'%s\').openDiff(%d,%d)"',$curl,$i,$j) : "";
					
					$html .= sprintf('<td style="%s" %s><abbr title="%f">%.2f</abbr></td>',$style->getStyleOf($cour),$action,$cour,$cour);
				}
				$html .= "</tr>".PHP_EOL;
			}
			$html .= "</tbody>".PHP_EOL;
			$html .= "</table>".PHP_EOL;
			
			$html .= '<script type="text/javascript" charset="utf-8">
				
			</script>';
			
			return $html;
		}
		
		public static function makeCorpusContent(POVCorpus $povc,$curl,$cid) {
			$corpus = $povc->corpus;
			$projets = $corpus->getProjets();
			$proot = $corpus->getProjetsRoot();
			$order = $povc->getClustering()->getOrder();
			
			$pmode = $corpus->ProjetMode();
			
			$format = ' <strong class="monospace">[%0'.strlen(count($order)-1).'s] </strong>';
			
			if ($corpus->ProjetMode()) {
				$order  = array_flip($order);
			} else {
				
			}
			
			$order[-1] = -1;
			
			$html = "";
			$html .= '<ul class="pretty" style="list-style:none;">'.PHP_EOL;
			foreach ($projets as $key => $value) {
				$html .= "<li>" . ( $pmode && in_array($key,array_flip($order)) ? sprintf($format,$order[$key]+1) : '' ) . ($key) . ' :<ul style="list-style:none;">';
				foreach ($value as $skey => $val) {
					$file  = str_replace($proot,'<strong class="monospace">/</strong> ',$val);
					$ind   = $corpus->getNewIDOfFile($val);
					$html .= "<li>";
					$html .= '<input type="checkbox" name="'.$cid.'-document-list" '.($corpus->isActive($val)?'checked="checked"':'');
					$html .= ' value="'.$corpus->getIDOfFile($val).'" />';
					$html .= !$pmode ? sprintf($format, $corpus->isActive($val) ? ($order[$ind]+1) : -1 ) : '' ;
					$html .= $file;
					$html .= "</li>";
				}
				$html .= "</ul>"."</li>".PHP_EOL;
			}
			$html .= "</ul>".PHP_EOL;
			
			$html .= '<script type="text/javascript" charset="utf-8">
				
			</script>';
			
			return $html;
		}
		
		public static function makePOVCorpusForm(POVCorpus $povc,$curl,$cid) {
			$form = '<form class="pretty" id="'.$cid.'-options-form"><table>'.PHP_EOL;
			
			$form .= '<p><label>Mode de clustering: <select id="'.$cid.'-options-form-clustering">';
			foreach (Clustering::getAll() as $key => $value) {
				$form .= '<option value="'.$key.'">'.$value.'</option>';
			}
			$form .= '</select></label><br/>';
			
			$form .= '<label>Distance adoptée pour le clustering: <select id="'.$cid.'-options-form-clustering-distance">';
			foreach (Distance::getAll() as $key => $value) {
				$form .= '<option value="'.$key.'">'.$value.'</option>';
			}
			$form .= '</select></label></p>';
			
			
			$form .= '<p><label>Style de coloration de la matrice: <select id="'.$cid.'-options-form-styleset">';
			foreach (StyleSet::getAll() as $key => $value) {
				$form .= '<option value="'.$key.'">'.$value.'</option>';
			}
			$form .= '</select></label><br/>';
			
			$form .= '<td><label>Partitionneur de couleur pour le style: </label></td><td><select id="'.$cid.'-options-form-partitionneur" ';
			$form .= 'onchange="'."PompOView.UI.vars('".$curl."').loadpartitionneur();".'">';
			foreach (Partitionneur::getAll() as $key => $value) {
				$form .= '<option value="'.$key.'">'.$value.'</option>';
			}
			$form .= '</select></td><br/>';
			$form .= '<script type="text/javascript" charset="utf-8">
				PompOView.UI.vars("'.$curl.'").loadpartitionneur = function () {
					jQuery.post(PompOView.ajax('."'fragment/pompoview-corpusview.form.select.parametre-partitionneur.php'".'),
					{json:\'{"corpus":"'.$povc->corpus->getCorpusName().'"}\',cid:"'.$cid.'",curl:"'.$curl.'",partitionneur: $("#'.$cid.'-options-form-partitionneur").val()},
					function (data) {$("#'.$cid.'-options-form-parametre-partitionneur").html(data);});
					
				};
				PompOView.UI.vars("'.$curl.'").loadpartitionneur();
			</script>';
			
			$form .= '<td><label>Paramètre du partitionneur: </label></td><td><select id="'.$cid.'-options-form-parametre-partitionneur">';
			
			$form .= '</select></p>';
			$form .= '</table></form>';
			
			return $form;
		}
		
		public static function makeCorpusStats(POVCorpus $povc,$curl,$cid) {
			return "<p>TODO</p>";
		}
	}
	
?>