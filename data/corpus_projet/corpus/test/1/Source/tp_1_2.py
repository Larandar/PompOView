#!/usr/local/bin/pythonw
# -*- coding: utf-8 -*-

import re
import sys
import chardet

import tool_ltal as tl
import cnt_char as cc
import nuage
import graph

def get_header_html(titre) :
  s = '''
  <html>
    <head>
      <meta http-equiv="Content-Type"
            content="text/html; charset=utf-8">
      <title>%s</title>
    </head>
    <body>
  '''%titre
  return s

def get_footer_html() :
  s = '''
    </body>
  </html>
  '''
  return s

def prepare_file(src_html) :
  encoding_detected = tl.source2encoding(src_html)
  apiDetect = chardet.detect( src_html )

  print 'Verification de l\'API: %s'%(apiDetect['encoding'].upper())
  src_html_unicode = unicode(src_html,encoding_detected)
  src_html_unicode = tl.clean_unicode_html(src_html_unicode)
  src_html_unicode = tl.decode_html_entities(src_html_unicode)
  return src_html_unicode, encoding_detected

def extract_title(html_unicode) :
  pattcomp = re.compile(u'<title>(.+)</title>', re.I)
  trouv_titre = re.search(pattcomp, html_unicode)
  if trouv_titre:
    return trouv_titre.group(1)
  return ''

def get_list_words(html_unicode) :
  pattern_word = u'[^\s\'"\.«»%\?\*;_,\-\+#:“”\$€!\(\)\[\]\|/]+'
  pattern_word_compiled = re.compile(pattern_word)
  list_words = pattern_word_compiled.findall(html_unicode)
  return list_words

def list_words2dict_effectif(list_words_unicode) :
  dict_effectif = {}
  for graphie in list_words_unicode :
    tl.dict_count(dict_effectif, graphie)
  return dict_effectif

def dict_effectif2distrib_zipf(dict_effectif) :
  l = []
  for graphie,effectif in dict_effectif.iteritems() :
    l.append(effectif)
  l = sorted(l, reverse=True)
  return l

def cmpval(x,y) :
    return y[1] - x[1]

def RatioWord( upe ):
	nb_mot, nb_mot_diff = 0.00, 0.00
	for m in upe:
		nb_mot += m[1]
		nb_mot_diff +=1
	if nb_mot_diff==0.00:
		tx = 0.00
	else:
		tx = float(nb_mot / nb_mot_diff )
	return nb_mot_diff, nb_mot, tx


def main(path_file) :
  src_html_brut = tl.read_file(path_file)
  src_html_unicode, encoding_detected = prepare_file(src_html_brut)
  src_html_brut = unicode(src_html_brut, encoding_detected)
  title_detected = extract_title( src_html_brut )

  if title_detected != '' :
    str_t = '%s'%(title_detected)
  else :
    str_t = 'nop'

  l = get_list_words(src_html_unicode)
  d = list_words2dict_effectif(l)
  z = dict_effectif2distrib_zipf(d)

  #Coloriage
  print 'Recherche des occurences en cours...'
  Occ = []
  Occ = cc.SameString( l )
  Occ.sort( cc.StackSort )
  output_color = src_html_unicode
  for cur in Occ:
	cur_str = cc.list2str( cur )
	if cur_str.__contains__('#')==False:
		output_color = tl.color_string(output_color, cur_str, 'blue')
  output_color = cc.RebaliseMyHTML(output_color)
  #Coloriage


  it = d.items()
  it.sort(cmpval)

  print 'Occurences trouvées: %d'%( len(Occ) )
  print '%d mots différents pour %d mots -> rapport de %.2f'%(RatioWord(it))

  #Loi de ZIPF sur les mots
  # X = Rang, Y = Eff.
  l_y = z
  l_x = range(0, len(l_y) )
  fpath_zipf_word = '%s.png'%(path_file)
  graph.TraceGraph(l_x, l_y, fpath_zipf_word)


  #Longueur des mots et effectifs en
  #Nuage de points en CSV
  csvFile = '%s.stat.csv'%(path_file)
  cc.ExportTuple2CSV(csvFile, it)


  #Loi de ZIPF sur les caractères
  # X = Rang, Y = Eff.
  char_dic = cc.CharCounter( src_html_unicode )
  c_count = char_dic.values()
  c_count.sort()
  c_count.reverse()
  graph.TraceGraph(range(0, len(c_count)), c_count, fpath_zipf_word)
  #Exporter en courbe


  #Composition du Nuage de mots-clés
  #pertinents du document
  contenu = nuage.Nuage( it )
  nuage.ExportNuageHTML( contenu, path_file )


  #Exportation HTML de la
  #Liste des effectifs des mots
  str_z = tl.ltuple2ul(it)
  str_h = get_header_html(str_t)
  str_f = get_footer_html()
  output_color = '%s %s %s'%(str_h, output_color, str_f)
  output_zipf = '%s %s %s %s'%(str_h, str_t, str_z, str_f)

  return output_zipf,output_color


if __name__=='__main__' :
  path_file = sys.argv[1]
  outputzipf, outputcolor = main(path_file)

 
  
  nomfichier=path_file.split("/")
  chemin=""
  for i in range(0,len(nomfichier)-1):
    chemin=chemin+nomfichier[i]+"/"
  
  outputzipf_utf8 = outputzipf.encode('utf-8')
  out_name = chemin+'/color_%s'%(str(nomfichier[-1]))
  tl.write_file(out_name ,outputzipf_utf8)

  out_color_name = chemin+'/color_%s'%(str(nomfichier[-1]))
  outputcolor_utf8 = outputcolor.encode('utf-8')
  tl.write_file(out_color_name,outputcolor_utf8)

