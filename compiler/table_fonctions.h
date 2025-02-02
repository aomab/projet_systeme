//
// Created by Nahom Belay on 29/04/2021.
//

#ifndef PROJET_SYSTEME_TABLE_FONCTIONS_H
#define PROJET_SYSTEME_TABLE_FONCTIONS_H

#define FUNCTION_TABLE_SIZE 50
#define FUNCTION_NAME_SIZE 30

enum Return_Type {RET_INT , RET_INT_PTR};

typedef struct Fonction {
    char function_name[FUNCTION_NAME_SIZE];
    int start_addr ;
    enum Return_Type type;
    int function_depth;
} Fonction;

typedef struct Table_Fonctions {
    Fonction array[FUNCTION_TABLE_SIZE];
    int depth;
} Table_Fonctions;

void initialise_function_table(Table_Fonctions * table);

void add_function(Table_Fonctions * table, char * function_name, enum Return_Type return_type, int start_addr);

void print_fonction_table(Table_Fonctions * table);

int function_exists(Table_Fonctions * table, char * func_name);



#endif //PROJET_SYSTEME_TABLE_FONCTIONS_H
