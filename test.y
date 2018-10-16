%{
	#include <stdio.h>
	extern int yylex();
	extern int yyparse();

	void yyerror(const char *s);
%}

%token INTEGER
%token VARIABLE
%token BLOCK_BEGIN
%token BLOCK_END
%token PROGRAM

%%
program:
	PROGRAM VARIABLE block
	|
	;
block:
	BLOCK_BEGIN BLOCK_END
	| BLOCK_BEGIN term BLOCK_END
term:
	INTEGER
	| VARIABLE	
	;

%%

void yyerror(const char *s)
{
	printf ("Error: %s\n", s);
}

int main(void) {
	yyparse();
	return 0;
}

