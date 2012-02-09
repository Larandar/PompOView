#!/usr/local/bin/pythonw
# -*- coding: utf-8 -*-


import os
import sys
import re, string, htmlentitydefs
import csv





def preparer_fichier(path_file):

    chaine_complete=fichier(path_file)
    chaine_encoding=encoding(chaine_complete)
    chaine_complete_unicode=unicode_chaine(chaine_complete,chaine_encoding)
    chaine_propre=clean_file(chaine_complete_unicode)
    return chaine_propre







def fichier(file):
    f=open(file, 'r')
    chaine_complete=f.read()
    f.close()
    return chaine_complete

def ecrire_fichier(CheminFichier, s) :
  f = open(CheminFichier, 'w')
  f.write(s)
  f.close()


def encoding(chaine):
    encoding_defaut='iso-8859-1'
    encoding_pattern= u'<meta http-equiv=["\']content-Type["\'][ \n\r]*content=["\']text/html; ?charset=(.*?)["\']'
    encoding_compile= re.compile(encoding_pattern,re.I)
    encoding_search=re.search(encoding_compile, chaine)

    if encoding_search:
        encoding=encoding_search.group(1)
        encoding.encode('utf-8')

    else:
        encoding=encoding_defaut
    return encoding


def unicode_chaine(chaine,encoding):
    return unicode(chaine,encoding)



def clean_file(chaine_unicode):

    clean_html = re.sub(u'&nbsp;', ' ', chaine_unicode)
    clean_html = re.sub(u'[\s]+', u' ', clean_html)

    pattern1 = re.compile(u'<script.+?</script>', re.I | re.M)
    clean_html = pattern1.sub(u'', clean_html)

    pattern2 = re.compile(u'<!\-\-.+?\-\->', re.M)
    clean_html = pattern2.sub(u'', clean_html)

    pattern3 = re.compile(u'<select.+?</select>', re.I | re.M)
    clean_html = pattern3.sub(u'', clean_html)

    pattern4 = re.compile(u'<style.+?</style>', re.I | re.M)
    clean_html = pattern4.sub(u'', clean_html)

    clean_html = re.sub(u'(?:&gt;|&lt;)', u' ', clean_html)

    pattern5 = re.compile(u'[\s]*</*[^>]+/*>[\s]*', re.I | re.M)
    clean_html = pattern5.sub(u' # ', clean_html)

    pattern6 = re.compile(u'\s[#\s]+', re.I | re.M)
    clean_html = pattern6.sub(u' # ', clean_html)

    return clean_html

def extraire_titre(html_unicode) :
  pattcomp = re.compile(u'<title>(.+)<\/title>', re.I)
  trouv_titre = re.search(pattcomp, html_unicode)
  if trouv_titre:
    return trouv_titre.group(1)
  return ''


def debaliser(chaine_unicode):
    chaine_final= re.sub(u'<[^>]+>', u'#', chaine)
    return chaine_final


def extraire_mot(chaine):
    
    mot_pattern=u'[^\s\'&"._?;,:!\(\)\[\]\|\/%={}<>\?#]+'
    mot_compile=re.compile(mot_pattern)
    liste_mot=mot_compile.findall(chaine)
    return liste_mot

def extraire_caract(chaine):
    
    carac_pattern=u'[^\s\'&"._?;,:!\(\)\[\]\|\/%={}<>\?#]{1}'
    carac_compile=re.compile(carac_pattern)
    liste_carac=carac_compile.findall(chaine)
    return liste_carac



def comptage_mot(liste_mot):

    dic={}
    
    for mot in liste_mot:
        if mot in dic:
            dic[mot]+=1

        else:
            dic[mot]=1

    return dic


def triage_mot(dic):

    items=dic.items()
    comparateur=lambda a,b : cmp(a[1],b[1])
    return sorted(items,comparateur, reverse=True)


def longueur_mot(liste_mot):

    dico_long={}

    for mot in liste_mot:
        if len(mot) in dico_long:
            dico_long[len(mot)]+= 1

        else:
            dico_long[len(mot)]=1

    return dico_long



##def mot_contigus(liste_mot):
##
##    fen1=[]
##    fen2=[]
##    fen_temp1=[liste_mot[0]]
##    fen_temp2=[liste_mot[0]]
##    for i in range (1,len(liste_mot)):
##        fen1=[fen_temp1,liste_mot[i]]
##        fen2=[fen_temp2,liste_mot[i]]
##        fen_temp1=fen1
##        fen_temp2=fen2
##        #print(str(fen1)+"-------1------")
##        #print(str(fen2)+"-------2------")
## 
##        for x in range (1,len(liste_mot)):
##
##            fen1=fen1+[liste_mot[x]]
##            del fen1[0]
##            print(str(fen1)+"-------1------")
##            
##            for y in range(x+1,len(liste_mot)):
##                fen2=fen2+[liste_mot[y]]
##                del fen2[0]
##                print(str(fen2)+"-------2------")
##                if fen1==fen2:
##                    print("lol")
    

    

def ltuple2ul(l) :
  s = ''
  for t in l :
    i = ''
    for e in t :
      i += '%s '%(e)
    s += '<li>%s</li>'%(i)
  return '<ul>%s</ul>'%s

def color_string(s_unicode, substring, color) :
  print 'color string : %s'%(substring.encode('utf-8'))
  pattern1 = re.compile(u'%s'%(substring), re.I | re.M)
  replace = u'<span style="color:%s; background-color:grey;">%s</span>'%(color, substring)
  output = pattern1.sub(replace, s_unicode)
  return output

def CSV (liste) :
  nom_fichier = 'donnees.csv'
  csv = open(nom_fichier, "w")
  csv.write('"mot";','"effectif";','"rang";','"rang*effectif",','"longueur";',"\n")
  counteur = 1
  for tupple in liste :
    csv.write('"'+tupple[0].encode("utf-8")+'"'+";")
    csv.write('"'+str(tupple[1]).encode("utf-8")+'"'+";")
    csv.write('"'+str(counteur)+'"'+";")
    csv.write('"'+str(counteur*tupple[1])+'"'+";")
    csv.write('"'+str(len(tupple[0]))+'"'+";"+"\n")
    counteur+=1
  
      
def longeur_effectif (liste) :
  dic ={}
  for i in range (len(liste)):
    longeur = len(liste[i])
    if dic.has_key(longeur) :
      dic[longeur] += 1
    else :
      dic[longeur] = 1
  return dic





def main (CheminFichier) :
  html_brut = unicode(fichier(CheminFichier),'utf-8')
  fichier_propre=preparer_fichier(CheminFichier)
  liste = extraire_mot(fichier_propre)
  dico = comptage_mot(liste)
  dico_trier = triage_mot(dico)
  titre_detecte = extraire_titre(html_brut)
  if titre_detecte != '' :
    str_t = '<p>%s</p>'%(titre_detecte)
  else :
    str_t = '<p>nop</p>'

  it = dico.items()
  def cmpval(x,y) :
    return y[1] - x[1]
  it.sort(cmpval)

  str_z = ltuple2ul(it)

  output_zipf = '%s %s'%(str_t,str_z)

  s_color = 'red'
  s_color = unicode(s_color,'utf-8')
  chaine_complete_unicode = unicode(fichier(CheminFichier),'utf-8')
  output_color = color_string(chaine_complete_unicode, s_color,'#AA2222')
  
  
  dico_longeur_effectif = longeur_effectif (liste)
  effectif_longeur_trier = triage_mot(dico_longeur_effectif)
  csv_effectif_longeur = CSV (dico_trier)
  
  
  
  return output_zipf , output_color
                      

if __name__ == '__main__' :
  CheminFichier = sys.argv[1]
  outputzipf,outputcolor = main(CheminFichier)
  

  outputzipf_utf8 = outputzipf.encode('utf-8')
  head='''<html>\n<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
</head>'''
  ecrire_fichier('out_zipf.html',head+outputzipf_utf8)

  
  outputcolor_utf8 = outputcolor.encode('utf-8')
  ecrire_fichier('color.html',outputcolor_utf8)



