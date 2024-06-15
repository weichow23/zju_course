#!/bin/bash
flex cal.l
yacc -d cal.y
gcc lex.yy.c y.tab.c -o calculator -lm
./calculator
rm lex.yy.c y.tab.c y.tab.h
