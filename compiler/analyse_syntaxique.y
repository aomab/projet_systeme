%union {
int nombre;
char id[30];
}

%{
#include <stdio.h>
#include "table_symboles.h"
#include "table_fonctions.h"
#include "gen_assembleur.h"

enum Initialised_Variable init;
enum Symbole_Type type;
enum Return_Type return_type;
Table_Symboles table;
Table_Fonctions table_fonctions;
instructions_array array;
int whileCondition;
int return_value;
%}


%token<nombre> tENTIER
%token<nombre> tENTIEREXP

%type<nombre> E
%type<nombre> Return Instructions
%type<nombre> Cond
%type<nombre> While Else Invocation


%token tADD
%token tSUB
%token tMUL
%token tDIV

%token<nombre> tPO
%token tPF
%token tAO
%token tAF

%token tERROR

%token tAPPERSAND
%token tPV
%token tVIRGULE
%token tAFFECTATION
%token tEGAL
%token tDIFF
%token tLT
%token tGT
%token tGTE
%token tLTE
%token tMAIN
%token tINT
%token tPRINT
%token tRETURN
%token tOR
%token tAND
%token<nombre> tIF
%token tELSE
%token<nombre> tWHILE
%token tCONST
%token<id> tVAR
%token tNOT

%left tADD
%left tSUB
%left tMUL
%left tDIV
%right tEGAL


%%

/*C : Fonctions Main ;

Fonctions : ;
Fonctions : Fonction Fonctions ;

Fonction : tINT tVAR tPO Params tPF Body;*/

C : {generate_instruction_1(&array, JMP, -1);} Fonctions;

Fonctions: Main;
Fonctions: Fonction Fonctions;


Main : tINT tMAIN {update_jmp(&array, 0, array.index); add_function(&table_fonctions, "Main", RET_INT, array.index); table.depth++;} tPO Params tPF Body {print_table(&table);remove_symboles(&table); table.depth--;};
Fonction : Function_type tVAR {{add_function(&table_fonctions, $2, return_type, array.index); table.depth++;}} tPO Params tPF Body {print_table(&table);remove_symboles(&table); table.depth--;};

Function_type: tINT {type = TYPE_INT;} ;
Function_type: tINT tMUL {type = TYPE_INT_PTR;};

Params : {} ;
Params : Param SuiteParams ;

Param : Param_type tVAR {add_symbole_top(&table, $2, type, INITIALISED, table.depth);} ;

Param_type: tINT {type = TYPE_INT;} ;
Param_type: tINT tMUL {type = TYPE_INT_PTR;};

SuiteParams : tVIRGULE Param SuiteParams ;
SuiteParams : ;


Body : tAO Instructions Return tAF {} ;

Instructions : Instruction Instructions {$$ = array.index;};
Instructions : {$$ = array.index;};

Instruction : Aff ;
Instruction : If ;
Instruction : While ;
Instruction : Print ;
Instruction : Decl ;
Instruction : Invocation tPV ;

Decl : Type Valeur SuiteDecl tPV ;

SuiteDecl: tVIRGULE Valeur SuiteDecl ;
SuiteDecl: ;

Type : tINT {type = TYPE_INT;} ;
Type : tCONST tINT {type = TYPE_CONST_INT;} ;
Type : tINT tMUL {type = TYPE_INT_PTR;};

Valeur : tVAR {add_symbole_top(&table, $1, type, INITIALISED, table.depth);} tAFFECTATION E {int varAddr = variable_exists(&table, $1); generate_instruction_2(&array, COP, varAddr, $4); free_temp(&table);};
Valeur : tVAR {add_symbole_top(&table, $1, type, NOT_INITIALISED, table.depth);};


Aff : tVAR tAFFECTATION E tPV {int varAddr = variable_exists(&table, $1); generate_instruction_2(&array, COP, varAddr, $3); free_temp(&table); };
Aff : tMUL tVAR tAFFECTATION E tPV {int varAddr = variable_exists(&table, $2); generate_instruction_2(&array, COP_STR, varAddr, $4); free_temp(&table); };


E : tENTIER {int vt = new_temp(&table); generate_instruction_2(&array, AFC, vt, $1); $$ = vt;};
E : tVAR {int vt = new_temp(&table); int varAddr = variable_exists(&table, $1); generate_instruction_2(&array, COP, vt, varAddr); $$ = vt;};
E : E tADD E {generate_instruction_3(&array, ADD, $1, $1, $3); free_temp(&table); $$ = $1;} ;
E : E tMUL E {generate_instruction_3(&array, MUL, $1, $1, $3); free_temp(&table); $$ = $1;}  ;
E : E tSUB E {generate_instruction_3(&array, SOU, $1, $1, $3); free_temp(&table); $$ = $1;} ;
E : E tDIV E {generate_instruction_3(&array, DIV, $1, $1, $3); free_temp(&table); $$ = $1;} ;
E : tSUB E {} ;
E : Invocation {
	//int vt = new_temp(&table);
	//generate_instruction_2(&array, COP, vt, $1);
	remove_symboles(&table);
	table.depth--;
	$$ = $1;};
E : tPO E tPF {$$ = $2; } ;
E : tAPPERSAND tVAR {int vt = new_temp(&table); int varAddr = variable_exists(&table, $2); generate_instruction_2(&array, LEA, vt, varAddr); $$ = vt;};
E : tMUL tVAR {int vt = new_temp(&table); int varAddr = variable_exists(&table, $2); generate_instruction_2(&array, COP, vt, varAddr); generate_instruction_2(&array, COP_LD, vt, vt); $$ = vt;};


If : tIF tPO Cond tPF {
    generate_instruction_2(&array, JMF, $3, -1);
    free_temp(&table);
    $1 = array.index;
}
tAO {table.depth++;} Instructions {generate_instruction_1(&array, JMP, -1);} tAF {remove_symboles(&table); table.depth--;}
{
    int adr_jmp = array.index;
    update_jmf(&array, $1, adr_jmp);
}
Else {update_jmp(&array, $8, $13);};

Else : tELSE tAO {table.depth++;} Instructions tAF {remove_symboles(&table); table.depth--;} {$$ = array.index;} ;
Else : {$$ = array.index;};
Else : tELSE If {$$ = array.index;} ;

While : tWHILE tPO {
	$2 = array.index ;
} Cond tPF {
	generate_instruction_2(&array, JMF, $4, -1);
	free_temp(&table);
	$1 = array.index;
}
tAO {table.depth++;} Instructions tAF {remove_symboles(&table); table.depth--;} {
	generate_instruction_1(&array, JMP, $2);
	int adr_jmp = array.index;
	update_jmf(&array, $1, adr_jmp);
};

Cond : E tEGAL E {generate_instruction_3(&array, EQ, $1, $1, $3); free_temp(&table); $$ = $1;};
Cond : E tDIFF E {generate_instruction_3(&array, NEQ, $1, $1, $3); free_temp(&table); $$ = $1;} ;
Cond : E tLT E {generate_instruction_3(&array, LT, $1, $1, $3); free_temp(&table); $$ = $1;} ;
Cond : E tGT E {generate_instruction_3(&array, GT, $1, $1, $3); free_temp(&table); $$ = $1;} ;
Cond : E tLTE E {generate_instruction_3(&array, LTE, $1, $1, $3); free_temp(&table); $$ = $1;} ;
Cond : E tGTE E {generate_instruction_3(&array, GTE, $1, $1, $3); free_temp(&table); $$ = $1;} ;
Cond : E tAND E {generate_instruction_3(&array, AND, $1, $1, $3); free_temp(&table); $$ = $1;} ;
Cond : E tOR E {generate_instruction_3(&array, OR, $1, $1, $3); free_temp(&table); $$ = $1;} ;
Cond : tNOT Cond {generate_instruction_2(&array, NOT, $2, $2); $$ = $2;} ;
Cond : E {$$ = $1; };

Invocation : tVAR tPO {table.depth++; prepare_function_call(&table); return_value = (table.indexAvailableBottom);} Args  tPF
	{int function_index = function_exists(&table_fonctions, $1);
	int jmp_addr = (table_fonctions.array[function_index]).start_addr;
	generate_instruction_2(&array, CALL, jmp_addr, table.indexAvailableTop-1);
	$$ = return_value;
	};

Args : Arg SuiteArgs ;
Args :
Arg : E {int arg_addr = prepare_argument_push(&table); generate_instruction_2(&array, COP, arg_addr, $1); free_temp(&table);};
SuiteArgs : tVIRGULE Arg SuiteArgs ;
SuiteArgs : ;

Print : tPRINT tPO E tPF tPV {generate_instruction_1(&array, PRI, $3); free_temp(&table);};

Return : tRETURN E tPV {$$ = generate_instruction_1(&array, RET, $2); free_temp(&table);};

%%
#include <stdio.h>
void main(void){
    //TODO: rajouter gestion des erreurs
    initialise_table(&table);
    initialise_function_table(&table_fonctions);
    initialise_asm(&array);
    yyparse();
    print_table(&table);
    printf("\n");
    print_fonction_table(&table_fonctions);

    //remove_symboles(&table, 0);
    //print_table(&table);
    exportInstructions(&array);
}

