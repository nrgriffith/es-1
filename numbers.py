#!/usr/bin/env python
from itertools import permutations

numbers = range(2,255)
tolerance = 1
goal = 2525000-8

for a,b,c in permutations(numbers,3):
    equation = 3 + (3 + (3 + 4*a)*b)*c
    if equation >= (goal - tolerance) and equation <= (goal+tolerance):
        print "r25=", a, " r24=", b, " r23=", c, " Yield", equation, "cycles"

print "done"
