%{
	#include <stdio.h>
	extern int yylex();
	extern int yyparse();

	void yyerror(const char *s);
%}

%token INTEGER
%token IDENTIFIER
%token BLOCK_BEGIN
%token BLOCK_END
%token PROGRAM
%token PROGRAM_EOF

%%
program:
	program_heading program_block|term PROGRAM_EOF
program_heading:
	PROGRAM IDENTIFIER;
program_block:
	BLOCK_BEGIN BLOCK_END
term:
	INTEGER|IDENTIFIER;

%%

void yyerror(const char *s)
{
	printf ("Error: %s\n", s);
}

int main(void) {
	yyparse();
	return 0;
}
