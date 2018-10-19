%{
	#include "test.tab.h"  // to get the token types from Bison
	int yylval;
%}

%%
"+"			{ return ADD; }
"-"			{ return SUB; }
"*"			{ return MUL; }
"/"			{ return DIV; }
"("			{ return OP; }
")"			{ return CP; }
"\n"			{ return EOL; }
[1-9][0-9]*|[0-9]	{ yylval=atoi(yytext); return NUMBER;}
[a-zA-Z][a-zA-Z0-9]*	{ return *yytext}
[ \t]			{/* skip spaces */}
%%
