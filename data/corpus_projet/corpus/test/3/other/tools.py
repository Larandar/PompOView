# -*- coding: utf-8 -*-
import re, string, collections, htmlentitydefs

def decode_html_entities ( s_unicode ):
	#see :: def replace_num_entities()
	html = re.sub( u'&#([0-9]+);', replace_num_entities, s_unicode )
	pattern = re.compile( u'&([a-z]+);', re.I )
	#see :: def replace_alpha_entities()
	html = pattern.sub( replace_alpha_entities, html )
	return html

def replace_num_entities ( matchobj_unicode ):
	if 0 <= int( matchobj_unicode.group(1) ) < 65535:
		return unichr( int( matchobj_unicode.group(1) ) )

	return u'&#%s;'%( matchobj_unicode.group(1) )

def replace_alpha_entities ( matchobj_unicode ):
	k = matchobj_unicode.group(1)
	if not htmlentitydefs.entitydefs.has_key(k) :
		if k.isupper():
			k = string.lower( matchobj_unicode.group(1) )
			if not htmlentitydefs.entitydefs.has_key(k):
				return u''
		else :
			return u''
	if len( htmlentitydefs.entitydefs[k] ) == 1:
		return unicode( htmlentitydefs.entitydefs[k], 'iso-8859-1' )
	
	return unichr( int( htmlentitydefs.entitydefs[k].strip(u'&#;') ) )

def list_words ( data ):
	""" Renvoie la liste des mots du fichier html"""
	
	# Liste des caractères "alphabétique"
	alpha = u"[\u0030-\u0039\u0041-\u005A\u0061-\u007A\u00AA\u00B5\u00BA\u00C0-\u00D6\u00D8-\u00F6\u00F8-\u02C1\u02C6-\u02D1" +\
			u"\u02E0-\u02E4\u02EE\u0370-\u0373\u037A\u0386\u0388-\u03CF\u03D0-\u03F5\u03F7-\u03FB\u0400-\u0481\u048A-\u0520" +\
			u"\u0531-\u0556\u0561-\u0587\uA640-\uA69F\uA720-\uA7FF]+"
	# Liste des caractères "idéographique"
	ideo = u'[\u2E80-\u2FD5\u3021-\u3029\u3031-\u3035\u3038-\u303D\u3041-\uA4CF\uA960-\uA97F\uAC00-\uD7FF\uF900-\uFAFF#]'
	
	return re.findall( alpha + u'|' + ideo, data)
	
def list_2_dict_effectif ( list ):
	"""Prend une liste de mots et retourne le dictionnaire des effectifs"""
	dict_effectif = collections.defaultdict(int)
	
	for word in list:
		dict_effectif[string.lower(word)] += 1
		
	return dict_effectif

def char_effect ( dict_effect ):
	"""Prend le dictionnaire des effectifs des mots et construit le dictionnaire des effectifs des caractères"""
	dict = collections.defaultdict(int)
	
	for word in dict_effect:
		if not "#" in word:
			for char in word:
				dict[char] += dict_effect[word]
			
	return dict
	
def dict_effectif2distrib_zipf ( dict_effectif ):
	"""Prend le dictionnaire des effectifs et retourne une liste ordonnée décroissante"""
	distrib_zipf = []
	
	for word, effect in dict_effectif.items():
		# on ne compte pas la macro-ponctuation comme un mot
		if word[0] != "#":
			distrib_zipf.append( (word, effect) )
	
	return sorted( distrib_zipf, key=lambda index: index[1], reverse=True )
	
def list_chars ( dict_effect ):
	"""Prend le dictionnaire des effectifs des mots et construit la liste des caractères"""
	list_char = []
	
	for word in dict_effect:
		list_char += list(word+"#")*dict_effect[word]
		
	return list_char
	
def word_stat ( dict_effect ):
	"""Prend le dictionnaire des effectifs des mots et fait des statistiques sur les mots du texte"""
	num = 0
	total = 0.0
	for i in dict_effect:
		if not "#" in i:
			num += dict_effect[i]
			total += 1
			
	return ( num, total, num/total)
	
def add_defdict ( dict1, dict2 ):
	"""Ajoute le defaultdictionnary dict2 dans dict1"""
	
	for key in dict2:
		dict1[key] += dict2[key]

	return dict1