#!/usr/local/bin/pythonw
# -*- coding: utf-8 -*-

import os
import sys
import re, string, htmlentitydefs
import csv

def read_file(CheminFichier) :
  f = open(CheminFichier, 'r')
  s = f.read()
  f.close()
  return s

def ecrire_fichier(CheminFichier, s) :
  f = open(CheminFichier, 'w')
  f.write(s)
  f.close()

def extraire_titre(html_unicode) :  # extrait le titre du fichier
  pattcomp = re.compile(u'<title>(.+)<\/title>', re.I)
  trouv_titre = re.search(pattcomp, html_unicode)
  if trouv_titre:
    return trouv_titre.group(1)
  return ''
  
def source2encoding(s) :
  default_encoding = 'iso-8859'
  pattern_detect_encoding = u'<meta.+CONTENT=["\']text/html; ?charset=(.*?)["\']'
  pattern_compiled = re.compile(pattern_detect_encoding, re.I)
  match_charset = re.search(pattern_compiled, s)
  if match_charset :
    encoding = string.lower(match_charset.group(1))
    print 'detected charset ::', encoding.encode('utf-8')
  else :
    encoding = default_encoding
    print 'undetected charset, use default encoding ::', default_encoding
  return encoding

def clean_unicode_html(s_unicode) :
  clean_html = re.sub(u'&nbsp;', ' ', s_unicode)
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


def prepare_file(path_file) :
  chaine_complete = read_file(path_file)
  chaine_encoding = source2encoding(chaine_complete)
  chaine_complete_unicode = unicode(chaine_complete,chaine_encoding)
  chaine_propre = clean_unicode_html(chaine_complete_unicode)
  return chaine_propre

def liste_carac (fuck) :
  carac = u'[^ \'\/_"=«»\#\.\?,;:!\(\)\[\]\|]{1}'
  compil_expression = re.compile(carac)
  liste_caractere = compil_expression.findall (fuck)
  return liste_caractere
  

def liste_mots(fuck) :
  mot = u'[^ \'\/_"=«»\#\.\?,;:!\(\)\[\]\|]+'
  compil_expression = re.compile(mot)
  liste_mot = compil_expression.findall(fuck)
  return liste_mot

def dictionnaire_mot (liste_mot) :
  dic_mot = {}
  for mot in liste_mot :
    if dic_mot.has_key(mot):
      dic_mot[mot] += 1
    else :
      dic_mot[mot] = 1
  return dic_mot


def Trier_dico(dico):
    items = dico.items()
    comparateur = lambda a,b : cmp(a[1],b[1])
    return sorted(items, comparateur, reverse=True)

def calcul_longueur (liste_mot) :
  dic_len = {}
  for mot in liste_mot :
    x = len (mot)
    if dic_len.has_key(x):
      dic_len[x] += 1
    else :
      dic_len[x] = 1
  return dic_len

def mot_contigus (liste_mot) : 
  dic = {}
  for groupe_mot in range (2,10) :
    for mot1 in range(len(liste_mot)) :
      x = liste_mot[mot1]
      for mot2 in range(len(liste_mot)) :
        y = liste_mot[mot2]
        
        if y == x :
          dic[mot2] = liste


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
  csv.write('"mot";'+'"effectif";'+'"rang";'+'"rang*effectif";'+'"longueur";'+"\n")
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
  html_brut = unicode(read_file(CheminFichier),'utf-8')
  fichier_propre=prepare_file(CheminFichier)
  liste = liste_mots(fichier_propre)
  dico = dictionnaire_mot(liste)
  dico_trier = Trier_dico(dico)
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

  s_color = 'the'
  s_color = unicode(s_color,'utf-8')
  chaine_complete_unicode = unicode(read_file(CheminFichier),'utf-8')
  output_color = color_string(chaine_complete_unicode, s_color,'#AA2222')
  
  
  dico_longeur_effectif = longeur_effectif (liste)
  effectif_longeur_trier = Trier_dico(dico_longeur_effectif)
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

  
  
  
