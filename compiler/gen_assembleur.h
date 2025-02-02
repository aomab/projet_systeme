#ifndef GEN_ASSEMBLEUR_H
#define GEN_ASSEMBLEUR_H

#define INSTRUCTION_TABLE_SIZE 1000

#include "table_symboles.h"

enum operation{ADD, SOU, MUL, DIV, COP, AFC, RET, JMF, JMP, EQ, NEQ, LT, GT, LTE,
        GTE, AND, OR, NOT, PRI, LEA, COP_LD, COP_STR, CALL, RET_FUN};

typedef struct instruction{
    enum operation operation;
    int reg1;
    int reg2;
    int reg3;
}instruction;

//table des instructions
typedef struct instructions_array{
    instruction array[INSTRUCTION_TABLE_SIZE];
    int index;
} instructions_array;

/**
 *
 * @param op operation
 * @return returns the string that corresponds to the enum operation op
 */
char * operationName(enum operation op);

/**
 * Initialises the instructions array
 * @param array
 */
void initialise_asm(instructions_array * array);

//renvoie l'index (ou valeur?) de la premiere @ dispo
/**
 * Fetch address of a temporary variable
 * @param table
 * @return first available temp address
 */
int new_temp(Table_Symboles * table);

/**
 * Adds intruction to instruction array
 * @param array
 * @param intru
 * @return 0 if instruction was added successfully, -1 if not
 */
int add_instruction(instructions_array * array, instruction * intru);

/**
 * Generates intruction with no parameter
 * @param array
 * @param op
 * @return
 */
int generate_instruction_0(instructions_array * array, enum operation op);

/**
 * Generates intruction with one parameter
 * @param array
 * @param op
 * @param arg1
 * @return
 */
int generate_instruction_1(instructions_array * array, enum operation op, int arg1);

/**
 * Generates intruction with two parameters
 * @param array
 * @param op
 * @param arg1
 * @param arg2
 * @return
 */
int generate_instruction_2(instructions_array * array, enum operation op, int arg1, int arg2);

/**
 * Generates intruction with three parameters
 * @param array
 * @param op
 * @param arg1
 * @param arg2
 * @param arg3
 * @return
 */
int generate_instruction_3(instructions_array * array, enum operation op, int arg1, int arg2, int arg3);

/**
 * Updates the JMF instruction with the correct jump destination address
 * @param array
 * @param instru_index
 * @param adr_jmp
 */
void update_jmf(instructions_array * array, int instru_index, int adr_jmp);

void update_jmp(instructions_array * array, int instru_index, int adr_jmp);




void exportInstructions(instructions_array * array);

/*
void gen_arithmetique(instructions_array * array, enum operation op, int arg1, int arg2);

int gen_var(Table_Symboles * table, instructions_array * array, char * varName);

int gen_entier(Table_Symboles * table, instructions_array * array, int entier);

int gen_return(Table_Symboles * table, instructions_array * array, int adr);

int gen_jmpf(Table_Symboles * table, instructions_array * array, int cond, int dest);

int gen_condition(Table_Symboles * table, instructions_array * array, enum operation op, int arg1, int arg2);

int gen_print(Table_Symboles * table, instructions_array * array, int arg1);
 */
#endif