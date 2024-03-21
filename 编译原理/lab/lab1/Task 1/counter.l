%option noyywrap
%{
	int LineNum = 1, CharNum = 0, WordNum = 0, wordaccept = 1;
%}
wordChar	[0-9a-zA-Z]
otherChar	[^{wordChar}]

%%
\n	{
	LineNum++; 
	CharNum++; 
	if (wordaccept)
		WordNum++;
	wordaccept = 0;
}	
{wordChar}	{
			CharNum++;
			if (wordaccept)
				WordNum++;
			wordaccept = 0;
}
{otherChar}	CharNum++; wordaccept = 1;

%%
int main() {
	yylex();
	printf("There have %d chars\n %d words\n %d lines\n", CharNum, WordNum, LineNum);
	return 0;
}