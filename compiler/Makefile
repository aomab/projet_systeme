all : compiler

compiler: analyse_lexicale.lex analyse_syntaxique.y table_symboles.c table_fonctions.c
		bison -d -t analyse_syntaxique.y -v
		flex analyse_lexicale.lex
		gcc -w *.c -ly -o compiler

run: compiler
		./compiler < code_c 

clean:
		rm -f lex.yy.c compiler analyse_syntaxique.output analyse_syntaxique.tab.c analyse_syntaxique.tab.h