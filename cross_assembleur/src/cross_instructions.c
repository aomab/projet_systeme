#include <stdio.h>
#include "cross_instructions.h"

void init_reg_oriented_instructions(reg_instructions * instructions_array){
    instructions_array->index = 0;
}

void add_reg_oriented_instructions(reg_instructions * instructions_array, int operation, int arg1, int arg2, int arg3) {
    struct reg_instruction ins = {operation, arg1, arg2, arg3};
    instructions_array->reg_instructions[instructions_array->index] = ins;
    instructions_array->index++;
}

void output_reg_oriented_instructions(reg_instructions * instructions_array){
    FILE *file;
    file = fopen("cross_output.txt", "w");
    struct reg_instruction instru;
    for (int i = 0; i < instructions_array->index; i++){
        instru = instructions_array->reg_instructions[i];
        fprintf(file, "%d %d %d %d\n", instru.ins, instru.arg1, instru.arg2, instru.arg3);
    }

}
