#!/usr/bin/env python
# -*- coding: utf-8 -*-

import matplotlib.pyplot as plt
import sys
import math

def TraceGraph(liste_x, liste_y, fpath):

	plt.loglog(liste_x, liste_y, basex=10)
	plt.grid(True)

	plt.xlabel('x')
	plt.ylabel('y = f(x)')

	plt.savefig(fpath)

