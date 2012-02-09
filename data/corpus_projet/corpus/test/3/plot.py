# -*- coding: utf-8 -*-
import pylab
from math import log
	
def save_plot ( path, x, y, style, xlabel, ylabel, title ):
	pylab.plot( pylab.array(x),
				pylab.array(y),
				style,
				lw=2 )
				
	pylab.xlabel( xlabel )
	pylab.ylabel( ylabel )
	pylab.title( title )		

	pylab.savefig( "%s.png"%(path), format="png" )
	pylab.gcf().clear()

	
def save_zipf ( path, suf, data, title ):
	"""Sauvegarde le graph sur la loi de zipf en log log"""
	
	save_plot( "%s%s_zipf%s"%( path[0], path[1], suf ),
			   [ log(i) for i in xrange( 1, len(data) + 1 ) ],
			   [ log(i[1]) for i in data ],
			   '-',
			   "log(Rang)",
			   "log(Effectif)",
			   "f(rang) = effectif" )

def save_rangeffectif (path, effectif): 
	"""Sauvegarde le graph sur l'effectif x le rang du mot en log log"""
	
	y = [ log(i[1] * j) for i,j in zip(effectif, xrange(1,len(effectif))) if i[0]!="#" ]
	x = [ log(i) for i in xrange( 1, len(y)+1 ) ]
	
	save_plot( "%s%s_rangeffect"%( path[0], path[1] ),
			   x,
			   y,
			   '-',
			   "log(effectif x rang)",
			   "log(rang)",
			   "f = log(rang du mot x effectif du mot)" )
			   
def save_leneffectif (path, effectif):			   
	"""Sauvegarde le graph longueur par rapport à l'effectif"""			   
	save_plot( "%s%s_leneffect"%( path[0], path[1] ),
			   [ len(i[0]) for i in effectif if i[0]!="#" ],
			   [ i[1] for i in effectif if i[0]!="#" ],
			   'x',
			   "effectif",
			   "longueur",
			   '' )