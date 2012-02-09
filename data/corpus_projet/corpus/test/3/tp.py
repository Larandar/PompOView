# -*- coding: utf-8 -*-
import os, sys, html, tools, time, re, string, collections, plot, output, shutil

def adjoining_words ( data, start, stop=-1 ):
	"""Recherche les groupes de mots contigus dans une liste de mots"""
	adj_words = {}
	
	n = start
	while True:
		
		# collections.defaultdict agis comme un dictionnaire standard mais avec une valeur par défault
		dict = collections.defaultdict(int)
		for i in xrange( len(data)-n+1 ):
			
			d = data[i:i+n]
			if not "#" in d:			
				dict[tuple(d)] += 1
		
		# on ne récupère que les groupes des mots répété
		new_list = []
		for i in dict:
			if dict[i]>1:
				new_list.append( (i, dict[i]) )
			
		# si aucun groupe de taille n il n'y en aura pas de taille n+1
		if len(new_list) == 0:
			break
			
		# on tris les groupes de mots par effectif décroissant
		def cmpval ( x, y ):
			return y[1] - x[1]
		new_list.sort( cmpval )
		
		adj_words[n] = new_list
			
		if n == stop:
			break
			
		n += 1
	return adj_words

def color ( adjoining_words_i, data, balises ):
	"""Colorie les groupes de mots contigus dans une page web"""
	n = len(adjoining_words_i) + 1
	
	# on commence par les groupes les plus longs
	for i in xrange( n, 1, -1 ):
		
		# pour chaque groupe de mots
		for j in adjoining_words_i[i]:
			
			text = u'(\A|\W)(%s)(\W|\Z)'%( string.join([j[0][k] for k in range(0,i)] ,'(?:(?:</span>\W?)|\W)') )
			pattern1 = re.compile(text, re.I|re.U|re.S)		
			replace = u'\g<1><span class="%s" style="color:blue; background-color:grey;">\g<2></span>\g<3>'%(string.join(j[0],""))
			data = pattern1.sub(replace, data)
	
	re.purge()
	# recherche les emplacements sauvegardés des balises
	data_color = u''	
	flag3 = re.compile( u'#([0-9]+?)#', re.I|re.U|re.S )
	m = flag3.finditer( data )
	k = 0
	
	# remet les balises dans la chaine
	for j in m:
		data_color += data[k:j.start()] + balises[j.group(1)]
		k = j.end()
		
	data_color += data[k:]
	
	return data_color
	
def tag_cloud ( zipf ):
	"""Retourne une liste de 15 mots clefs choisis dans la liste des mots répétés trié par ordre décroissant d'effectif"""
	start = zipf[0][1] / 10
	tag = []
	
	i, j = 0, 0
	while j < 15 and i < len(zipf):
		
		if zipf[i][1] <= start:
			j += 1
			tag.append( zipf[i][0] )
			
		i += 1
	
	return tag
	
def main ( file ):
	"""Fonction principale du programme"""
	
	# taille des n-grammes de caractères contigus
	NG_CHAR = 3	
	t = time.time()
	
	# Lecture du fichier, détection de son encoding et encodage en unicode
	raw_data = html.read( string.join(file, '') )      
	encoding, u_data = html.encoding( raw_data )
	
	# Si l'encoding n'est pas trouvé, on écourte le traitement de la page
	if encoding == None:
		return None
		
	# Extraction des différentes parties du fichier html + nétoyage des balises
	u_header, u_title, u_body, u_footer = html.extract_parts( u_data )
	u_body, u_body_clean, u_balises = html.clean( tools.decode_html_entities(u_body) )
	
	# Liste les mots et caractères et fait leurs effectifs
	u_list_words = tools.list_words( u_body_clean )
	u_dict_effect = tools.list_2_dict_effectif( u_list_words )	
	u_list_chars = tools.list_chars( u_dict_effect )
	u_char_effect = tools.char_effect( u_dict_effect )

	# Calcul la loi de Zipf sur les mots et les caractères	
	u_zipf = tools.dict_effectif2distrib_zipf( u_dict_effect )
	u_zipf_char = tools.dict_effectif2distrib_zipf( u_char_effect )
	
	# Trouve les groupes de mots et caractères contigus du texte
	u_adjoining_words = adjoining_words( u_list_words, 2 )
	u_adjoining_char = adjoining_words( u_list_chars, NG_CHAR, NG_CHAR )
		
	# Trouve des mot clefs du texte et fait des statistiques sur le nombre de mots
	u_tags = tag_cloud( u_zipf ) if u_zipf else []
	nbword = tools.word_stat( u_dict_effect ) if u_zipf else [0, 0, 0]
			
	# Sauvegarde les n-grammes de caractères dans un fichier texte
	if NG_CHAR in u_adjoining_char:
		with open(file[0] + file[1] + "_adjchars.txt", "w") as f:
			for char in u_adjoining_char[NG_CHAR]:
				f.write( "%s : %s \n"%( string.join(char[0], '').encode("utf-8"), str(char[1]) ) )
			
	# Sauvegarde les graphs sur la loi de zipf, sur le rang x effectif et sur longueur / effectif
	plot.save_zipf( file, "_word", u_zipf, "f(rang) = effectif" )
	plot.save_zipf( file, "_char", u_zipf_char, "f(rang) = effectif" )
	plot.save_rangeffectif( file, u_zipf )
	plot.save_leneffectif( file, u_zipf )
	
	# Sauvegarde le fichier colorié
	html.write(	file[0] + file[1] + "_color.html",
				u_header,
				color(u_adjoining_words, u_body, u_balises),
				u_footer,
				encoding )
	
	# Sauvegarde le fichier de statistique
	output.stat( file, u_title, u_tags, nbword, u_zipf, u_zipf_char, t )	
	
	return u_dict_effect
	
if __name__== '__main__':
	t = time.time()
	
	if len(sys.argv) == 3 and sys.argv[2][0:2] == "-D": # Passage en argument d'un dossier
	
		# option -DN -> création de fichiers de navigation
		navig = sys.argv[2][-1] == "N"			
		
		# Nom du dossier et liste des langues du corpus
		dirname = sys.argv[1]
		langs = os.listdir( dirname )	
		files = {}
		
		for lang in langs: # pour chacune des langues
			t2 = time.time()
			dirnamelang = dirname + "/" + lang
			# ne prend que les fichier .htm .html .xml
			files[lang] = [ f for f in os.listdir( dirnamelang ) if os.path.isfile( os.path.join( dirnamelang, f ) ) and os.path.splitext(f)[1] in [".html", ".htm", ".xml"]  ]
					
			print ""
			print "Traitement en cours: " + lang,
			u_effect_lang = collections.defaultdict(int)
			path = [ dirnamelang+"/", lang ]
			
			# pour chacun de ces fichiers lance le traitement
			for file in files[lang]:				
				print file,
				file = os.path.splitext(file)
				
				ret = main( ( dirnamelang+"/", file[0], file[1] ) )
				
				# fichier de navigation
				if navig: output.nav_file( dirname+"/", lang, file[0], file[1] )
				
				# si le traitement du fichier c'est bien passé on rajoute au dictionnaire des effectifs de la langue celui de la page
				if ret != None:
					u_effect_lang = tools.add_defdict( u_effect_lang, ret )
				
			if navig: output.nav_lang( dirname+"/", lang, files[lang] )
				
			# traitement des données sur le corpus mono-langue
			u_char_effect = tools.char_effect( u_effect_lang )
			u_zipf = tools.dict_effectif2distrib_zipf( u_effect_lang )
			u_zipf_char = tools.dict_effectif2distrib_zipf( u_char_effect )
			nbword = tools.word_stat( u_effect_lang ) if u_zipf else [0, 0, 0]
			
			plot.save_zipf( path, "_word", u_zipf, "f(rang) = effectif" )
			plot.save_zipf( path, "_char", u_zipf_char, "f(rang) = effectif" )
			plot.save_rangeffectif( path, u_zipf )
			plot.save_leneffectif( path, u_zipf )
			
			output.stat( path, "Statistique de la langue: " + lang, [], nbword, u_zipf, u_zipf_char, t2 )	
		
		if navig: output.nav_princ( dirname+"/", langs )
		shutil.copy( "jquery-1.6.4.min.js", dirname )
		
		print ""
		print "Traitement fini en: %ss"%( str(time.time() - t)[0:5] )
		
	elif len(sys.argv) == 2: 
		if os.path.isfile(sys.argv[1]): # Passage en argument d'un fichier seul
			file = os.path.splitext(sys.argv[1])
			f = list(os.path.split(file[0]))
			if f[0] != "":
				f[0] = f[0] + '/' 
				
			print "Traitement en cours: " + sys.argv[1]
			main( ( f[0], f[1], file[1] ) )
			print "Traitement fini en: %ss"%( str(time.time() - t)[0:5] )
	
	# Erreurs dans les arguments
		else:
			sys.exit("Erreur argument(s) incorrect(s)")
	else:
		sys.exit("Erreur argument(s) incorrect(s)")
	
