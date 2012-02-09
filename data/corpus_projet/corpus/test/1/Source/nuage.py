#!/usr/local/bin/pythonw
# -*- coding: utf-8 -*-

#Nuage de mots-clés

def Nuage( word ):

	res = {}

	#Avoir le millieu de la courbe
	sz_start = len(word) / (3)
	sz_end   = sz_start * 2

	taille = 72

	i = sz_start
	while i < sz_end:
		res[ word[i][0] ] = taille
		taille = (taille - 1)
		if taille<10:
			taille = 10
		i +=1

	return res

def ExportNuageHTML( src , fpp ):
	f_name = '%s_nage.html'%(fpp)
	f = open(f_name, 'w')
	res = u'<html><head><meta http-equiv="Content-Type" content="text/html; charset=utf-8" /><title>Nuage de mots-clés</title></head><body><p>'
	for case in src.keys():
		ko = u' <span style="font-size:%d;">%s</span>'%(src[case], case)
		res = res + ko
	res += u'</p></body></html>'

	res = res.encode('utf-8')
	f.write( res )
	f.close()
	return

