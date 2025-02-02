#include "gen_assembleur.h"
#include <stdio.h>
#include <stdlib.h>

char * operationName(enum operation op){
    switch(op){
        case EQ:
            return "EQ";
        case NEQ:
            return "NEQ";
        case LT:
            return "LT";
        case GT:
            return "GT";
        case LTE:
            return "LTE";
        case GTE:
            return "GTE";
        case ADD:
            return "ADD";
        case SOU:
            return "SOU";
        case DIV:
            return "DIV";
        case MUL:
            return "MUL";
        case COP:
            return "COP";
        case AFC:
            return "AFC";
        case RET:
            return "RET";
        case JMF:
            return "JPF";
        case JMP:
            return "JMP";
        case AND:
            return "AND";
        case OR:
            return "OR";
        case NOT:
            return "NOT";
        case PRI:
            return "PRI";
        case LEA:
            return "LEA";
        case COP_LD:
            return "COP_LD";
        case COP_STR:
            return "COP_STR";
        case RET_FUN:
            return "RET_FUN";
        case CALL:
            return "CALL";
        default:
            break;
    }
    return "";
}

void initialise_asm(instructions_array * array){
    array->index = 0;
}

int add_instruction(instructions_array * array, instruction * instru){
    if (array->index >= INSTRUCTION_TABLE_SIZE){
        return 1;
    }
    array->array[array->index] = *instru;
    array->index++;

    return 0;
}

int new_temp(Table_Symboles * table){
    int ret_addr ;
    if(add_symbole_bottom(table) == -1) {
        return -1;
    }
    ret_addr = table->indexAvailableBottom + 1;
    return ret_addr;
}

int generate_instruction_0(instructions_array * array, enum operation op){
    instruction instru;
    char * opName = operationName(op);

    instru.operation = op;

    printf("%d\t %s\n", array->index, opName);

    if (add_instruction(array, &instru) != 0){
        //TODO: Error handling
        exit(1);
    }

    return 0;
}

int generate_instruction_1(instructions_array * array, enum operation op, int arg1){
    instruction instru;
    char * opName = operationName(op);

    instru.operation = op;
    instru.reg1 = arg1;

    printf("%d\t %s %d\n", array->index, opName, instru.reg1);

    if (add_instruction(array, &instru) != 0){
        //TODO: Error handling
        exit(1);
    }

    return 0;
}

int generate_instruction_2(instructions_array * array, enum operation op, int arg1, int arg2){
    instruction instru;
    char * opName = operationName(op);

    instru.operation = op;
    instru.reg1 = arg1;
    instru.reg2 = arg2;

    printf("%d\t %s %d %d\n", array->index, opName, instru.reg1, instru.reg2);

    if (add_instruction(array, &instru) != 0){
        //TODO: Error handling
        exit(1);
    }

    return 0;
}

int generate_instruction_3(instructions_array * array, enum operation op, int arg1, int arg2, int arg3){
    instruction instru;
    char * opName = operationName(op);

    instru.operation = op;
    instru.reg1 = arg1;
    instru.reg2 = arg2;
    instru.reg3 = arg3;

    printf("%d\t %s %d %d %d\n", array->index, opName, instru.reg1, instru.reg2, instru.reg3);

    if (add_instruction(array, &instru) != 0){
        //TODO: Error handling
        exit(1);
    }

    return 0;
}

void update_jmf(instructions_array * array, int instru_index, int adr_jmp){
    array->array[instru_index - 1].reg2 = adr_jmp;
    printf("%d\t JMP %d %d\n",  (instru_index - 1), array->array[instru_index].reg1, array->array[instru_index].reg2);
}

void update_jmp(instructions_array * array, int instru_index, int adr_jmp){
    array->array[instru_index].reg1 = adr_jmp;
    printf("%d\t JMP %d\n",  (instru_index - 1), array->array[instru_index].reg1);
}

void exportInstructions(instructions_array * array){
    FILE *file;
    file = fopen("memory_oriented_assembly.txt", "w");
    instruction instru;
    enum operation op;

    for (int i = 0; i < array->index; i++){
        instru = array->array[i];
        op = instru.operation;
        switch (op) {
            //0 parameters
            case RET_FUN:
                fprintf(file, "%s\n", operationName(op));
                break;
            //1 parameter
            case JMP:
            case PRI:
            case RET:
                fprintf(file, "%s %d\n", operationName(op), instru.reg1);
                break;
            //2 parameters
            case JMF:
            case NOT:
            case AFC:
            case COP:
            case LEA:
            case CALL:
                fprintf(file, "%s %d %d\n", operationName(op), instru.reg1, instru.reg2);
                break;
            case COP_LD:
                fprintf(file, "%s %d [%d]\n", operationName(op), instru.reg1, instru.reg2);
                break;
            case COP_STR:
                fprintf(file, "%s [%d] %d\n", operationName(op), instru.reg1, instru.reg2);
                break;
            //3 parameters
            case ADD:
            case SOU:
            case DIV:
            case MUL:
            case AND:
            case OR:
            case EQ:
            case NEQ:
            case LT:
            case LTE:
            case GT:
            case GTE:
                fprintf(file, "%s %d %d %d\n", operationName(op), instru.reg1, instru.reg2, instru.reg3);
                break;
            default:
                break;
        }
    }

    fclose(file);
}

/*int gen_print(Table_Symboles * table, instructions_array * array, int arg1){
    instruction instru;
    instru.operation = PRI;
    instru.reg1 = arg1;

    printf("%d\t PRI %d\n",  array->index, instru.reg1);

    if (array->index < INSTRUCTION_TABLE_SIZE){
        array->array[array->index] = instru;
        array->index++;
    }

    free_temp(table);
}*/

/*void gen_arithmetique(instructions_array * array, enum operation op, int arg1, int arg2){
    instruction instru;
    instru.reg1 = arg1;
    instru.reg2 = arg1;
    instru.reg3 = arg2;

    char * opName = operationName(op);
    printf("%d\t %s %d %d %d\n", array->index, opName, arg1, arg1, arg2);

    if (array->index < INSTRUCTION_TABLE_SIZE){
        array->array[array->index] = instru;
        array->index++;
    }

}

int gen_var(Table_Symboles * table, instructions_array * array, char * varName){
    int vt = new_temp(table);
    int varAddr = variable_exists(table, varName);

    //vérifier que non null
    instruction instru;
    instru.operation = COP;
    instru.reg1 = vt;
    instru.reg2 = varAddr;

    printf("%d\t COP %d %d\n",  array->index, vt, varAddr);

    if (array->index < INSTRUCTION_TABLE_SIZE){
        array->array[array->index] = instru;
        array->index++;
    }

    return vt;

}

int gen_entier(Table_Symboles * table, instructions_array * array, int entier){
    int vt = new_temp(table);

    //vérifier que non null
    instruction instru;
    instru.operation = AFC;
    instru.reg1 = vt;
    instru.reg2 = entier;

    printf("%d\t AFC %d %d\n",  array->index, vt, entier);

    if (array->index < INSTRUCTION_TABLE_SIZE){
        array->array[array->index] = instru;
        array->index++;
    }

    return vt;
}

int gen_condition(Table_Symboles * table, instructions_array * array, enum operation op,  int arg1, int arg2){

    char * opName = operationName(op);

    instruction instru;
    instru.operation = op;
    instru.reg1 = arg1;
    instru.reg2 = arg1;
    if (op != NOT){
        instru.reg3 = arg2;
        printf("%d\t %s %d %d %d\n", array->index, opName, instru.reg1, instru.reg2, instru.reg3);
        free_temp(table);
    } else {
        printf("%d\t %s %d %d \n", array->index, opName, instru.reg1, instru.reg2);
    }

    if (array->index < INSTRUCTION_TABLE_SIZE){
        array->array[array->index] = instru;
        array->index++;
    }

    return instru.reg1;
}

int gen_return(Table_Symboles * table, instructions_array * array, int adr){

    //vérifier que non null
    instruction instru;
    instru.operation = RET;
    instru.reg1 = adr;

    printf("%d\t RET %d\n",  array->index, adr);

    if (array->index < INSTRUCTION_TABLE_SIZE){
        array->array[array->index] = instru;
        array->index++;
    }

    //free_temp(table);

    return adr;
}

int gen_jmpf(Table_Symboles * table, instructions_array * array, int cond, int dest){
       //vérifier que non null
    instruction instru;
    instru.operation = JMF;
    instru.reg1 = cond;
    instru.reg2 = dest;

    printf("%d\t JMPF %d %d\n",  array->index, instru.reg1 , instru.reg2);

    if (array->index < INSTRUCTION_TABLE_SIZE){
        array->array[array->index] = instru;
        array->index++;
    }

    //free_temp(table);

    return cond;
}

 */


