minpas.tab.c minpas.tab.h: minpas.y
	bison -d minpas.y

lex.yy.c: minpas.lex minpas.tab.h
	flex minpas.lex

minpas: lex.yy.c minpas.tab.c minpas.tab.h
	g++ minpas.tab.c runtime.c lex.yy.c -ll -o bin/minpas
