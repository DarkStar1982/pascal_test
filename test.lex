%{
	#include <string.h>
	#include "test.tab.h"  // to get the token types from Bison
%}

%option caseless

ID [a-z][a-z0-9]*

%%
"+"				{ return ADD; }
"-"				{ return SUB; }
"*"				{ return MUL; }
"/"				{ return DIV; }
"("				{ return OP; }
")"				{ return CP; }
";"				{ return EOL; }
","				{ return COMMA;}
":"				{ return COLON;}
"."				{ return EOF_TOKEN; }
"begin" 	{ return BEGIN_TOKEN;}
"end"			{ return END_TOKEN;}
"if"			{ return IF;}
"then"		{ return THEN;}
"else"		{ return ELSE;}
"while"		{ return WHILE;}
"integer"	{ return TYPE_INTEGER;}
"real"		{ return TYPE_REAL;}
"var"		{ return VAR;}
"program" { return PROGRAM;}
":="			{ return ASSIGN_OP;}
"writeln" { return WRITELN;}
[1-9][0-9]*|[0-9]	{ yylval.integer_val=atoi(yytext); return INTEGER;}
{ID}	{ yylval.string_val=(char *) strdup(yytext); return IDENTIFIER;}
[ \t]			{/* skip spaces */}
%%
