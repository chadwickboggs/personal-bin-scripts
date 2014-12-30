#!/usr/bin/env python

import sys

if (len(sys.argv) == 1):
	line = sys.stdin.readline()
	while line:
		print(line[0:-1])
		line = sys.stdin.readline()
else:
	for arg in sys.argv[1:]:
		print(arg)
