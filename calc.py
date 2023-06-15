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

# Miscellaneous operators:

#   PUSH    -- push the top value of the stack onto the stack again, to allow for sub-operations

#***************************************************************************

import sys
import math
import re
import number_recognition

# define a simple stack class for floating point numbers
class FloatingStack:
    def __init__(self):
        self.stack = []

    def push(self, v):
        self.stack.append(v)

    def pop2(self):
        if self.size() < 2:
            raise IndexError('empty stack')
        
        rhs = float(self.stack.pop())
        lhs = float(self.stack.pop())

        return [lhs, rhs]

    def pop(self):
        if self.isEmpty():
            raise IndexError('empty stack')
        
        return float(self.stack.pop())

    def size(self):
        return len(self.stack)

    def isEmpty(self):
        return self.size() == 0

    def __str__(self):
        return str(self.stack)
        
# the math functions
def plus(stack):
    values = stack.pop2()
    lhs = values[0]
    rhs = values[1]
    stack.push(lhs + rhs)

def minus(stack):
    values = stack.pop2()
    lhs = values[0]
    rhs = values[1]
    stack.push(lhs - rhs)

def times(stack):
    values = stack.pop2()
    lhs = values[0]
    rhs = values[1]
    stack.push(lhs * rhs)

def divide(stack):
    values = stack.pop2()
    lhs = values[0]
    rhs = values[1]
    stack.push(lhs / rhs)

def square(stack):
    x = stack.pop()
    stack.push(x * x)

def squareRoot(stack):
    x = stack.pop()
    stack.push(math.sqrt(x))

def power(stack):
    values = stack.pop2()
    lhs = values[0]
    rhs = values[1]
    stack.push(lhs ** rhs)

def inverse(stack):
    x = stack.pop()
    stack.push(1. / x)

def absoluteValue(stack):
    x = stack.pop()
    stack.push(abs(x))

# for example 1 2 + DEG2RAD PUSH SIN would evaluate deg2rad(1 + 2) / sin(deg2rad(1 + 2))
# by pushing the intermediate value (deg2rad(1+2)) to the stack without losing the value
# when the stack is popped for the SIN operation.
def copyTopPush(stack):
    x = stack.pop()
    stack.push(x)
    stack.push(x)

def help(stack):
    print("Possible operators:")

    options = list(opmap.keys())
    sortFunction = lambda o: opmap[o][2] 
    options.sort(key = sortFunction)
    
    for opsym in options:
        print("\t" + opsym + "\t(" + opmap[opsym][1] + ")")

    sys.exit(0)
              
def constE(stack):
    stack.push(math.e)

def constPI(stack):
    stack.push(math.pi)

def radiansToDegrees(stack):  # could be done math.degrees
    x = stack.pop()
    stack.push(math.degrees(x))

def degreesToRadians(stack):  # could be done match.radians
    x = stack.pop()
    stack.push(math.radians(x))

def log(stack):
    x = stack.pop()
    stack.push(math.log(x))

def log10(stack):
    x = stack.pop()
    stack.push(math.log(x, 10))  # python has a function for arbitrary base, unlike perl

def powerE(stack):
    x = stack.pop()
    stack.push(math.exp(x))

def sine(stack):
    x = stack.pop()
    stack.push(math.sin(x))

def cosine(stack):
    x = stack.pop()
    stack.push(math.cos(x))

def tangent(stack):
    x = stack.pop()
    stack.push(math.tan(x))

def cotangent(stack):
    tangent(stack)
    inverse(stack)

def secant(stack):
    cosine(stack)
    inverse(stack)

def arcCosine(stack):
    x = stack.pop()
    stack.push(math.acos(x))

def arcSine(stack):
    x = stack.pop()
    stack.push(math.asin(x))

def arcTangent2(stack):
    values = stack.pop2()
    lhs = values[0]
    rhs = values[1]
    stack.push(math.atan2(lhs, rhs))

def cosecant(stack):
    sine(stack)
    inverse(stack)

def roundToInt(stack):
    x = stack.pop()
    stack.push(round(x))
    
# a stack to hold values being worked on
opstack = FloatingStack()

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
    "ROUND": [ roundToInt, "round to int", 27 ],
    "PUSH": [ copyTopPush, "copy stack top back to stack", 70 ]
}

# iterate over the command line, processing as we go
argCount = len(sys.argv)
for i in range(1, argCount):
    token = sys.argv[i]

    # if this is a number, it must be a value to push to the stack
    if number_recognition.isDecimal(token):
        opstack.push(token)
        continue

    # if we're here, it must be an operator to try to carry it out
    try:
        opfunc = opmap[token][0]
        opfunc(opstack)
    except IndexError:
        print("empty stack")
        sys.exit(1)
        
    except Exception as e:
        print("invalid operator " + token)
        print("OS error: {0}".format(e))
        help(opstack)
        sys.exit(1)

# get the final value off the stack
finalValue = opstack.pop()
print("  Answer = " + str(finalValue))

# sanity check that the stack is empty
if not opstack.isEmpty():
    print("(warning: stack not empty so maybe you missed something)")
    
