#! /usr/bin/env python3

import re

def isDecimal(value):
    # handle scientific notation by stripping off the expoential part
    value = re.sub("[Ee][+-]?\d+\s*$", "", value)
    
    # now the rest
    if re.match("^\s*[+-]?\d*\.?\d+\s*$", value) or \
       re.match("^\s*[+-]?\d+\.?\d*\s*$", value): return True

    # if we're here, not a number
    return False


if __name__ == '__main__':
    tests = [
        [ "1", True ],
        [ "2.3", True ],
        [ "-5", True ],
        [ "1E10", True ],
        [ "joe", False ],
        [ "1.2E-5", True ],
        [ "a123", False ],
        [ "   567", True ],
        [ "1.", True ],
        [ ".1", True ],
        [ "1.tr", False ],
        [ "1.  ", True ],
        [ "  2.  ", True ],
        [ "  -3.2E+15 ", True ],
        [ "+", False ]
    ]

    passedString = { True: "PASSED", False: "FAILED" }

    for test in tests:
        n = test[0]
        expectedResult = test[1]
        result = isDecimal(n)
        passed = expectedResult == result
        print(n + " ==> " + str(result) + " " + passedString[passed] )
        
