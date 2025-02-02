#ifndef __INSTRUCTIONS_H__
#define __INSTRUCTIONS_H__

#define ADD 1
#define MUL 2
#define SOU 3
#define DIV 4
#define COP 5
#define AFC 6
#define LOAD 7
#define STORE 8

#define MAX_SIZE 256

struct reg_instruction {
    char ins;
    int arg1;
    int arg2;
    int arg3;
};

typedef struct reg_instructions{
    struct reg_instruction reg_instructions[MAX_SIZE];
    int index;
} reg_instructions;

void init_reg_oriented_instructions(reg_instructions * instructions_array);

void add_reg_oriented_instructions(reg_instructions * instructions_array, int operation, int arg1, int arg2, int arg3);

void output_reg_oriented_instructions(reg_instructions * instructions_array);

#endif // #ifndef __INSTRUCTIONS_H__
