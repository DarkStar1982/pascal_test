#include <iostream>
#include <string>
#include <unordered_map>
#include "runtime.h"
#include "test.tab.h"

using namespace std;

/********************************/
/* symbol table and its methods */
/********************************/
std::unordered_map<std::string, int> symtable;

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
	result->child_count = 0;
	return result;
}

ast_node* create_ast_type_int()
{
	ast_node* result = new ast_node;
	result->node_type = TYPE_INTEGER;
	result->child_count = 0;
	return result;
}

ast_node* create_ast_type_real()
{
	ast_node* result = new ast_node;
	result->node_type = TYPE_REAL;
	result->child_count = 0;
	return result;
}
ast_node* create_ast_node_id_decl(char* value)
{
	ast_node* result = new ast_node;
	result->node_type = IDENTIFIER_DECLARATION;
	result->string_value = value;
	result->child_count = 0;
	return result;
}

ast_node* create_ast_node_writeln(ast_node* node)
{
	ast_node* result = new ast_node;
	result->node_type = WRITELN;
	result->child_count = 1;
	result->children = new ast_node*[1];
	result->children[0] = node;
	return result;
}

ast_node* create_ast_node_super(ast_node* node, int type)
{
	ast_node* result = new ast_node;
	result->node_type = type;
	result->child_count = 1;
	result->children = new ast_node*[1];
	result->children[0] = node;
	return result;
}

ast_node* create_ast_node_super_blank(int type)
{
	ast_node* result = new ast_node;
	result->node_type = type;
	result->child_count = 0;
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
	result->child_count = 2;
	result->children = new ast_node*[2];
	result->children[0] = condition;
	result->children[1] = block_then;
	return result;
}

ast_node* create_ast_node_while(ast_node* condition, ast_node* block_while)
{
	ast_node* result = new ast_node;
	result->node_type = WHILE;
	result->child_count = 2;
	result->children = new ast_node*[2];
	result->children[0] = condition;
	result->children[1] = block_while;
	return result;
}

ast_node* create_ast_node_if_else(ast_node* condition, ast_node* block_then, ast_node* block_else)
{
	ast_node* result = new ast_node;
	result->node_type = IF;
	result->child_count = 3;
	result->children = new ast_node*[3];
	result->children[0] = condition;
	result->children[1] = block_then;
	result->children[2] = block_else;
	return result;
}

ast_node* create_ast_node_program(ast_node* left, ast_node* right)
{
	ast_node* result = new ast_node;
	result->node_type = PROGRAM;
	result->child_count = 2;
	result->children = new ast_node*[2];
	result->children[0] = left;
	result->children[1] = right;
	return result;
}

ast_node* append_child_to_ast_node(ast_node* parent, ast_node* child)
{
	ast_node* result = new ast_node;
	result->node_type = parent->node_type;
	result->string_value = parent->string_value;
	int count = parent->child_count;
	result->children = new ast_node*[count+1];
	for (int i=0;i<count;i++)
	{
		result->children[i] = parent->children[i];
	}
	result->children[count] = child;
	result->child_count = parent->child_count+1;
	return result;
}

/*************************/
/*  Interpreter methods  */
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
