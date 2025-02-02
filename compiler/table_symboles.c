#include "table_symboles.h"
#include <stdio.h>
#include <string.h>


void initialise_table(Table_Symboles * table){
    table->indexAvailableBottom = TABLE_SIZE - 1;
    table->indexAvailableTop = 0;
    table->depth = 0;
}

int variable_exists(Table_Symboles * table, char * varName){
    for (int i = 0; i < table->indexAvailableTop; i++){
        if (strcmp(varName, table->array[i].Variable_Name) == 0){
            return i;
        }
    }

    for (int i = (table->indexAvailableBottom + 1); i < TABLE_SIZE; i++){
        if (strcmp(varName, table->array[i].Variable_Name) == 0){
            return i;
        }
    }
    return 0;
}
int add_symbole_top(Table_Symboles * table, char * varName, enum Symbole_Type type, enum Initialised_Variable init, int depth){
    Symbole symbole;
    strcpy(symbole.Variable_Name, varName);
    symbole.addr = table->indexAvailableTop;
    symbole.init = init;
    symbole.type = type;
    symbole.symbole_depth = table->depth;
    if (table->indexAvailableTop >= table->indexAvailableBottom){
        return -1;
    } else if (variable_exists(table, varName) != 0){
        return -2;
    } else {
        table->array[table->indexAvailableTop] = symbole;
        table->indexAvailableTop++;
    }
    return 0;
}

int add_symbole_bottom(Table_Symboles * table){
    Symbole symbole;
    symbole.addr = table->indexAvailableBottom;
    //symbole.symbole_depth = -1;
    if (table->indexAvailableTop >= table->indexAvailableBottom){
        return -1;
    } else {
        table->array[table->indexAvailableBottom] = symbole;
        table->indexAvailableBottom--;
    }
    return 0;
}

int remove_symboles(Table_Symboles * table){
    if (table->indexAvailableTop > 0){
        while(table->indexAvailableTop > 0){
            if (table->array[table->indexAvailableTop-1].symbole_depth == table->depth){
                table->indexAvailableTop--;
            } else {
                break;
            }

        }
    }


        //TODO: vérifier qu'il n'y a pas de varaibles temporarires au moment de changement de profondeur
    return 0;
}

void free_temp(Table_Symboles * table){
    table->indexAvailableBottom++;
    if (table->indexAvailableBottom >= TABLE_SIZE){
        printf("Huge error\n");
        table->indexAvailableBottom--;
    }
}

int prepare_function_call(Table_Symboles * table){
    prepare_argument_push(table);
    prepare_argument_push(table);
}

int prepare_argument_push(Table_Symboles * table){
    Symbole symbole;
    symbole.addr = table->indexAvailableTop;
    symbole.symbole_depth = table->depth;
    if (table->indexAvailableTop < table->indexAvailableBottom){
        table->array[table->indexAvailableTop] = symbole;
        table->indexAvailableTop++;
        return (table->indexAvailableTop) - 1 ;
    }

}

int initialise_symbole(Table_Symboles * table, char * varName){
    int index = variable_exists(table, varName);
    if (index == -1){
        return -1;
    } else {
        table->array[index].init = INITIALISED;
    }
}

void print_symbole(Symbole * symbole){
    char * var = symbole->Variable_Name;
    int addr = symbole->addr;
    enum Symbole_Type type = symbole->type;
    char typeStr[20];
    if (type == TYPE_INT){
        strcpy(typeStr, "INT");
    } else if (type == TYPE_CONST_INT){
        strcpy(typeStr, "CONST_INT");
    } else if (type == TYPE_INT_PTR) {
        strcpy(typeStr, "INT_PTR");
    } else {
        strcpy(typeStr, "Error type");
    }
    enum Initialised_Variable init = symbole->init;
    char initStr[20];
    if (init == INITIALISED){
        strcpy(initStr,"INITIALISED");
    } else{
        strcpy(initStr,"NOT_INITIALISED");
    }
    int depth = symbole->symbole_depth;
    printf("%-20s\t\t %-12s\t\t %-12d\t %-20s\t %-12d\n", var, typeStr, addr, initStr, depth);
}

void print_table(Table_Symboles * table){
    printf("%-20s\t\t %-12s\t\t %-12s\t %-20s\t %-12s\n", "Variable Name", "Type", "Address", "Initialised", "Depth");
    int indexTop = table->indexAvailableTop;
    int indexBottom = table->indexAvailableBottom;
    Symbole symbole;
    for (int i = 0; i < indexTop; i++){
        symbole = table->array[i];
        print_symbole(&symbole);
    }
    if (table->indexAvailableBottom != TABLE_SIZE - 1){
        printf("%-20s\t\t %-12s\t\t %-12s\t %-20s\t %-12s\n", "...", "...", "...", "...", "...");
        for (int i = (indexBottom + 1); i < TABLE_SIZE; i++){
            symbole = table->array[i];
            print_symbole(&symbole);
        }
    }

    

}
