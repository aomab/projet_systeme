%{
    #include <stdio.h>
    #include "cross_instructions.h"
    int yylex();
    void yyerror(char*);
    int yydebug = 1;
    extern int yylineno;

    reg_instructions reg_array;
%}

/* Union for yylval */
%union {
    int nb;
}

%token tADD tMUL tSOU tDIV tCOP tAFC
%token <nb> tNB

%%

%start File;

File:
    Instructions;

Instructions:
    /* epsilon */
    | Instructions Instruction
    ;

Instruction:
    tADD tNB tNB tNB
        {
        add_reg_oriented_instructions(&reg_array,LOAD, 1, $3, 0);
        add_reg_oriented_instructions(&reg_array,LOAD, 2, $4, 0);
        add_reg_oriented_instructions(&reg_array,ADD, 3, 1, 2);
        add_reg_oriented_instructions(&reg_array,STORE, $2, 3, 0);
        }
    | tMUL tNB tNB tNB
        {
        add_reg_oriented_instructions(&reg_array,LOAD, 1, $3, 0);
	add_reg_oriented_instructions(&reg_array,LOAD, 2, $4, 0);
	add_reg_oriented_instructions(&reg_array,MUL, 3, 1, 2);
	add_reg_oriented_instructions(&reg_array,STORE, $2, 3, 0);
        }
    | tSOU tNB tNB tNB
        {
        add_reg_oriented_instructions(&reg_array,LOAD, 1, $3, 0);
	add_reg_oriented_instructions(&reg_array,LOAD, 2, $4, 0);
	add_reg_oriented_instructions(&reg_array,SOU, 3, 1, 2);
	add_reg_oriented_instructions(&reg_array,STORE, $2, 3, 0);
        }
    | tDIV tNB tNB tNB
        {
        add_reg_oriented_instructions(&reg_array,LOAD, 1, $3, 0);
	add_reg_oriented_instructions(&reg_array,LOAD, 2, $4, 0);
	add_reg_oriented_instructions(&reg_array,DIV, 3, 1, 2);
	add_reg_oriented_instructions(&reg_array,STORE, $2, 3, 0);
        }
    | tCOP tNB tNB
        {
        add_reg_oriented_instructions(&reg_array,LOAD, 1, $3, 0);
	add_reg_oriented_instructions(&reg_array,STORE, $2, 1, 0);
        }
    | tAFC tNB tNB
        {
	add_reg_oriented_instructions(&reg_array,AFC, 1, $3, 0);
	add_reg_oriented_instructions(&reg_array,STORE, $2, 1, 0);
        }
;


%%

void yyerror(char* str) {
    extern int yylineno;
    fprintf(stderr, "ERROR yyparse : Line %d: %s\n", yylineno, str);
}

int main(int argc, char *argv[]) {
    init_reg_oriented_instructions(&reg_array);
    yyparse();
    printf("INFO yyparse : Parsing End\n");
    output_reg_oriented_instructions(&reg_array);
    return 0;
}

