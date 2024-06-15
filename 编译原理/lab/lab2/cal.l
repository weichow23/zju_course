%{
#define YYSTYPE struct valType
#include <stdio.h>
#include "y.tab.h"
void yyerror(char *);
struct valType{
    int ival, FloatFlag;
    double dval;
};
%}

FLOATNUM [0-9]*\.[0-9]+
INTNUM	 [0-9]+
%%
{INTNUM}    { sscanf(yytext,"%d",&yylval.ival); \
              yylval.FloatFlag = 1; \
              yylval.dval=yylval.ival; \
              return NUM; }

{FLOATNUM}  { sscanf(yytext,"%lf",&yylval.dval); \
              yylval.FloatFlag = 0; \
              yylval.ival=yylval.dval; \
              return NUM; }

"+"							return ADD;
"-"							return SUB;
"*"							return MUL;
"/"							return DIV;
"^"                         return POW;
"("                         return LP;
")"                         return RP;
\n                          return CR;
<<EOF>>                     return CR;
[ \t]+                     
.
%%
