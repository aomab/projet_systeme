#ifndef __INSTRUCTIONS_H__
#define __INSTRUCTIONS_H__

#define ADD 1
#define MUL 2
#define SOU 3
#define DIV 4
#define COP 5
#define AFC 6
#define JMP 7
#define JPF 8
#define LT 9
#define GT 10
#define EQ 11
#define PRI 12
#define LTE 13
#define GTE 14
#define NEQ 15
#define AND 16
#define OR 17
#define NOT 18
#define LEA 19
#define COP_LD 20
#define COP_STR 21
#define CALL 22
#define RET 23


#define MAX_INSTRUCTIONS_SIZE 256
#define MAX_MEMORY_SIZE 256

void asm_init();
void asm_add_3(char ins, int arg1, int arg2, int arg3);
void asm_add_2(char ins, int arg1, int arg2);
void asm_add_1(char ins, int arg1);
void asm_run();

#endif // #ifndef __INSTRUCTIONS_H__
