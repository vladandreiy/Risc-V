# Risc-V
RISC V Processor Implementation in Verilog. The processor receives as input a binary file which represents a program coded in RISC Assembly Language.  
This program will be run by the processor and you can visualize how each instruction is processed through each step of the pipeline, how each instruction is encoded, how the immediates are generated in order to fit the fixed size of the instruction or how the registers and the memory change with each clock cycle.

The processor can't process all operations possible on a RISC V Processor, it follows a smaller Instruction Set Architecture that is suitable for executing simple C programs. The following accepted instructions are: 
 - ADD, ADDI, SUB, MUL
 - AND, ANDI, OR, ORI, XOR, XORI
 - SLT, SLTI, SLTU, SLTIU
 - SRA, SRAI, SRL, SRLI, SLL, SLLI
 - LW, SW
 - JAL, JALR
 - BEQ, BNE, BLT, BGE, BLTU, BGEU