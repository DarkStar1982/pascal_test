/* simplest version of interpreter */
%{
	#include <stdlib.h>
	#include <string>
	#include <iostream>
	#include <unordered_map>
	extern int yylex();
	extern FILE* yyin;
	int get_value(char* name);
	void set_value(char* name, int value);
	void yyerror(const char *s);
	std::unordered_map<std::string, int> symtable;
%}
%union {
	int integer_val;
  double real_val;
	char *string_val;
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
	IDENTIFIER { set_value(yyval.string_val, 0);}
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
	IDENTIFIER ASSIGN_OP exp { $1=$3; set_value(yyval.string_val, $3);/*symbol table push */}
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
	| IDENTIFIER { $$=get_value(yyval.string_val); /*symbol table pop */}
	| OP exp CP { $$ = $2; }
	| WRITELN OP exp CP  { printf("%d\n", $3 );}
	;
%%

int main(int argc, char **argv)
{
// open a file handle to a particular file:
FILE *myfile = fopen("test.pas", "r");
if (!myfile) { return -1; }
yyin = myfile;
yyparse();
return 0;
}

void yyerror(const char *s)
{
	printf("Error: %s\n", s);
}

int get_value(char *name)
{
	std::string std_name = std::string(name);
  if (symtable.find(std_name)==symtable.end())
    return 0;
  else
	 return symtable[std_name];
}

void set_value(char *name, int value)
{
	std::string std_name = std::string(name);
	symtable[std_name]=value;
}
