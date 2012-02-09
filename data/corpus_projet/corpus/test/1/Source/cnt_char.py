#!/usr/local/bin/pythonw
# -*- coding: utf-8 -*-

def CharCounter( src ):
	dico = {}
	for i in range(0, len(src) ):
		if src[i]!=u' ' and src[i]!=u'#':
			if dico.has_key( src[i].upper() ):
				dico[ src[i].upper() ] +=1
			else:
				dico[ src[i].upper() ] = 1
	return dico

#exporte la liste de mots comptés et rangés
#dans un .CSV
def ExportTuple2CSV(f_name, upe):
	f = open(f_name, 'w')
	k = 0
	for i in upe:
		s = '%d, %d, %d\n'%(len(i[0]), i[1], k)
		k+=1
		f.write( s )
	f.close()
	return

#expore un tuple de caractères comptés et
#rangés dans un .CSV
def ExportCharTuple2CSV(f_name, upe):
	f = open(f_name, 'w')
	k = 0
	for i in upe:
		s = '%d, %d\n'%(k, i[1])
		k+=1
		f.write( s )
	f.close()
	return

#Détéction des occurences des groupes de mots
#contingus
#Retourne une pile d'expressions non triées.
def SameString(allWord):
	res = []
	lib = OccCounter( allWord )
	for fen in range(2, (len(allWord) / 2) ):
		for i in range(0, len(allWord) - (fen) ):
			occ = allWord[i: i + fen]
			if IgnoreThat(occ, lib)==False:
				for j in range(i + fen, len(allWord) - (fen) ):
					if allWord[j: j+fen]==occ and res.__contains__(occ)==False:
						res += [occ]
	return res

def list2str( liste ):
	res = ''
	for case in liste:
		if res=='':
			res = '%s'%(case)
		else:
			res = '%s %s'%(res, case)
	return res

def OccCounter( listWord ):
	res = {}
	for case in listWord:
		if( res.has_key(case) ) :
			res[case] += 1
		else :
			res[case] = 1
	return res

def IgnoreThat(liste, dico):
	for case in liste:
		if dico[case] < 2:
			return True
	return False


#Méthode de tri la 'pile' d'occurences
def StackSort(x, y):
	return len(x)-len(y)

def RebaliseMyHTML( src ):
	text = u'<p>'
	for i in range(0, len(src) ):
		if src[i]=='#' and src[i-1]==' ':
			text+=u'</p><p>'
			i+=1
		text += src[i]
	text+=u'</p>'
	return text

def ZipfLaw( dico ):
	eff = dico.values()
	eff.sort()
	eff.reverse()
	liste = []
	for i in range( 0, len(eff) ):
		if i % 10==0:
			liste.append(eff[i])
	return liste

#Epuration de la liste des double-occurences
#def CleanOcc( Liste ):
#	newlist = []
#	for i in range( 0, len(Liste) - 1 ):
#		v = False
#		for j in newlist:
#			if j==Liste[i]:
#				v = True
#		if v==False:
#			newlist.append( Liste[i] )
#
#	return newlist

