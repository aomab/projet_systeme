%{ 
#include "analyse_syntaxique.tab.h" 
int yywrap(void){
    return 1;
}

%}




ADD         "+"
SUB         "-"
MUL         "*"
DIV         "/"
tPO         "("
tPF         ")"
tAO         "{"
tAF         "}"
EOL         "\n"
EOI         ";"
SPACE       " "
TAB         "\t"
VIRGULE     ","
AFFECTATION        "="
EQUAL       "=="
LT          "<"
GT          ">"
LTE          "<="
GTE          ">="
tINT        "int"
tMAIN       "main"  
tPRINT      "printf"
tRETURN     "return"
tIF         "if"
tELSE       "else"
tWHILE      "while"
tNOT        "!"
tAND        "&&"
tOR         "||"
tDIFF       "!="
tAPPERSAND  "&"
DIGIT       [0-9]
VARIABLE    [A-Za-z0-9_]+
CONST       "const"
DECIMAL     {DIGIT}+
EXPONENTIEL {DIGIT}+"e"{DIGIT}+
ENTIER      {DECIMAL}
ENTIEREXP   {EXPONENTIEL}
OPERATION   {ADD}|{SUB}|{MUL}|{DIV}
COMPARATEUR {EGAL}|{LT}|{GT}
SEPARATOR   {SPACE}|{TAB}

%%

{ADD}           {return tADD ;}
{SUB}           {return tSUB ;}
{MUL}           {return tMUL ;}
{DIV}           {return tDIV ;}

{tPO}           {return tPO ;}
{tPF}           {return tPF ;}
{tAO}           {return tAO ;}
{tAF}           {return tAF ;}

{EOI}           {return tPV ;}
{SEPARATOR}     {}
{EOL}           {}
{VIRGULE}       {return tVIRGULE ;}

{AFFECTATION}   {return tAFFECTATION ;}

{EQUAL}          {return tEGAL ;}
{tDIFF}          {return tDIFF ;}
{LT}            {return tLT ;}
{GT}            {return tGT ;}
{LTE}           {return tLTE ;}
{GTE}           {return tGTE ;}
{tNOT}           {return tNOT ;}


{tMAIN}         {return tMAIN ;}
{tINT}          {return tINT ;}
{tPRINT}        {return tPRINT ;}
{tRETURN}       {return tRETURN ;}

{tOR}           {return tOR ;}
{tAND}          {return tAND ;}

{tIF}           {return tIF ;}
{tELSE}         {return tELSE ;}
{tWHILE}        {return tWHILE ;}

{tAPPERSAND}    {return tAPPERSAND;}
{CONST}         {return tCONST ;}
{ENTIER}        {yylval.nombre = atoi(yytext); return tENTIER ;}
{ENTIEREXP}     {yylval.nombre = -1; return tENTIEREXP;}
{VARIABLE}      {strcpy(yylval.id, yytext); return tVAR  ;}

%%

//int main(void){
//    yylex();
//}


