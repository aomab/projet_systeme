#ifndef TABLE_SYMBOLES_H
#define TABLE_SYMBOLES_H

#define TABLE_SIZE 256
#define VARIABLE_SIZE 30

enum Symbole_Type {TYPE_INT , TYPE_CONST_INT, TYPE_INT_PTR};
enum Initialised_Variable{INITIALISED , NOT_INITIALISED};

typedef struct Symboles {
    char Variable_Name[VARIABLE_SIZE];
    int addr ;
    enum Symbole_Type type;
    enum Initialised_Variable init;
    int symbole_depth;
} Symbole;

typedef struct Table_Symboles {
    Symbole array[TABLE_SIZE];
    int indexAvailableTop;
    int indexAvailableBottom;
    int depth;
} Table_Symboles;

/**
 * Initialises indexAvailableTop at 0 and indexAvailableBottom at TABLE_SIZE - 1
 * @param table
 */
void initialise_table(Table_Symboles * table);

/**
 * Adds a symbole at the top (regular varaibles)
 * @param table
 * @param varName
 * @param type
 * @param init
 * @return if symbole added successfully, -1 if the table is full and -2 if the varaible already exists in the table
 */
int add_symbole_top(Table_Symboles * table, char * varName, enum Symbole_Type type , enum Initialised_Variable init, int depth);

/**
 * Adds a symbole at the bottom (temp variables)
 * @param table
 * @return 0 if symbole added successfully, -1 if the table is full and -2 if the varaible already exists in the table
 */
int add_symbole_bottom(Table_Symboles * table);



/**
 * Verifies if a varaible name is already present in the table to avoid duplicates
 * @param table
 * @param varName
 * @return -1 if the varaible name exists, 0 if it doesn't
 */
int variable_exists(Table_Symboles * table, char * varName);

/**
 * Removes symbole from table having certain depth
 * @param table
 * @return -1 if the symbole isn't in the table, 0 otherwise
 */
int remove_symboles(Table_Symboles * table);


void free_temp(Table_Symboles * table);

int prepare_function_call(Table_Symboles * table);

int prepare_argument_push(Table_Symboles * table);


/**
 * Initialises an already exisiting symbole
 * @param table
 * @param varName
 * @return -1 if the symbole isn't in the table, 0 otherwise
 */
int initialise_symbole(Table_Symboles * table, char * varName);


/**
 * Prints a symbole with this format
 * varName      | Type  | Address   | Initialised/Not_Initialised
 * @param symbole
 */
void print_symbole(Symbole * symbole);

/**
 * Prints the table
 * @param table
 */
void print_table(Table_Symboles * table);

#endif