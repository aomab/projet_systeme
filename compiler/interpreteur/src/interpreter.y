%{
    #include <stdio.h>
    #include "instructions.h"
    int yylex();
    void yyerror(char*);
    int yydebug = 1;
    extern int yylineno;
%}

/* Union for yylval */
%union {
    int nb;
}

%token tADD tMUL tSOU tDIV tCOP tAFC tJMP tJPF tPRI tRET tCALL
%token tLT tLTE tGT tGTE tEQ tNEQ tAND tOR tNOT
%token tLEA tCOP_LD tCOP_STR
%token tOB tCB
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
        {asm_add_3(ADD, $2, $3, $4);}
    | tMUL tNB tNB tNB
        {asm_add_3(MUL, $2, $3, $4);}
    | tSOU tNB tNB tNB
        {asm_add_3(SOU, $2, $3, $4);}
    | tDIV tNB tNB tNB
        {asm_add_3(DIV, $2, $3, $4);}
    | tCOP tNB tNB
        {asm_add_2(COP, $2, $3);}
    | tAFC tNB tNB
        {asm_add_2(AFC, $2, $3);}
    | tJMP tNB
        {asm_add_1(JMP, $2);}
    | tJPF tNB tNB
        {asm_add_2(JPF, $2, $3);}
    | tLT tNB tNB tNB
        {asm_add_3(LT, $2, $3, $4);}
    | tGT tNB tNB tNB
        {asm_add_3(GT, $2, $3, $4);}
    | tLTE tNB tNB tNB
        {asm_add_3(LTE, $2, $3, $4);}
    | tGTE tNB tNB tNB
    	{asm_add_3(GTE, $2, $3, $4);}
    | tAND tNB tNB tNB
        {asm_add_3(AND, $2, $3, $4);}
    | tOR tNB tNB tNB
    	{asm_add_3(OR, $2, $3, $4);}
    | tEQ tNB tNB tNB
        {asm_add_3(EQ, $2, $3, $4);}
    | tNEQ tNB tNB tNB
        {asm_add_3(NEQ, $2, $3, $4);}
    | tNOT tNB tNB
        {asm_add_2(NOT, $2, $3);}
    | tPRI tNB
        {asm_add_1(PRI, $2);}
    | tLEA tNB tNB
        {asm_add_2(LEA, $2, $3);}
    | tCOP_LD tNB tOB tNB tCB
    	{asm_add_2(COP_LD, $2, $4);}
    | tCOP_STR tOB tNB tCB tNB
        {asm_add_2(COP_STR, $3, $5);}
    | tRET tNB
        {asm_add_1(RET, $2);}
    | tCALL tNB tNB
        {asm_add_2(CALL, $2, $3);}
    ;


%%

void yyerror(char* str) {
    extern int yylineno;
    fprintf(stderr, "ERROR yyparse : Line %d: %s\n", yylineno, str);
}

int main(int argc, char *argv[]) {
    asm_init();
    yyparse();
    printf("INFO yyparse : Parsing End\n");
    asm_run();
    return 0;
}

