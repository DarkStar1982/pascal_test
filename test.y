/* simplest version of calculator */ 
%{
	#include <stdio.h>
	extern int yylex();
	void yyerror(const char *s);
%}

/* declare tokens */ 
%token NUMBER OP CP
%token ADD SUB MUL DIV
%token EOL

%%

list:
	| list exp EOL  { printf("%d\n", $2 );}
	;
exp: 
	factor
	| exp ADD factor { $$ = $1 + $3; } 
	| exp SUB factor { $$ = $1 - $3; } 
	;
factor: 
	term 
	| factor MUL term { $$ = $1 * $3; } 
	| factor DIV term { $$ = $1 / $3; } 
	;
term: NUMBER
	| OP exp CP { $$ = $2; }
	;
%%

int main(int argc, char **argv)
{
	yyparse();
	return 0;
}

void yyerror(const char *s)
{
	printf("Error: %s\n", s);
}

