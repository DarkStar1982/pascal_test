%{
#include "test.tab.h"  // to get the token types from Bison

%}

digit		[0-9]
identifier	[a-zA-Z][a-zA-Z0-9]*
integer		[1-9][0-9]*
%%
integer|digit	return INTEGER;
"program"	return PROGRAM;

%%
