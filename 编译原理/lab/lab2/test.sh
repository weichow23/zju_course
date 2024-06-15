#!/bin/bash
# Compile
flex cal.l
yacc -d cal.y
gcc lex.yy.c y.tab.c -o calculator -lm

while IFS= read -r line; do
    # Ignore empty lines and lines starting with #
    if [[ -n $line && $line != "#"* ]]; then
        # Display the test case
        echo "Test case: $line"
        # result of the test case
        echo "$line" | ./calculator
    fi
done < test.txt

rm lex.yy.c y.tab.c y.tab.h