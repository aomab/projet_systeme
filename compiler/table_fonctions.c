#include "table_fonctions.h"
#include <string.h>
#include <stdio.h>

void initialise_function_table(Table_Fonctions * table){
    table->depth = 1;
}

void add_function(Table_Fonctions * table, char * function_name, enum Return_Type return_type, int start_addr){
    Fonction fonction;
    strcpy(fonction.function_name,function_name);
    fonction.start_addr = start_addr;
    fonction.type = return_type;
    fonction.function_depth = table->depth;
    table->array[table->depth] = fonction;
    table->depth++;
}

void print_function(Fonction * fonction){
    char * function_name = fonction->function_name;
    int start_addr = fonction->start_addr;
    int depth = fonction->function_depth;
    int return_type = fonction->type;
    char typeStr[20];
    if (return_type == RET_INT){
        strcpy(typeStr, "INT");
    } else if (return_type == RET_INT_PTR){
        strcpy(typeStr, "INT_PTR");
    }
    printf("%-20s\t\t %-12s\t\t %-12d\t %-12d\n", function_name, typeStr, start_addr, depth);
}

void print_fonction_table(Table_Fonctions * table) {
    printf("%-20s\t\t %-12s\t\t %-12s\t %-20s\n", "Function Name", "Return Type", "Start Address", "Depth");
    Fonction fonction;
    for (int i = 1; i < table->depth; i++) {
        fonction = table->array[i];
        print_function(&fonction);
    }
}

int function_exists(Table_Fonctions * table, char * func_name){
    for (int i = 0; i < table->depth; i++){
        if (strcmp(table->array[i].function_name, func_name) == 0){
            return i;
        }
    }
    return -1;
}

/*
int main(){
    Table_Fonctions table;
    initialise_function_table(&table);
    add_function(&table, "Fonction1", 0, 7);
    add_function(&table, "Fonction2", 1, 23);
    print_fonction_table(&table);
    return 1;
}*/
