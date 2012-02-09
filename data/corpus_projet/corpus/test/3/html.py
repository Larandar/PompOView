# -*- coding: utf-8 -*-
import re, string

def read ( path ):
	"""Lit et retourne le contenu d'un fichier"""
	with open(path, 'r') as f:
		text = f.read()	
		
	return text
	
def write( path, header, body, footer, encoding ):
	"""Ecrit un fichier html en utf-8"""
	with open(path, 'w') as f:
		header = string.replace(header, encoding, "utf-8") # remplace l'ancien encoding du header par utf-8 pour un affichage correct
		out = header + body + footer		
		f.write( out.encode("utf-8") )
	
def encoding ( raw_data ):
	"""Détecte l'encoding d'un fichier html"""
	charset = re.search( "<meta.*?charset[\W]*?([\w_ -]+)", raw_data, re.I|re.S )
	
	if charset:
		# balise meta charset trouvée
		try:
			u_data = unicode( raw_data, charset.group(1) )
			# si aucun problème dans l'encodage en unicode
			return charset.group(1), u_data
		except:
			""
	
	# balise meta non détectée ou problème lors de l'encodage en unicode
	import chardet
	encod = chardet.detect(raw_data)["encoding"]
	
	# impossible de détecter l'encodage
	if encod == None:
		return None, None
	
	try:
		u_data = unicode( raw_data, encod )
		# si aucun problème dans l'encodage en unicode
		return encod, u_data
	except:
		# impossible de détecter l'encodage
		return None, None
		
def extract_parts ( u_data ):
	"""Extrait les différentes parties d'un fichier html: header, title, body, footer"""
	u_header = re.search( u".*?<body.*?>", u_data, re.I|re.U|re.S )
	u_title = re.search( u"<title>(.*?)</title>", u_data, re.I|re.U|re.S )
	u_body = re.search( u".+?<body.*?>(.*?)</body>.+", u_data, re.I|re.U|re.S )
	u_footer = re.search( u"</body>.*", u_data, re.I|re.U|re.S )
	
	# Si les regex ont trouvé leurs parties renvoies ces parties sinon chaine vide
	u_header = u_header.group(0) if u_header else ''
	u_title = u_title.group(1) if u_title else ''
	u_body = u_body.group(1) if u_body else ''
	u_footer = u_footer.group(0) if u_footer else ''
	
	return u_header, u_title, u_body, u_footer

def clean ( u_data ):
	"""Enleve les balises html des données"""
	u_data = re.sub( u"&nbsp;", u' ', u_data, re.I )
	
	bloc_tag = u"iframe|map|script|noscript|object|select|button|style|textarea"
	html_tag = u"<(%s).+?</(%s)>|<.+?>"%(bloc_tag, bloc_tag)
	
	html_tag_iters = re.finditer( html_tag, u_data, re.I|re.S )
	
	tags, i, k = {}, 0, 0
	new_data_id, new_data_clean = u"", u""
	
	# balises ne provoquant pas de coupures dans le texte (mots contigus)
	inline_tags = re.compile( '</?(a|b|bi|ce|em|fo|i|kb|q|sa|sm|sp|st|su|tt|u)>', re.I )
	
	# sauvegarde la valeur des balises pour les remettre après coloriage
	for iter in html_tag_iters:
		tag = iter.group(0)		
		
		tags[ str(i) ] = tag
		
		temp = u_data[ k : iter.start() ]
		new_data_id += temp + u" #%i# "%(i)
		new_data_clean += temp
		
		if inline_tags.match(tag) == None:
			new_data_clean += u" # "
		
		k = iter.end()
		i += 1
		
	temp = u_data[ k : ]
	new_data_id += temp
	new_data_clean += temp
	
	# suprimme espaces et macro-ponctuation multiples 
	new_data_id = re.sub( u"\s+", u' ', new_data_id )
	new_data_clean = re.sub( u"\s+", u' ', new_data_clean )
	new_data_clean = re.sub( u"#( #)+", u'#', new_data_clean )

	return new_data_id, new_data_clean, tags
	
def tuple_2_ol( ltuple ):
	"""Transforme une liste de tuple en liste numéroté html"""
	out = u''
	
	for (word, num) in ltuple:
		out += u'<li><b>%s</b> : %s</li>'%(word, num)
	
	return u'<ol>%s</ol>'%(out)
	
def header( encoding, title ):
	"""Retourne un header html de base avec meta charset et title"""
	return u'<html>\n<head>\n<meta http-equiv="Content-Type" content="text/html;\
		   charset=%s">\n<title>%s</title>\n</head>\n<body>'%(encoding, title)