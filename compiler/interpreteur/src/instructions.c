#include <stdio.h>
#include "instructions.h"

int EBP = 0;

struct instruction {
    char ins;
    int arg1;
    int arg2;
    int arg3;
};

struct instruction instructions[MAX_INSTRUCTIONS_SIZE];
int current_line;
int has_error;

int memory[MAX_MEMORY_SIZE];

int exec(int ip);
int valid_memory_addr(int address);

/***** Public funciton *****/

void asm_init() {
    current_line = 0;
    has_error = 0;
}

void asm_add_3(char ins, int arg1, int arg2, int arg3) {
    if (current_line >= MAX_INSTRUCTIONS_SIZE) {
        fprintf(stderr, "ERROR readfile : Too much instructions, please modify value of MAX_INSTRUCTIONS_SIZE.\n");
        has_error = 1;
        return;
    }

    // ip are validated at runtime; memory addr are validated here
    if (ins == AFC || ins == JPF) {
        if (!valid_memory_addr(arg1)) {
            fprintf(stderr, "ERROR readfile : INVALID addr at line %d, please verify that addr is in range 0 to MAX_MEMORY_SIZE\n", current_line);
            has_error = 1;
            return;
        }
    } else if (ins == JMP) {
        // do nothing
    } else {
        if (!(valid_memory_addr(arg1) && valid_memory_addr(arg2)
            && valid_memory_addr(arg3))) {
            fprintf(stderr, "ERROR readfile : INVALID addr at line %d, please verify that addr is in range 0 to MAX_MEMORY_SIZE\n", current_line);
            has_error = 1;
            return;
        }
    }

    // When OK
    instructions[current_line].ins = ins;
    instructions[current_line].arg1 = arg1;
    instructions[current_line].arg2 = arg2;
    instructions[current_line].arg3 = arg3;
    current_line++;
}

void asm_add_2(char ins, int arg1, int arg2) {
    asm_add_3(ins, arg1, arg2, 0);
}

void asm_add_1(char ins, int arg1) {
    asm_add_3(ins, arg1, 0, 0);
}

void asm_run() {
    int ip = 0;
    if (has_error) {
        fprintf(stderr, "ERROR run : abandoned due to previous error.\n");
        return;
    }
    printf("INFO run : begin\n");
    while (ip >= 0 && ip < current_line) {
        // wait for user input
        //getchar();
        // execution
        ip = exec(ip);
    }
    printf("INFO run : end\n");
}

/***** Private funciton *****/

int valid_memory_addr(int addr) {
    return addr >= 0 && addr < MAX_MEMORY_SIZE;
}

int exec(int ip) {
    int next_ip = ip + 1;
    char ins = instructions[ip].ins;
    int arg1 = instructions[ip].arg1;
    int arg2 = instructions[ip].arg2;
    int arg3 = instructions[ip].arg3;
    printf("%d : ", ip);

    // execute inst
    switch (ins) {
    case ADD:
        printf("ADD @%d = @%d[%d] + @%d[%d]\n", arg1, arg2, memory[arg2], arg3, memory[arg3]);
        memory[arg1] = memory[arg2] + memory[arg3]; break;
    case MUL:
        printf("MUL @%d = @%d[%d] * @%d[%d]\n", arg1, arg2, memory[arg2], arg3, memory[arg3]);
        memory[arg1] = memory[arg2] * memory[arg3]; break;
    case SOU:
        printf("SOU @%d = @%d[%d] - @%d[%d]\n", arg1, arg2, memory[arg2], arg3, memory[arg3]);
        memory[arg1] = memory[arg2] - memory[arg3]; break;
    case DIV:
        printf("DIV @%d = @%d[%d] / @%d[%d]\n", arg1, arg2, memory[arg2], arg3, memory[arg3]);
        memory[arg1] = memory[arg2] / memory[arg3]; break;
    case COP:
        printf("COP @%d = @%d[%d]\n", arg1, arg2, memory[arg2  + EBP]);
        memory[arg1 + EBP] = memory[arg2]; break;
    case AFC:
        printf("AFC @%d = %d\n", arg1, arg2);
        memory[arg1] = arg2; break;
    case JMP:
        printf("JMP to %d\n", arg1);
        next_ip = arg1; break;
    case JPF:
        printf("JPF cond@%d[%d] to %d\n", arg1, memory[arg1], arg2);
        if (memory[arg1] != 1) {
            next_ip = arg2;
        }
        break;
    case LT:
        printf("LT @%d = @%d[%d] < @%d[%d] ? 1 : 0\n", arg1, arg2, memory[arg2], arg3, memory[arg3]);
        memory[arg1] = memory[arg2] < memory[arg3] ? 1 : 0;
        break;
    case GT:
        printf("GT @%d = @%d[%d] > @%d[%d] ? 1 : 0\n", arg1, arg2, memory[arg2], arg3, memory[arg3]);
        memory[arg1] = memory[arg2] > memory[arg3] ? 1 : 0;
        break;
    case LTE:
        printf("LTE @%d = @%d[%d] <= @%d[%d] ? 1 : 0\n", arg1, arg2, memory[arg2], arg3, memory[arg3]);
        memory[arg1] = memory[arg2] <= memory[arg3] ? 1 : 0;
        break;
    case GTE:
        printf("GTE @%d = @%d[%d] >= @%d[%d] ? 1 : 0\n", arg1, arg2, memory[arg2], arg3, memory[arg3]);
        memory[arg1] = memory[arg2] >= memory[arg3] ? 1 : 0;
        break;
    case EQ:
        printf("EQ @%d = @%d[%d] == @%d[%d] ? 1 : 0\n", arg1, arg2, memory[arg2], arg3, memory[arg3]);
        memory[arg1] = memory[arg2] == memory[arg3] ? 1 : 0;
        break;
    case NEQ:
        printf("NEQ @%d = @%d[%d] != @%d[%d] ? 1 : 0\n", arg1, arg2, memory[arg2], arg3, memory[arg3]);
        memory[arg1] = memory[arg2] != memory[arg3] ? 1 : 0;
        break;
    case PRI:
        printf("PRI @%d[%d]\n", arg1, memory[arg1]);
        break;
    case AND:
        printf("AND @%d = @%d[%d] && @%d[%d] ? 1 : 0\n", arg1, arg2, memory[arg2], arg3, memory[arg3]);
        memory[arg1] = memory[arg2] && memory[arg3] ? 1 : 0;
        break;
    case OR:
        printf("OR @%d = @%d[%d] || @%d[%d] ? 1 : 0\n", arg1, arg2, memory[arg2], arg3, memory[arg3]);
        memory[arg1] = memory[arg2] || memory[arg3] ? 1 : 0;
        break;
    case NOT:
        printf("OR @%d = ! @%d[%d] ? 1 : 0\n", arg1, arg2, memory[arg2]);
        memory[arg1] = ! memory[arg2] ? 1 : 0;
        break;
    case LEA:
        printf("LEA @%d = %d\n", arg1, arg2 + EBP);
        memory[arg1 + EBP] = arg2 + EBP;
        break;
    case COP_LD:
        printf("COP_LD @%d = @%d[%d]\n", arg1, arg2, memory[arg2]);
        memory[arg1] = memory[memory[arg2]];
        break;
    case COP_STR:
        printf("COP_STR @%d = @%d[%d]\n", arg1, arg2, memory[arg2]);
        memory[arg1] = memory[arg2];
        break;
    case RET:
        printf("RET @%d[%d] \n", arg1, memory[arg1]);
        if (EBP != 0){
            next_ip = memory[EBP - 2];
            EBP = memory[EBP - 1];
        }
        break;
    case CALL:
        memory[EBP + arg2 - 1] = EBP;
        memory[EBP + arg2 - 2] = next_ip;
        next_ip = arg1;
        EBP += arg2;
        break;
    default:
        fprintf(stderr, "ERROR run : unknown inst.\n");
    }

    return next_ip;
}
