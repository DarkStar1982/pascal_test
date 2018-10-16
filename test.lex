%{
#include "test.tab.h"  // to get the token types from Bison

%}

digit		[0-9]
integer		[1-9][0-9]*
program "program"
begin "begin"
end "end"
program_eof "."
identifier ID_[a-zA-Z][a-zA-Z0-9]*

%%
integer|digit	{return INTEGER;}
program	{return PROGRAM;}
begin {return BLOCK_BEGIN;}
end {return BLOCK_END;}
program_eof {return PROGRAM_EOF;}
identifier {return IDENTIFIER;}
%%
