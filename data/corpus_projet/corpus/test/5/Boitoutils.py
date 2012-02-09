#!/usr/local/bin/pythonw
# -*- coding: utf-8 -*-


import re, string, htmlentitydefs



def LireFichierTexte (nom_fichier_complet):
	ofi = open(nom_fichier_complet, 'r')   
	chaine = ofi.read()
	ofi.close()
	return chaine


def EcrireFichierTexte (nom_fichier, chaine):
	ofi = open(nom_fichier, 'w')   
	ofi.write(chaine)
	ofi.close()


def Encoding(source_html) :
	encoding_original = u'iso-8859-1'
	pattcomp = re.compile(u'<meta.*CONTENT=["\']text/html; ?charset=(.*?)["\']', re.I)
	match_charset = re.search(pattcomp, source_html)
	if match_charset:	#  
		encoding_original = string.lower(match_charset.group(1))
		print u'charset trouvé dans le source html : '.encode('utf-8'), unicode(encoding_original).encode('utf-8', 'replace')
	# si le charset n'est pas dans le source html : iso-8859-1 par défaut
	else : 
		print u'pas de charset dans le source html => charset par défaut : '\
		                                              .encode('utf-8'), unicode(encoding_original).encode('utf-8', 'replace')
	return encoding_original


def NettoyagePreliminaire (source_html) :   # en unicode python
      source_html = re.sub(u'&nbsp;', ' ', source_html)
      source_html = re.sub(u'[\s]+', u' ', source_html)

      pattern1 = re.compile(u'<script.+?</script>', re.I | re.M)
      source_html = pattern1.sub(u'', source_html)

      pattern2 = re.compile(u'<!\-\-.+?\-\->', re.M)
      source_html = pattern2.sub(u'', source_html)

      pattern3 = re.compile(u'<select.+?</select>', re.I | re.M)
      source_html = pattern3.sub(u'', source_html)

      pattern4 = re.compile(u'<style.+?</style>', re.I | re.M)
      source_html = pattern4.sub(u'', source_html)

      source_html = re.sub(u'(?:&gt;|&lt;)', u' ', source_html)

      pattern5 = re.compile(u'[\s]*</*[^>]+/*>[\s]*', re.I | re.M)
      source_html = pattern5.sub(u' # ', source_html)

      pattern6 = re.compile(u'\s[#\s]+', re.I | re.M)
      source_html = pattern6.sub(u' # ', source_html)
	
      source_html = re.sub(u'(?:&gt;|&lt;)', u' ', source_html)
	
	
      return source_html


def DecoderEntites (source_html) :
	source_html = re.sub(u'&#([0-9]+);', Entite_num_rempl, source_html)
	pattcomp = re.compile(u'&([a-z]+);', re.I)
	source_html = pattcomp.sub(Entite_alpha_rempl, source_html)
	return source_html

def Entite_num_rempl(matchobj) :			# 255 
	if int(matchobj.group(1)) in range(65535): return unichr(int(matchobj.group(1)))
	else: return u'&#' + matchobj.group(1) + u';'

def Entite_alpha_rempl(matchobj) :
	cle = matchobj.group(1)
	if not htmlentitydefs.entitydefs.has_key(cle) :
		if cle.isupper() : 
			cle = string.lower(matchobj.group(1))
			if not htmlentitydefs.entitydefs.has_key(cle) : 
				return ''
		else : 
			return ''
	if len(htmlentitydefs.entitydefs[cle]) == 1 :

		car = htmlentitydefs.entitydefs[cle]
		return unicode(car, 'iso-8859-1') 		
	else :
		str_code_point = htmlentitydefs.entitydefs[cle].strip(u'&#;')
		return unichr(int(str_code_point))
