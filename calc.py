#! /usr/bin/env python3

# python version of my trusty old perl polish notation calculator

#***************************************************************************

# calc - a reverse Polish notation command line calculator.

# DESCRIPTION

# This program will implement a command line calculator.  Arguments and
# operators are entered as separate command line arguments, in reverse
# Polish notation, I<i.e.> the arguments come first, then the operator.
# For example, to add 4 and 5, one would enter

#      4 5 +

# The currently implemented binary operators are

#   + - x / ^

# Implemented unary operators:

#   SQR   -- square of a number
#   SQRT  -- square root of a number
#   INV   -- take the inverse of a number
#   ABS   -- absolute value
#   LN    -- natural log
#   LOG   -- logarithm, base 10
#   EXP   -- exponential (inverse of LN)
#   ROUND -- rounds a floating point number to the nearest integer

# Implemented trigonometric operators:

#   RAD2DEG -- convert radians to degrees
#   DEG2RAD -- convert degrees to radians
#   COS     -- cosine (radians)
#   SIN     -- sine   (radians)
#   TAN     -- tangent(radians)
#   SEC     -- secant (radians)
#   CSC     -- cosecent(radians)
#   CTAN    -- cotangent(radians)
#   ACOS    -- arccosine (result in radians)
#   ASIN    -- arcsine   (result in radians)
#   ATAN2   -- arctangent, 2 arg version (result in radians)

# Implemented constants:

#   PI
#   e

#***************************************************************************

import sys
import math
import re

# if the given value a number
def isNumber(value):
    # this doesn't seem straightforward in python. isnumeric only checks for integers.  But we need to support
    # float as well, not to mention scientific notation. use regexp, similar to my perl NumberRecognition::is_decimal
    # handle scientific notation by stripping off the expoential part
    value = re.sub("[Ee][+-]?\d+\s*$", "", value)
    
    # now the rest
    if re.match("^\s*[+-]?\d*\.?\d+\s*$", value) or \
       re.match("^\s*[+-]?\d+\.?\d*\s*$", value): return True

    # if we're here, not a number
    return False

# wrappers around stack popping functions, to ensure correct casting to types
def pop2(stack):
    rhs = float(stack.pop())
    lhs = float(stack.pop())

    return [lhs, rhs]

def pop(stack):
    return float(stack.pop())

# the math functions
def plus(stack):
    values = pop2(stack)
    lhs = values[0]
    rhs = values[1]
    stack.append(lhs + rhs)

def minus(stack):
    values = pop2(stack)
    lhs = values[0]
    rhs = values[1]
    stack.append(lhs - rhs)

def times(stack):
    values = pop2(stack)
    lhs = values[0]
    rhs = values[1]
    stack.append(lhs * rhs)

def divide(stack):
    values = pop2(stack)
    lhs = values[0]
    rhs = values[1]
    stack.append(lhs / rhs)

def square(stack):
    x = pop(stack)
    stack.append(x * x)

def squareRoot(stack):
    x = pop(stack)
    stack.append(math.sqrt(x))

def power(stack):
    values = pop2(stack)
    lhs = values[0]
    rhs = values[1]
    stack.append(lhs ** rhs)

def inverse(stack):
    x = pop(stack)
    stack.append(1. / x)

def absoluteValue(stack):
    x = pop(stack)
    stack.append(abs(x))

def help(stack):
    print("Possible operators:")

    options = list(opmap.keys())
    sortFunction = lambda o: opmap[o][2] 
    options.sort(key = sortFunction)
    
    for opsym in options:
        print("\t" + opsym + "\t(" + opmap[opsym][1] + ")")

    sys.exit(0)
              
def constE(stack):
    stack.append(math.e)

def constPI(stack):
    stack.append(math.pi)

def radiansToDegrees(stack):  # could be done math.degrees
    x = pop(stack)
    stack.append(math.degrees(x))

def degreesToRadians(stack):  # could be done match.radians
    x = pop(stack)
    stack.append(math.radians(x))

def log(stack):
    x = pop(stack)
    stack.append(math.log(x))

def log10(stack):
    x = pop(stack)
    stack.append(math.log(x, 10))  # python has a function for arbitrary base, unlike perl

def powerE(stack):
    x = pop(stack)
    stack.append(math.exp(x))

def sine(stack):
    x = pop(stack)
    stack.append(math.sin(x))

def cosine(stack):
    x = pop(stack)
    stack.append(math.cos(x))

def tangent(stack):
    x = pop(stack)
    stack.append(math.tan(x))

def cotangent(stack):
    tangent(stack)
    inverse(stack)

def secant(stack):
    cosine(stack)
    inverse(stack)

def arcCosine(stack):
    x = pop(stack)
    stack.append(math.acos(x))

def arcSine(stack):
    x = pop(stack)
    stack.append(math.asin(x))

def arcTangent2(stack):
    values = pop2(stack)
    lhs = values[0]
    rhs = values[1]
    stack.append(math.atan2(lhs, rhs))

def cosecant(stack):
    sine(stack)
    inverse(stack)

def roundToInt(stack):
    x = pop(stack)
    stack.append(round(x))
    
# a stack to hold values being worked on
opstack = []

# map operators to functions that implement them
opmap = {
    "+": [ plus, "addition", 1 ],
    "-": [ minus, "subtraction", 2 ],
    "x": [ times, "multiplication", 3 ],
    "/": [ divide, "division", 4 ],
    "SQR": [ square, "square", 5 ],
    "SQRT": [ squareRoot, "square root", 6 ],
    "^": [ power, "exponentiation", 7 ],
    "INV": [ inverse, "inverse", 8 ],
    "ABS": [ absoluteValue, "absolute value", 9 ],
    "help": [ help, "get help", 0 ],
    "-h": [ help, "get help", 0 ],
    "e": [ constE, "constant e", 51 ],
    "PI": [ constPI, "constant pi", 52 ],
    "RAD2DEG": [ radiansToDegrees, "radians to degrees", 13 ],
    "DEG2RAD": [ degreesToRadians, "degrees to radians", 14 ],
    "LN": [ log, "natural log", 15 ],
    "EXP": [ powerE, "power of e", 16 ],
    "LOG": [ log10, "common log", 17 ],
    "SIN": [ sine, "sine", 18 ],
    "COS": [ cosine, "cosine", 19 ],
    "TAN": [ tangent, "tangent", 20 ],
    "CTAN": [ cotangent, "cotangent", 21 ],
    "SEC": [ secant, "secant", 22 ],
    "CSC": [ cosecant, "cosecant", 23 ],
    "ACOS": [ arcCosine, "arc-cosine", 24 ],
    "ASIN": [ arcSine, "arc-sine", 25 ],
    "ATAN2": [ arcTangent2, "arc-tangent, 2 arg", 26 ],
    "ROUND": [ roundToInt, "round to int", 27 ]
}

# iterate over the command line, processing as we go
argCount = len(sys.argv)
for i in range(1, argCount):
    token = sys.argv[i]

    # if this is a number, it must be a value to push to the stack
    if isNumber(token):
        opstack.append(token)
        continue

    # if we're here, it must be an operator to try to carry it out
    opfunc = opmap[token][0]
    opfunc(opstack)

# get the final value off the stack
finalValue = opstack.pop()
print("  Answer = " + str(finalValue))

    
