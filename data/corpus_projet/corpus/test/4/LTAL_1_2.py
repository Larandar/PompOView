#!/usr/bin/python
# -*- coding: utf-8 -*-

import re
import os
import sys

from Boitoutils import NettoyagePreliminaire, DecoderEntites, \
     EcrireFichierTexte, LireFichierTexte, Encoding \
     # , Transcoder_html_unicode_utf8

def Lire_preparer_fichier (chemin_fichier) :
    # lire le fichier html dans une chaîne de caractères unique
    source_html = LireFichierTexte(chemin_fichier) # en encoding original
    # détecter le codage original
    encoding_original = Encoding(source_html)
    # décoder encoding_original --> représentation interne unicode python
    source_html = unicode(source_html, encoding_original, 'replace')
    # supprimer les scripts, sauts de ligne, commentaires, ...
    source_html = NettoyagePreliminaire(source_html)  # en unicode python    
    # décoder les entités  &...; --> représentation interne unicode python
    source_html = DecoderEntites(source_html)
    return source_html

def Extraire_titre (source_html) :
    titre = ''
    # extraction du titre de la fenêtre
    pattcomp = re.compile(u'<title>(.+)<\/title>', re.I)
    trouv_titre = re.search(pattcomp, source_html)
    if trouv_titre:
                titre = trouv_titre.group(1)
    return titre
#varaible global pour stoke les occurences
occurences=0

def Compter_les_mots (source_html) :
    global occurences
    # structure de données : dictionnaire 
    # clé = graphie de mot, donnée = effectif du mot
    effectif_de_mot = {}        # dico vide
    # débaliser : une balise est une macro-ponctuation => on marque sa place
    source_html = re.sub(u'<[^>]+>', u'#', source_html)
    
    # un mot est une suite de caractères contigus non séparateurs (définition
    # négative du mot) dans un mot : ni esp, ni ', ni ponct
    motif_un_mot_compile = re.compile(u'[^ \'"«»\#\.\?,;:!\(\)\[\]\|]+')          
    # constituer la liste des occurrences de mots
    liste_graphies_mots = motif_un_mot_compile.findall(source_html)
    print
    print len(liste_graphies_mots), 'occurrences de mots'
    occurences=len(liste_graphies_mots)
    
    for graphie_mot in liste_graphies_mots :   
        if graphie_mot: 
            # calculer effectifs des mots
            # on vérifie si le mot existe déjà dans le dictionnaire
            if graphie_mot in effectif_de_mot:
                # si oui, on augmente son effectif de 1
                effectif_de_mot[graphie_mot] += 1
            else :
                # si non, on crée la clé avec un effectif initial de 1
                effectif_de_mot[graphie_mot] = 1
            # voici une écriture condensée de l'alternative précédente
            # effectif_de_mot[graphie_mot] = effectif_de_mot.get(graphie_mot,
            #                                                    0) + 1
    return effectif_de_mot
    

def Traitement(chemin_fichier) :    # exemple : Traitement("fr/fr.html")
    global occurences
    encoding_fenetre_output = 'utf-8'         
    
    source_html = Lire_preparer_fichier (chemin_fichier)
    
    # préparer dans source_resultats le source html du fichier de résultats.
    # u => chaines ctes dans la représentation interne Unicode python
    source_resultats = []
    tableur_reslutat = []
    source_resultats.append(u'''<html>\n<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<title>résultats ' + nom_fichier[:2] + u'</title>
</head>\n<body><span style="font-family: monospace;">\n<br>''')
    titre = Extraire_titre(source_html)
    if titre != '' :     
        #print u'titre de la fenêtre : \r'.encode(encoding_fenetre_output), \
        #      u'\t',
       # print titre.encode(encoding_fenetre_output, 'replace')
        source_resultats.append(
            u'titre de la fenêtre : <br>\n&nbsp;&nbsp;%s<br>\n' % titre)
    else : 
      #  print u'pas trouvé le titre de la fenêtre'.encode(
       #     encoding_fenetre_output)
        source_resultats.append(u'pas trouvé le titre de la fenêtre<br>\n')

    # structure de données : dictionnaire 
    # clé = graphie de mot, donnée = effectif du mot         
    effectif_de_mot = Compter_les_mots(source_html)
    
    # les mots du dictionnaire du texte sont les clés de effectif_de_mot
    liste_mots_dico = effectif_de_mot.keys()
    #print len(liste_mots_dico), \u'mots différents'.encode(encoding_fenetre_output, 'replace')

    print occurences/(float(len(liste_mots_dico))),'rapport entre occurences et mots différents'
    
    # classer la liste par effectifs décroissants, et ordre alphabétique
    # croissant si même effectif
    liste_mots_dico.sort(key=lambda x: (-effectif_de_mot[x], x))
    
    # sortir les mots classés
    source_resultats.append(u'<br>\n')
    
    for un_mot_dico in liste_mots_dico:
        effectif_de_mot[un_mot_dico], \
              un_mot_dico.encode(encoding_fenetre_output, 'replace')
        source_resultats.append(u'%i\t%s<br>\n' %
                                (effectif_de_mot[un_mot_dico], un_mot_dico))
        tableur_reslutat.append(u'%i\t%s \t \n' %
                                (effectif_de_mot[un_mot_dico], un_mot_dico))
    source_resultats.append(u'</span></body></html>')
    
    # écrire le source_resultats encodé en utf-8
    source_resultats = ''.join(source_resultats)
    tableur_reslutat = ''.join(tableur_reslutat)

    EcrireFichierTexte(chemin_fichier +'resultat.html',
                       source_resultats.encode('utf-8','replace'))
    a=tableur_reslutat.encode('utf-8','replace')
    l=open(chemin_fichier +'resultat.txt',"w")
    l.write(a)
    l.close()    
    
    # initiation au coloriage du source html
    # sortir le fichier d'origine, avec le mot le plus long colorié
    mot_le_plus_long = max(liste_mots_dico, key=len)
  #  print 'mot_le_plus_long :', \
      #    mot_le_plus_long.encode(encoding_fenetre_output, 'replace')
    
    # placer la feuille de style
    feuille_style = u'''<STYLE type="text/css">
\t<!--\r\t.style_mot_le_plus_long {background: yellow ; color: black}
\t--></STYLE>'''
    source_html_colorie = re.sub(u'<head>', u'<head>\t' + feuille_style,
                                 source_html)
    
    # changer la valeur de l'encoding dans <meta http-equiv --> utf-8
    encoding_original = Encoding(source_html)
    pattcomp = re.compile(u'charset=' + encoding_original, re.I)
    source_html_colorie = pattcomp.sub(u'charset=utf-8', source_html_colorie)
    
    # insérer les balises de coloriage
    source_html_colorie = re.sub(
        mot_le_plus_long,
        u'<span class=style_mot_le_plus_long>%s</span>' % mot_le_plus_long,
        source_html_colorie)
    
    # écrire le source colorié codé en utf-8
    EcrireFichierTexte (chemin_fichier + 'colorie.html',
                        source_html_colorie.encode('utf-8','replace'))
    
    
if __name__ == "__main__":
    
    for chemin_fichier in sys.argv[1:]:
        TraiterUnFicher(chemin_fichier)


