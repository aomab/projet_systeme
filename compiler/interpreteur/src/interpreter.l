%{
    #include "y.tab.h"
%}

vSEP    [ \t\r\n]

%%

ADD {return tADD;}
MUL {return tMUL;}
SOU {return tSOU;}
DIV {return tDIV;}
COP {return tCOP;}
AFC {return tAFC;}
JMP {return tJMP;}
JPF {return tJPF;}
LT {return tLT;}
LTE {return tLTE;}
GT {return tGT;}
GTE {return tGTE;}
EQ {return tEQ;}
NEQ {return tNEQ;}
PRI {return tPRI;}
AND {return tAND;}
OR {return tOR;}
NOT {return tNOT;}
RET {return tRET;}
LEA {return tLEA;}
COP_LD {return tCOP_LD;}
COP_STR {return tCOP_STR;}
CALL {return tCALL;}

"[" {return tOB;}
"]" {return tCB;}


-?[0-9]+  {
        yylval.nb = atoi(yytext);
        return tNB;
        }


{vSEP}  {}

.       {
        fprintf(stderr, "ERROR lex : Unknown pattern %s", yytext);
        exit(1);
        }

%%

int yywrap(void) { return 1; }
//int main(int argc, char *argv[]) { while (yylex()!=0) ; return 0; }
