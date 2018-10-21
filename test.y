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
	/* symtable */
	int get_value(char* name);
	void set_value(char* name, int value);

	/* AST */
	ast_node* create_ast_node_int(int value);
	ast_node* create_ast_node_id(char* value);
	ast_node* create_ast_node_op(ast_node* left, int type, ast_node* right);
	ast_node* create_ast_node_assign(char* value, ast_node* right);
	ast_node*	create_ast_node_writeln(ast_node* node);
	ast_node* create_ast_node_if(ast_node* condition, ast_node* block_then);
	ast_node* create_ast_node_if_else(ast_node* condition, ast_node* block_then, ast_node* block_else);
	void append_child_to_ast_node(ast_node* parent, ast_node* child);
	/* interpeter */
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
%type<ast_value> term factor exp bool_exp assignment if_statement list block statement program
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
	| BEGIN_TOKEN list END_TOKEN {$$=$2;}
	;
list:
	statement EOL {$$=$1;}
	| list statement EOL {append_child_to_ast_node($1, $2);}
	| list if_statement	{append_child_to_ast_node($1, $2);}
	;
if_statement:
	IF bool_exp THEN block {$$=create_ast_node_if($2, $4)}
	| IF bool_exp THEN block ELSE block {$$=create_ast_node_if_else($2, $4, $6)}
	;
statement:
	assignment {$$=$1}
	| exp {$$=$1}
	| WRITELN OP exp CP {$$=create_ast_node_writeln($3)}
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
/*   AST tree methods   */
/************************/

ast_node* create_ast_node_int(int value)
{
	ast_node* result = new ast_node;
	result->node_type = INTEGER;
	result->integer_value = value;
	return result;
}

ast_node* create_ast_node_writeln(ast_node* node)
{
	ast_node* result = new ast_node;
	result->node_type = WRITELN;
	result->child_count = 1;
	result->children = new ast_node*[1];
	result->children[0] = node;
	tree_root = result;
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
	return result;
}


ast_node* create_ast_node_if(ast_node* condition, ast_node* block_then)
{
	ast_node* result = new ast_node;
	result->node_type = IF;
	result->child_count = 1;
	result->children = new ast_node*[1];
	result->children[0] = block_then;
	return result;
}

ast_node* create_ast_node_if_else(ast_node* condition, ast_node* block_then, ast_node* block_else)
{
	ast_node* result = new ast_node;
	result->node_type = IF;
	result->child_count = 2;
	result->children = new ast_node*[1];
	result->children[0] = block_then;
	result->children[1] = block_else;
	tree_root = result;
	return result;
}


void append_child_to_ast_node(ast_node* parent, ast_node* child)
{
	parent->child_count++;
	ast_node** new_array = new ast_node*[parent->child_count];
	for (int i=0;i<parent->child_count-1;i++)
	{
		new_array[i] = parent->children[i];
	}
	new_array[parent->child_count-1] = child;
	parent->children = new_array;
}

/*************************/
/* Interpreter execution */
/*************************/
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
