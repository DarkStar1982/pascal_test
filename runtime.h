/* AST data structure*/
typedef struct ast{
  int node_type;
  ast** children;
  int child_count;
  union {
    int integer_value;
    char* string_value;
  };
} ast_node;

/* AST tree methods */
ast_node* create_ast_node_int(int value);
ast_node* create_ast_node_id(char* value);
ast_node* create_ast_node_op(ast_node* left, int type, ast_node* right);
ast_node* create_ast_node_assign(char* value, ast_node* right);
ast_node* create_ast_node_writeln(ast_node* node);
ast_node* create_ast_node_if(ast_node* condition, ast_node* block_then);
ast_node* create_ast_node_while(ast_node* condition, ast_node* block_while);
ast_node* create_ast_node_if_else(ast_node* condition, ast_node* block_then, ast_node* block_else);
ast_node* append_child_to_ast_node(ast_node* parent, ast_node* child);
ast_node* create_ast_node_super(ast_node* node, int type);
ast_node* create_ast_type_int();
ast_node* create_ast_type_real();
ast_node* create_ast_node_id_decl(char* value);
ast_node* create_ast_node_program(ast_node* left, ast_node* right);
ast_node* create_ast_node_super_blank(int type);

/* symbol table methods */
int get_value(char* name);
void set_value(char* name, int value);

/* interpeter methods */
void evaluate(ast_node*);
int eval_expression(ast_node* node);
