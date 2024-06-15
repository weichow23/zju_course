%{
#include <stdio.h>
#include <string.h>
#include <math.h>
int yylex(void);
void yyerror(char *);
struct valType{
    int ival, FloatFlag;
    double dval;
};
#define YYSTYPE struct valType
%}


%token ADD SUB MUL DIV CR NUM POW LP RP


%%
exp_list	: CR { return 0; }
			| line exp_list
			;

line		: expression CR	{
								if ($1.FloatFlag == 0) printf("%.2lf\n", $1.dval);
								else printf("%d\n", $1.ival);
							}
			;

expression	: term
			| expression ADD term	{
										$$.dval = $1.dval + $3.dval;
										$$.ival = $1.ival + $3.ival;
										if ($1.FloatFlag == 0 || $3.FloatFlag == 0) $$.FloatFlag = 0;
									}
			| expression SUB term	{
										$$.dval = $1.dval - $3.dval;
										$$.ival = $1.ival - $3.ival;
										if ($1.FloatFlag == 0 || $3.FloatFlag == 0) $$.FloatFlag = 0;
									}
			;

term		: power
			| term MUL power	{
									$$.dval = $1.dval * $3.dval;
									$$.ival = $1.ival * $3.ival;
									if ($1.FloatFlag == 0 || $3.FloatFlag == 0) $$.FloatFlag = 0;
								}
			| term DIV power	{
									$$.dval = $1.dval / $3.dval;
									$$.ival = $1.ival / $3.ival;
									if ($1.FloatFlag == 0 || $3.FloatFlag == 0) $$.FloatFlag = 0;
								}
			;

power		: single
			| term POW single	{
									$$.dval = pow($1.dval, $3.dval);
									$$.ival = pow($1.ival, $3.ival);
									if ($1.FloatFlag == 0 || $3.FloatFlag == 0) $$.FloatFlag = 0;
								}
			;

single		: NUM
			| LP expression RP	{
									$$.ival = $2.ival;
									$$.dval = $2.dval;
									$$.FloatFlag = $2.FloatFlag;
								}
			| SUB term			{
									$$.ival = -$2.ival;
									$$.dval = -$2.dval;
									$$.FloatFlag = $2.FloatFlag;
								}
			;

%%
void yyerror(char *str){
    fprintf(stderr,"error:%s\n",str);
}

int yywrap(){
    return 1;
}
int main()
{
    yyparse();
    return 0;
}
