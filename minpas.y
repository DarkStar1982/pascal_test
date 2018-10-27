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

	/* symbol table */
	unordered_map<string, int> symtable;
	int get_value(char* name);
	void set_value(char* name, int value);

	/* interpeter itself */
	void evaluate(ast_node*);
	int eval_expression(ast_node* node);

	ast_node* tree_root;
	int xxx =  0;

%}

%union {
	int integer_val;
	bool logic_val;
  double real_val;
	char* string_val;
	ast_node* ast_value;
}

/* declare tokens */
%token REAL TYPE_REAL TYPE_INTEGER VAR GT LS EQ NEQ
%token<integer_val> INTEGER
%token<string_val> IDENTIFIER
%token ADD SUB MUL DIV OP CP ASSIGN_OP COMMA COLON LOGIC_OP
%token EOL EOF_TOKEN
%token IF THEN ELSE WHILE DO BEGIN_TOKEN END_TOKEN PROGRAM WRITELN

%token IDENTIFIER_DECLARATION LIST VAR_DEC ID_LIST/* pseudotokens to mark AST node types */

%type<ast_value> term factor exp bool_exp assignment if_statement list variable_declaration while_statement
%type<ast_value> block type_definition identifier_list statement variable_declaration_list if_statement_long if_statement_short program
%%
program:
	program_heading VAR variable_declaration_list block EOF_TOKEN {
	 	tree_root = create_ast_node_program ($3, $4);
		evaluate(tree_root); exit(0);
		}
program_heading:
	PROGRAM IDENTIFIER EOL /* not really matters */
	;
variable_declaration_list:
	variable_declaration { $$=$1;}
	| variable_declaration variable_declaration_list {$$=append_child_to_ast_node($2, $1);}
	;
variable_declaration:
	identifier_list COLON type_definition EOL { $$=$1;}
	;
identifier_list:
	IDENTIFIER {
		$$=create_ast_node_super_blank(ID_LIST);
		$$=append_child_to_ast_node($$ ,create_ast_node_id_decl($1));
		}
	| IDENTIFIER COMMA identifier_list { $$=append_child_to_ast_node($3, create_ast_node_id_decl($1));}
	;
type_definition:
	TYPE_INTEGER {$$ = create_ast_type_int();}
	| TYPE_REAL {$$ = create_ast_type_real();}
	;
block:
	BEGIN_TOKEN list END_TOKEN {$$=$2;}
	;
list:
	statement EOL {$$=create_ast_node_super($1, LIST);}
	| list statement EOL {$$=append_child_to_ast_node($$, $2);}
	| list if_statement {$$=append_child_to_ast_node($$, $2);}
	| list while_statement {$$=append_child_to_ast_node($$, $2);}
	;
while_statement:
	WHILE bool_exp DO block {$$=create_ast_node_while($2, $4);}
	;
if_statement:
	if_statement_short {$$=$1}
	| if_statement_long {$$=$1}

if_statement_short:
	IF bool_exp THEN block {$$=create_ast_node_if($2, $4)}
	| IF bool_exp THEN statement EOL {$$=create_ast_node_if($2, $4)}

if_statement_long:
	IF bool_exp THEN block ELSE block {$$=create_ast_node_if_else($2, $4, $6)}
	| IF bool_exp THEN statement EOL ELSE block {$$=create_ast_node_if_else($2, $4, $7)}
	| IF bool_exp THEN block ELSE statement EOL {$$=create_ast_node_if_else($2, $4, $6)}
	| IF bool_exp THEN statement EOL ELSE statement EOL {$$=create_ast_node_if_else($2, $4, $7)}
	;
statement:
	assignment {$$=$1}
	| exp {$$=$1}
	| WRITELN OP exp CP {$$=create_ast_node_writeln($3)}
	;
assignment:
	IDENTIFIER ASSIGN_OP exp {$$ = create_ast_node_assign($1,$3)}
bool_exp:
	exp {$$=$1;}
	| exp GT exp {$$=create_ast_node_op($1, GT, $3);}
	| exp LS exp {$$=create_ast_node_op($1, LS, $3);}
	| exp EQ exp {$$=create_ast_node_op($1, EQ, $3);}
	| exp NEQ exp {$$=create_ast_node_op($1, NEQ, $3);}
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

/*************************/
/* Interpreter execution */
/*************************/
void evaluate(ast_node* node)
{
	int type = node->node_type;
	int count = node->child_count;
	int eval_value=0;

	switch (type)
	{
		case IDENTIFIER_DECLARATION:
			set_value(node->string_value,0);
			break;
		case WRITELN:
			eval_value = eval_expression(node->children[0]);
			cout<<"Writing to output:"<<eval_value<<endl;
			break;
		case ASSIGN_OP:
			eval_value = eval_expression(node->children[0]);
			set_value(node->string_value,eval_value);
			break;
		case IF:
			eval_value = eval_expression(node->children[0]);
			if (eval_value==1)
				evaluate(node->children[1]);
			else
				if (node->child_count>2) evaluate(node->children[2]);
			break;
		case WHILE:
			while (eval_expression(node->children[0])==1)
			{
				evaluate(node->children[1]);
			};
			break;
		case PROGRAM:
			for (int i=0;i<count;i++) /* left to right */
			{
				evaluate(node->children[i]);
			}
			break;
		case LIST:
			for (int i=0;i<count;i++) /* left to right */
			{
				evaluate(node->children[i]);
			}
			break;
	}
}

int eval_expression(ast_node* node)
{
	int result=0;
	switch (node->node_type)
	{
		case INTEGER:
			return node->integer_value;
		case IDENTIFIER:
			result = get_value(node->string_value);
			return result;
		case MUL:
			result = eval_expression(node->children[0])*eval_expression(node->children[1]);
			return result;
		case DIV:
			result = eval_expression(node->children[0])/eval_expression(node->children[1]);
			return result;
		case ADD:
			result = eval_expression(node->children[0])+eval_expression(node->children[1]);
			return result;
		case SUB:
			result = eval_expression(node->children[0])-eval_expression(node->children[1]);
			return result;
		case GT:
			if (eval_expression(node->children[0])>eval_expression(node->children[1]))
				return 1;
			else return 0;
		case LS:
			if (eval_expression(node->children[0])<eval_expression(node->children[1]))
				return 1;
			else return 0;
		case EQ:
			if (eval_expression(node->children[0])==eval_expression(node->children[1]))
				return 1;
			else return 0;
		case NEQ:
			if (eval_expression(node->children[0])!=eval_expression(node->children[1]))
				return 1;
			else return 0;
	}
	return result;
}
