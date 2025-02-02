SRCC:= ./src/*.c

all: cross_assembler

cross_assembler: src/cross.y src/cross.l src/cross_instructions.c
	yacc -d ./src/cross.y
	lex ./src/cross.l
	gcc lex.yy.c y.tab.c ./src/cross_instructions.c -Isrc -o cross_assembler

run: cross_assembler
	./cross_assembler < cross_input.txt

export_binary: run
	python3 main.py cross_output.txt

clean:
	rm -f lex.yy.c cross_assembler y.tab.h y.tab.c *.o
