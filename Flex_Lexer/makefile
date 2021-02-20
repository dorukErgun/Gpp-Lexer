gpp_lexer.out: gpp_lexer.c
	gcc gpp_lexer.c -o gpp_lexer.out

gpp_lexer.o: gpp_lexer.o
	gcc gpp_lexer.c


lex.yy.c: gpp_lexer.l
	flex gpp_lexer.l


clean:
	rm -rf *o  gpp_lexer