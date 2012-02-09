#!/usr/bin/python
# -*- coding: utf-8 -*-
import matplotlib.pyplot as plt
import re
import os
import sys
import math
from Boitoutils import NettoyagePreliminaire, DecoderEntites, \
     EcrireFichierTexte, LireFichierTexte, Encoding \


def Lire_preparer_fichier (chemin_fichier) :
    global titre
    source_html = LireFichierTexte(chemin_fichier) # en encoding original
    # dÈtecter le codage original
    encoding_original = Encoding(source_html)
    source_html = unicode(source_html, encoding_original, 'replace')
    titre=Extraire_titre(source_html)
    # supprimer les scripts, sauts de ligne, commentaires, ...
    source_html = NettoyagePreliminaire(source_html) 
    source_html = DecoderEntites(source_html)
    return source_html
    

def Extraire_titre (source_html) :
    titre = ''
    # extraction du titre de la fenÍtre
    pattcomp = re.compile(u'<title>(.+)<\/title>', re.I)
    trouv_titre = re.search(pattcomp, source_html)
    if trouv_titre:
                titre = trouv_titre.group(1)
    return titre

def Compter_les_mots (source_html) :
    effectif_de_mot = {}       
    source_html = re.sub(u'<[^>]+>', u'#', source_html)
    motif_un_mot_compile = re.compile(u'[^ \'"¬´¬ª#\.\?,;:!\(\)\[\]\|]+')          
    # constituer la liste des occurrences de mots
    liste_graphies_mots = motif_un_mot_compile.findall(source_html)
    chaine_mot_clean = Chaine( liste_graphies_mots )
    for graphie_mot in liste_graphies_mots :   
        if graphie_mot: 
            # calculer effectifs des mots
            if graphie_mot in effectif_de_mot:
		effectif_de_mot[graphie_mot] += 1
            else :
                effectif_de_mot[graphie_mot] = 1
    return effectif_de_mot

#Transformer une liste de mots en une chaine de caracteres
def Chaine ( l ):
  res = ''
  for i in l:
    if res == '':
      res = i
    else:
      res = '%s %s'%(res, i)
  return res


def Compter_les_char(source_html):
    effectif_de_mot = {}         
    source_html = re.sub(u'<[^>]+>', u'#', source_html)
    motif_un_mot_compile = re.compile(u'[^ \'"¬´¬ª#\.\?,;:!\(\)\[\]\|]+')          
    # constituer la liste des occurrences de caractËres
    liste_graphies_mots = motif_un_mot_compile.findall(source_html)
    chaine_mot_clean = Chaine( liste_graphies_mots )
    alphabet = {} 
    for i in range(0,len(chaine_mot_clean)):
      if alphabet.has_key(chaine_mot_clean[i].upper()):
	alphabet[chaine_mot_clean[i].upper()] += 1
      else:
	alphabet[chaine_mot_clean[i].upper()] = 1
    it=alphabet.values()
    it.sort()
    it.reverse()
    
    a = range(0, len(it))
    plt.loglog(a, it, basex=10)
    plt.grid(True)
    plt.xlabel('Rang a l\'echelle logarithmique')
    plt.ylabel('Effectif des caracteres a l\'echelle logarithmique')
    nom_du_graphe = 'GraphePyplot.png'
    plt.savefig(nom_du_graphe)

#Fonction qui retourne une liste de mots de texte.
def get_list_words(html_unicode) :
  pattern_word = u'[^\s\'"\.¬´¬ª%\?\*;_,\-\+#:‚Äú‚Äù\$‚Ç¨!\(\)\[\]\|/]+'
  pattern_word_compiled = re.compile(pattern_word)
  list_words = pattern_word_compiled.findall(html_unicode)
  return list_words
    
#Fon   
def MotContigus(liste_mots):
  res = []
  liste = CompterOccListe(liste_mots)
  for fen in range(2,(len(liste_mots)/2)):
    for i in range(0,len(liste_mots)-(fen)):
      mot = liste_mots[i: i + fen]
      if Choix_Mots(mot, liste)==False:
	for j in range(i + fen, len(liste_mots) - (fen) ):
	  if liste_mots[j: j+fen]==mot and res.__contains__(mot)==False:
	    res += [mot]
  return res

def CompterOccListe(Liste_Mots):
  res = {}
  for i in Liste_Mots:
    if(res.has_key(i)) :
      res[i] += 1
    else :
      res[i] = 1
  return res

def Choix_Mots(liste,dico):
  for i in liste:
    if dico[i] < 2:
      return True
  return False

def Trier(x, y):
  return len(x)-len(y)

def Reecrire_Source(source):
  res1 = u'<meta http-equiv="Content-Type" content="text/html; charset=utf-8"><p>'
  for i in range(0, len(source) ):
    if source[i]=='#' and source[i-1]==' ':
      res1+=u'</p><p>'
      i+=1
    res1 += source[i]
  res1+=u'</p>'
  return res1

def Colorier_Chaine(s_unicode, chaine) :
  if chaine.__contains__(u'#'):
	return s_unicode
  matching1 = u'<span.+?%s.+?</span>'%(chaine)
  if re.match(matching1, s_unicode)==None:
 	  print 'mots contigus: %s'%(chaine.encode('utf-8'))
	  replace = u' <span style="color:black; background-color:yellow;">%s</span> '%(chaine)
	  output = re.sub(u' %s '%(chaine), replace, s_unicode, re.I | re.M)
  	  return output
  return s_unicode

def TraiterUnFicher(chemin_fichier) :
    encoding_fenetre_output = 'utf-8'   
    source_html = Lire_preparer_fichier(chemin_fichier)
    if titre != '' :     
        print u'titre: \r'.encode(encoding_fenetre_output), \
              u'\t',
        print titre.encode(encoding_fenetre_output)
    else : 
        print u'pas trouve le titre de la fen√™tre'.encode(
            encoding_fenetre_output)
    effectif_de_mot = Compter_les_mots(source_html)
    
    compteur_de_mot = 0
    for j in effectif_de_mot.values():
      compteur_de_mot += j
    
    affiche_mot = 'nombre de mots: %d'%(compteur_de_mot)
    print affiche_mot
    # les mots du dictionnaire du texte sont les cl√©s de effectif_de_mot
    liste_mots_dico = effectif_de_mot.keys()
    print len(liste_mots_dico), \
          u'mots diff√©rents'.encode(encoding_fenetre_output, 'replace')
    print
    liste_mots_dico.sort(key=lambda x: (-effectif_de_mot[x], x))
     # sortir les mots classÈs dans un csv.
    fic=file(chemin_fichier+".csv", "w")
    print >>fic, "Longeur;"+"Effectif;"+" log rang;"+" log effectif;"
    for un_mot_dico in liste_mots_dico:
        print >> fic, str(len(un_mot_dico))+";"+\
              str(effectif_de_mot[un_mot_dico])+";"+\
              str(math.log(len(un_mot_dico)))+";"+\
              str(math.log(effectif_de_mot[un_mot_dico]))+";"+\
              str(un_mot_dico.encode(encoding_fenetre_output, 'replace'))
    fic.close()      
                       
    #Comptage des caracteres et traÁage des graphique pyplot
    Compter_les_char(source_html)
    
    #Mot le plus long du texte
    mot_le_plus_long = max(liste_mots_dico, key=len)
    print 'mot le plus long :', \
          mot_le_plus_long.encode(encoding_fenetre_output, 'replace')
    
    #coloriage des mots contigus
    listemot = get_list_words(source_html)
    Mot = []
    Mot = MotContigus(listemot)
    Mot.sort(Trier)
    fichier_html_sortie = source_html
    for i in Mot:
	  char = Chaine(i)
	  if char.__contains__('#')==False:
	     fichier_html_sortie = Colorier_Chaine(fichier_html_sortie, char)
    fichier_html_sortie = Reecrire_Source(fichier_html_sortie)
    #fin coloriage
    
    #Lance la fonction qui rÈalise le nuage de mots en console.
    NuageMots(liste_mots_dico,effectif_de_mot)
    return fichier_html_sortie
       

#Nuage de mot pertinents sortis en console	   
def NuageMots (liste_mots_dico,effectif_de_mot):
  print "----- Nuage de mots clÈs pertinent ------"
  for i in liste_mots_dico:
    if len(i)>= 6 and effectif_de_mot[i]>=3:
      print i.encode("utf-8", 'replace')
 
    
if __name__ == "__main__":
    
    for chemin_fichier in sys.argv[1:]:
        outputcolor=TraiterUnFicher(chemin_fichier)
        
        nom_file= chemin_fichier.split("/")
        path=""
        for i in range(0,len(nom_file)-1):
	  path=path+nom_file[i]+"/"

        output_color_name =path+'color_%s'%(str(nom_file[-1]))
        EcrireFichierTexte(output_color_name,outputcolor.encode('utf-8'))