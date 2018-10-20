/* simplest version of interpreter */
%{
	#include <stdio.h>
	#include <stdlib.h>
	extern int yylex();
	void yyerror(const char *s);
	int return_value(char* name);
	void set_value(char* name, int value);
%}
%union {
	int integer_val;
  double real_val;
	char* string_val;
}

/* declare tokens */
%token INTEGER REAL IDENTIFIER TYPE_REAL TYPE_INTEGER VAR
%token ADD SUB MUL DIV OP CP ASSIGN_OP COMMA COLON
%token EOL EOF_TOKEN
%token IF THEN ELSE WHILE BEGIN_TOKEN END_TOKEN PROGRAM WRITELN
%type<integer_val>  exp factor term assignment INTEGER IDENTIFIER

%%
program:
	program_heading VAR variable_declaration_list block EOF_TOKEN { exit(0);}
program_heading:
	PROGRAM IDENTIFIER EOL
	;
variable_declaration_list:
	variable_declaration
	| variable_declaration variable_declaration_list
	;
variable_declaration:
	identifier_list COLON type_definition EOL
	;
identifier_list:
	IDENTIFIER
	| IDENTIFIER COMMA identifier_list
	;
type_definition:
	TYPE_INTEGER
	| TYPE_REAL
	;
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
	IDENTIFIER ASSIGN_OP exp { set_value(yylval.string_val, $3); /*symbol table push */}
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
term: INTEGER
	| IDENTIFIER { $$=return_value(yylval.string_val); /*symbol table pop */}
	| OP exp CP { $$ = $2; }
	| WRITELN OP exp CP  { printf("%d\n", $3 );}
	;
%%

int return_value(char* name)
{
	return 22;
}

void set_value(char* name, int value)
{

}
int main(int argc, char **argv)
{
	yyparse();
	return 0;
}

void yyerror(const char *s)
{
	printf("Error: %s\n", s);
}
