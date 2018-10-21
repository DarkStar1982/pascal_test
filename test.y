/* simplest version of interpreter */
%{
	#include <stdlib.h>
	#include <string>
	#include <iostream>
	#include <list>
	#include <unordered_map>
	#include "ast.h"

	using namespace std;

	extern int yylex();
	extern FILE* yyin;
	extern int linenumber;
	void yyerror(const char* s);
	int get_value(char* name);
	void set_value(char* name, int value);
	ast_node* create_ast_node_int(int value);
	ast_node* create_ast_node_id(char* value);
	ast_node* create_ast_node_op(ast_node* left, int type, ast_node* right);
	ast_node* create_ast_node_assign(char* value, ast_node* right);

	void evaluate(ast_node*);

	unordered_map<string, int> symtable;

	ast_node* tree_root;

%}

%union {
	int integer_val;
	bool logic_val;
  double real_val;
	char* string_val;
	ast_node* ast_value;
}

/* declare tokens */
%token REAL TYPE_REAL TYPE_INTEGER VAR GT LS
%token<integer_val> INTEGER
%token<string_val> IDENTIFIER

%token ADD SUB MUL DIV OP CP ASSIGN_OP COMMA COLON LOGIC_OP
%token EOL EOF_TOKEN
%token IF THEN ELSE WHILE BEGIN_TOKEN END_TOKEN PROGRAM WRITELN
%type<ast_value> term factor exp bool_exp assignment statement program
%%
program:
	program_heading VAR variable_declaration_list block EOF_TOKEN { evaluate(tree_root); exit(0);}
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
	| list if_statement
	;
if_statement:
	IF bool_exp THEN block
	| IF bool_exp THEN block ELSE block
	;
statement:
	assignment
	| exp {$$=$1}
	| WRITELN OP exp CP
	;
assignment:
	IDENTIFIER ASSIGN_OP exp {$$ = create_ast_node_assign($1,$3)}
bool_exp:
	exp {$$=$1}
	| exp GT exp {$$=create_ast_node_op($1, GT, $3);}
	| exp LS exp {$$=create_ast_node_op($1, LS, $3);}
	;
exp:
	factor {$$=$1}
	| exp ADD factor {$$=create_ast_node_op($1, ADD, $3);}
	| exp SUB factor {$$=create_ast_node_op($1, SUB, $3);}
	;
factor:
	term {$$=$1}
	| factor MUL term {$$=create_ast_node_op($1, MUL, $3);}
	| factor DIV term {$$=create_ast_node_op($1, DIV, $3);}
	;
term: INTEGER {$$=create_ast_node_int($1)}
	| IDENTIFIER {$$=create_ast_node_id($1)}
	| OP exp CP {$$=$2}
	;
%%

int main(int argc, char **argv)
{
	char *filepath;
	if (argc>0)
	{
		FILE *myfile = fopen(argv[1], "r");
		if (!myfile) { return -1; }
		yyin = myfile;
		yyparse();
	}
	return 0;
}

void yyerror(const char *s)
{
	printf("Line %i: %s\n", linenumber, s);
}

/************************/
/* symbol table methods */
/************************/
int get_value(char *name)
{
	string std_name = string(name);
  if (symtable.find(std_name)==symtable.end())
    return 0;
  else
	 return symtable[std_name];
}

void set_value(char *name, int value)
{
	string std_name = string(name);
	symtable[std_name]=value;
}

/************************/
/* AST tree methods */
/************************/

ast_node* create_ast_node_int(int value)
{
	ast_node* result = new ast_node;
	result->node_type = INTEGER;
	result->integer_value = value;
	return result;
}

ast_node* create_ast_node_id(char* value)
{
	ast_node* result = new ast_node;
	result->node_type = IDENTIFIER;
	result->string_value = value;
	result->child_count = 0;
	return result;
}

ast_node* create_ast_node_op(ast_node* left, int type, ast_node* right)
{
	ast_node* result = new ast_node;
	result->node_type = type;
	result->children = new ast_node*[2];
	result->children[0]=left;
	result->children[1]=right;
	result->child_count = 2;
	tree_root = result;
	return result;
}

ast_node* create_ast_node_assign(char* value, ast_node* right)
{
	ast_node* result = new ast_node;
	result->node_type = ASSIGN_OP;
	result->string_value = value;
	result->child_count = 1;
	result->children = new ast_node*[1];
	result->children[0] = right;
	tree_root = result;
	return result;
}

void evaluate(ast_node* node)
{
	int *x = &node->node_type;
	int *count = &node->child_count;
	for (int i=0;i<(*count);i++)
	{
		evaluate(node->children[i]);
	}
	printf("%d\n",*x);
	printf("%d\n",*count);
	//cout<<"A test"<<endl;
}
