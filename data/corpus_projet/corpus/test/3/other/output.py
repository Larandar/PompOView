# -*- coding: utf-8 -*-
import html, string, time, os

def stat ( file, u_title, u_tag, nbword, u_zipf, u_zipf_char, t ):
	"""Sauvegarde la page de statistique sur le document"""
	
	page = u"""
	<style type="text/css">
		.col {
			width: 50%%;
		}
		.left {
			float: left;
		}
		.right {
			float: right;
		}
		table {
			text-align: center;
		}
		td {
			color: #9370DB; 
			font-size: 20px; 
			font-weight: bold;
		}
		img {
			width: 100%%;
		}
		h1 {
			text-align: center;
		}
	</style>
	<p>
		%s<br />
		Fichier traité en %fs.	
	</p>
	<div class="left col">
		<table cellspacing="20">
			<tr>
				<td>%s</td>
			</tr>
			<tr>
				<td>%s</td>
			</tr>
			<tr>
				<td>%s</td>
			</tr>
		</table>
	</div>
	<div class="right col">
		<dl>
			<dt>Nombre de mots:</dt> <dd>%d</dd>
			<dt>Nombre de mots différents:</dt> <dd>%d</dd>
			<dt>Nombre de mots sur nombre de mots différents:</dt> <dd>%f</dd>
		</dl>
	</div>
	<br style="clear: both"/>
	<div class="left col">
		<img src="%s" alt="Nuage de points longueur et effectif" />
		<h1>Mots</h1>
		<img src="%s" alt="Loi de Zipf sur les mots" />
		<br />
		%s
	</div>
	<div class="right col">
		<img src="%s" alt="rang du mot x effectif" />
		<h1>Caractères</h1>
		<img src="%s" alt="Loi de Zipf sur les caractères" />
		<br />
		%s
	</div>
	"""%(
	u_title, 
	time.time() - t,
	string.join(u_tag[:5], u"</td><td>"), 
	string.join(u_tag[5:10], u"</td><td>"), 
	string.join(u_tag[10:], u"</td><td>"),
	nbword[0],
	nbword[1],
	nbword[2],
	unicode(file[1], 'utf-8') + u"_leneffect.png",
	unicode(file[1], 'utf-8') + u"_zipf_word.png",
	html.tuple_2_ol(u_zipf),
	unicode(file[1], 'utf-8') + u"_rangeffect.png",
	unicode(file[1], 'utf-8') + u"_zipf_char.png",
	html.tuple_2_ol(u_zipf_char)
	)
	
	html.write(	file[0] + file[1] + u"_stat.html",
				html.header( u"utf-8", u"Statistique de %s"%( string.join(file[1:]) ) ),
				page,
				u"</body>\n</html>",
				"utf-8" )

def nav_princ ( d, lang_list ):
	"""Sauvegarde la page de navigation principale"""
	
	lang_link = u''
	for lang in lang_list:
		lang_link += u'<a href="%s/nav.html" target="iframe_1">%s</a> - '%( lang, lang )
	
	lang_link = lang_link[:-3]
	
	page = u"""			
		<style type="text/css">
			#all { height: 100%%; }					
			#link { text-align: center; height: 30px; }					
			iframe { width: 100%%; }
		</style>				
		<script src="jquery-1.6.4.min.js" type="text/javascript"></script>
		<div id="all">
			<div id="link">
				%s
			</div>					
			<iframe src="%s" name="iframe_1" id="if"></iframe>
		</div>
	"""%(
		lang_link,
		lang_list[0] + u"/nav.html"
	)
	
	html.write(	u"%snav.html"%( d ),
				html.header( u"utf-8", u"LTAL TP 1-2" ),
				page,
				u"</body>\n</html>",
				"utf-8" )
				
def nav_lang ( d, lang, file_list ):
	"""Sauvegarde la page de navigation de la langue"""
	
	file_link = u''
	for f in file_list:
		file_link += u'<a href="%s_nav.html" target="iframe_2">%s</a> - '%( os.path.splitext(f)[0], os.path.splitext(f)[0] )
	
	file_link += u'<a href="%s_stat.html" target="iframe_2">statistique de la langue</a>'%( lang )
	
	page = u"""
		<style type="text/css">
			#all { height: 100%%; }					
			#link { text-align: center; height: 30px; }					
			iframe { width: 100%%; }
		</style>				
		<script src="../jquery-1.6.4.min.js" type="text/javascript"></script>
		<div id="all">
			<div id="link">
				%s
			</div>
			
			<iframe src="%s" name="iframe_2" id="if"></iframe>
		</div>
	"""%(
		file_link,
		os.path.splitext(file_list[0])[0] + u"_nav.html"
	)
	
	html.write(	u"%s/nav.html"%( d+lang ),
				html.header( u"utf-8", lang ),
				page,
				u"</body>\n</html>",
				"utf-8" )
				
def nav_file ( d, lang, f, ext ):
	"""Sauvegarde la page de navigation du fichier"""
	
	page = u"""
		<style type="text/css">
			#all { height: 100%%; }					
			#link { text-align: center; height: 30px; }					
			iframe { width: 100%%; }
		</style>				
		<script src="../jquery-1.6.4.min.js" type="text/javascript"></script>
		<div id="all">
			<div id="link">
				%s - 
				<a href="%s%s" target="iframe_3">version originale</a>
				<a href="%s_color.html" target="iframe_3">version coloriée</a>
				<a href="%s_stat.html" target="iframe_3">statistique</a>
			</div>
			
			<iframe src="%s_stat.html" name="iframe_3" id="if"></iframe>
		</div>
	"""%(
		f,
		f,
		ext,
		f,
		f,
		f
	)
	
	html.write(	u"%s/%s_nav.html"%( d+lang, f ),
				html.header( u"utf-8", f ),
				page,
				u"</body>\n</html>",
				"utf-8" )