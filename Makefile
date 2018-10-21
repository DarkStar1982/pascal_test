test.tab.c test.tab.h: test.y
	bison -d test.y

lex.yy.c: test.lex test.tab.h
	flex test.lex

test: lex.yy.c test.tab.c test.tab.h
	clang++ test.tab.c lex.yy.c -ll -o test
