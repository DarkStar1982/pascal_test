#pragma once
typedef struct ast{
  int node_type;
  ast** children;
  int child_count;
  union {
    int integer_value;
    char* string_value;
  };
} ast_node;
