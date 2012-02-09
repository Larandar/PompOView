#!/usr/local/bin/pythonw
# -*- coding: utf-8 -*-

import re, string, htmlentitydefs

#tuple -> liste format HTML
def ltuple2ul(l) :
  s = ''
  for t in l :
    i = ''
    for e in t :
      i += '%s '%(e)
    s += '<li>%s</li>'%(i)
  return '<ul>%s</ul>'%s

#liste -> liste format HTML
def list2ul(l) :
  s = ''
  for e in l :
    s += '<li>%s</li>'%(e)
  return '<ul>%s</ul>'%s

#dico -> liste format HTML
def dict2ul(d) :
  s = ''
  for k,e in d.iteritems() :
    s += '<li>%s :: %s</li>'%(str(k),str(e))
  return '<ul>%s</ul>'%s

#Comptage des effectifs récoltés dans un dico
def dict_count(d, k) :
  if(d.has_key(k)) :
    d[k] += 1
  else :
    d[k] = 1

#Lecture totale du fichier dans une variable
def read_file(path_file) :
  f = open(path_file, 'r')
  s = f.read()
  f.close()
  return s

#Ecriture totale d'une variable dans un fichier
def write_file(path_file, s) :
  f = open(path_file, 'w')
  f.write(s)
  f.close()

#detection de l'encoding, normalement
#précisé dans une balise meta
def source2encoding(s) :
  default_encoding = 'iso-8859-1'
  pattern_detect_encoding = u'<meta http-equiv=["\']content-Type["\'][ \n\r]*content=["\']text/html; ?charset=(.*?)["\']'
  pattern_compiled = re.compile(pattern_detect_encoding, re.I)
  match_charset = re.search(pattern_compiled, s)
  if match_charset :
    encoding = string.lower(match_charset.group(1))
    print 'detected charset: ', encoding.encode('utf-8')
  else :
    encoding = default_encoding
    print 'undetected charset, use default encoding: ', default_encoding
  return encoding

#colorie toute les occurences d'une chaîne dans la variable source
def color_string(s_unicode, substring, color) :
  if substring.__contains__(u'#'):
	return s_unicode
  matching1 = u'<span.+?%s.+?</span>'%(substring)
  if re.match(matching1, s_unicode)==None:
 	  print 'color string : %s'%(substring.encode('utf-8'))
	  replace = u' <span style="color:%s; background-color:grey;">%s</span> '%(color, substring)
	  output = re.sub(u' %s '%(substring), replace, s_unicode, re.I | re.M)
  	  return output
  return s_unicode

#débalisation
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

def decode_html_entities(s_unicode) :
  #see :: def replace_num_entities()
  html = re.sub(u'&#([0-9]+);', replace_num_entities, s_unicode)
  pattern = re.compile(u'&([a-z]+);', re.I)
  #see :: def replace_alpha_entities()
  html = pattern.sub(replace_alpha_entities, html)
  return html

def replace_num_entities(matchobj_unicode) :
  if int(matchobj_unicode.group(1)) in range(65535):
    return unichr(int(matchobj_unicode.group(1)))
  else:
    return u'&#%s;'%(matchobj_unicode.group(1))

def replace_alpha_entities(matchobj_unicode) :
  k = matchobj_unicode.group(1)
  if not htmlentitydefs.entitydefs.has_key(k) :
    if k.isupper() :
      k = string.lower(matchobj_unicode.group(1))
      if not htmlentitydefs.entitydefs.has_key(cle) :
        return ''
    else :
      return ''
  if len(htmlentitydefs.entitydefs[k]) == 1 :
    car = htmlentitydefs.entitydefs[k]
    return unicode(car, 'iso-8859-1') #  car est codé en 'iso-8859-1' --> entitydefs[name] = chr(codepoint) dans htmlentitydefs
  else :
    str_code = htmlentitydefs.entitydefs[k].strip(u'&#;')
    return unichr(int(str_code))

