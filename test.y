/* simplest version of calculator */
%{
	#include <stdio.h>
	#include <stdlib.h>
	extern int yylex();
	void yyerror(const char *s);
%}


%union {
	int integer_val;
  double real_val;
	char* string_val;
}

/* declare tokens */
%token NUMBER IDENTIFIER
%token ADD SUB MUL DIV OP CP ASSIGN_OP
%token EOL EOF_TOKEN
%token BEGIN_TOKEN END_TOKEN PROGRAM WRITELN
%type<integer_val> list exp factor term statement assignment NUMBER IDENTIFIER

%%
program:
	program_heading block EOF_TOKEN { exit(0);}
program_heading:
	PROGRAM IDENTIFIER EOL
block:
	| BEGIN_TOKEN list END_TOKEN
	;
list:
	statement EOL
	| list statement EOL
	;
statement:
	assignment
	| exp
	;
assignment:
	IDENTIFIER ASSIGN_OP exp { $1 = $3; /*symbol table push */}
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
	| WRITELN OP exp CP { printf("%d\n", $3 );}
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
