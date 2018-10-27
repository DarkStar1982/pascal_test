#include "ast.h"
#include "test.tab.h"
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
