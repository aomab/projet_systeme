# Projet system info

This repository contains the compiler, cross-assembler, and processor developed for the capstone project of "Architecture Logicielle et Matérielle des Systèmes Informatiques."

## Project Structure

### `compiler/`  
This directory includes:  
- A basic C parser supporting most functionalities.  
- A compiler, which generates a custom [instruction set](./instruction_set.md).  
- An interpreter to simulate the execution of the generated code.  

### `cross-assembleur/`  
This directory contains:  
- The cross-assembler, which transforms memory-oriented code into a register-oriented format compatible with the processor.  
- A Python script that converts the output into a STD_LOGIC_VECTOR.  

### `processor/`  
This directory includes the VHDL implementation of the processor.
