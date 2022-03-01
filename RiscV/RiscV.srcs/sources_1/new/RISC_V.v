`timescale 1ns / 1ps

module RISC_V(input clk,
              input reset,
              
              output [31:0] PC_EX,
              output [31:0] ALU_OUT_EX,
              output [31:0] PC_MEM,
              output PCSrc,
              output [31:0] DATA_MEMORY_MEM,
              output [31:0] ALU_DATA_WB,
              output [1:0] forwardA, forwardB,
              output pipeline_stall
             );
     
    // IF in
    wire PC_write;
    // IF out
    wire [31:0] PC_IF, INSTRUCTION_IF;

    IF if1(clk, reset, 
           PCSrc, 
           PC_write, 
           PC_MEM,

           PC_IF,
           INSTRUCTION_IF);

    
    // IF_ID pipeline in
    wire IF_ID_write;
    // IF_ID pipeline out
    wire [31:0] PC_ID, INSTRUCTION_ID;

    IF_ID_reg IF_ID_reg1(clk, reset, IF_ID_write, 
                        PC_IF,
                        INSTRUCTION_IF,

                        PC_ID,
                        INSTRUCTION_ID);
    

    // ID in
    wire RegWrite_WB;
    wire [4:0] RD_WB;
    // ID out
    wire [31:0] IMM_ID, REG_DATA1_ID, REG_DATA2_ID;
    wire [2:0] FUNCT3_ID;
    wire [6:0] FUNCT7_ID, OPCODE_ID;
    wire [4:0] RD_ID, RS1_ID, RS2_ID;

    ID id1(clk,
           PC_ID,
           INSTRUCTION_ID,
           RegWrite_WB,
           ALU_DATA_WB,
           RD_WB,

           IMM_ID,
           REG_DATA1_ID,
           REG_DATA2_ID,
           FUNCT3_ID,
           FUNCT7_ID,
           OPCODE_ID,
           RD_ID,
           RS1_ID,
           RS2_ID);
      
    
    // control path output
    wire Branch_ID, MemRead_ID, MemtoReg_ID, MemWrite_ID, ALUSrc_ID, RegWrite_ID;
    wire [1:0] ALUop_ID;
    control_path control_path1(OPCODE_ID,
                               pipeline_stall,

                               Branch_ID,
                               MemRead_ID,
                               MemtoReg_ID,
                               ALUop_ID,
                               MemWrite_ID,
                               ALUSrc_ID,
                               RegWrite_ID);
    

    // hazard detection in
    wire [4:0] RD_EX;
    hazard_detection hazard_detection1(RD_EX,
                                       RS1_ID,
                                       RS2_ID,
                                       MemRead_ID,
                                       PC_write,
                                       IF_ID_write,
                                       pipeline_stall);


    // ID_EX pipeline out
    wire RegWrite_ID_EX, MemtoReg_ID_EX, MemRead_ID_EX, MemWrite_ID_EX, ALUSrc_ID_EX, Branch_ID_EX;
    wire [1:0] ALUop_ID_EX;
    wire [31:0] REG_DATA1_ID_EX, REG_DATA2_ID_EX, IMM_EX;
    wire [6:0] FUNCT7_ID_EX;
    wire [2:0] FUNCT3_ID_EX;
    wire [4:0] RS1_ID_EX, RS2_ID_EX;
    ID_EX_reg ID_EX_reg1(clk, reset,
                        PC_ID,
                        MemRead_ID,
                        MemtoReg_ID,
                        MemWrite_ID,
                        RegWrite_ID,
                        Branch_ID,
                        ALUSrc_ID,
                        ALUop_ID,
                        IMM_ID,
                        REG_DATA1_ID,
                        REG_DATA2_ID,
                        FUNCT3_ID,
                        FUNCT7_ID,
                        RD_ID,
                        RS1_ID,
                        RS2_ID,
        
                        PC_EX,
                        MemRead_ID_EX,
                        MemtoReg_ID_EX,
                        MemWrite_ID_EX,
                        RegWrite_ID_EX,
                        Branch_ID_EX,
                        ALUSrc_ID_EX,
                        ALUop_ID_EX,
                        IMM_EX,
                        REG_DATA1_ID_EX,
                        REG_DATA2_ID_EX,
                        FUNCT3_ID_EX,
                        FUNCT7_ID_EX,
                        RD_EX,
                        RS1_ID_EX,
                        RS2_ID_EX);
    
    
    // EX in
    wire [31:0] ALU_out_MEM;
    // EX out
    wire ZERO_FLAG_EX;
    wire [31:0] PC_Branch_EX, REG_DATA2_EX;
    wire [4:0] RD_EX_out, RS1_EX;
    wire RegWrite_EX, MemtoReg_EX, MemRead_EX, MemWrite_EX, Branch_EX;
    wire [2:0] FUNCT3_EX;

    EX EX1(IMM_EX,      
          REG_DATA1_ID_EX,
          REG_DATA2_ID_EX,
          PC_EX,
          FUNCT3_ID_EX,
          FUNCT7_ID_EX,
          RD_EX,
          RS1_ID_EX,
          RS2_ID_EX,
          RegWrite_ID_EX,
          MemtoReg_ID_EX,
          MemRead_ID_EX,
          MemWrite_ID_EX,
          ALUop_ID_EX,
          ALUSrc_ID_EX,
          Branch_ID_EX,
          forwardA, forwardB,
          
          ALU_DATA_WB,
          ALU_out_MEM,
          
          ZERO_FLAG_EX,
          ALU_OUT_EX,
          PC_Branch_EX,
          REG_DATA2_EX,
          MemRead_EX,
          MemtoReg_EX,
          MemWrite_EX,
          RegWrite_EX,
          Branch_EX,
          RD_EX_out,
          RS1_EX);

    // EX_MEM_reg out
    wire RegWrite_EX_MEM, MemtoReg_EX_MEM, MemWrite_EX_MEM, Branch_EX_MEM;
    wire ZERO_FLAG_MEM_EX;
    wire [31:0] REG_DATA2_EX_MEM, ALU_OUT_MEM;
    wire [4:0] RD_MEM;
    EX_MEM_reg EX_MEM_reg1(clk, reset,
                           MemRead_EX,
                           MemtoReg_EX,
                           MemWrite_EX,
                           RegWrite_EX,
                           Branch_EX,
                           ZERO_EX,
                           ALU_OUT_EX,
                           PC_Branch_EX,
                           REG_DATA2_EX,
                           RD_EX_out,
     
                           MemRead_EX_MEM,
                           MemtoReg_EX_MEM,
                           MemWrite_EX_MEM,
                           RegWrite_EX_MEM,
                           Branch_EX_MEM,
                           ZERO_FLAG_EX_MEM,
                           ALU_OUT_MEM,
                           PC_MEM,
                           REG_DATA2_EX_MEM,
                           RD_MEM);   
    
    forwarding forwarding1(RS1_EX, 
                           RS2_EX,
                           RD_MEM,
                           RD_WB,
                           RegWrite_MEM,
                           RegWrite_WB,
                           forwardA,
                           forwardB);

    // Mem out
    wire RegWrite_MEM_WB, MemtoReg_MEM_WB;
    wire [31:0] ALU_OUT_MEM_WB;
    wire [4:0] RD_MEM_WB;

    MEM MEM1(clk,
             MemRead_MEM,
             MemtoReg_MEM,
             MemWrite_MEM,
             RegWrite_MEM,
             Branch_MEM,
             ZERO_FLAG_MEM,
             PC_MEM,
             ALU_OUT_MEM,
             REG_DATA2_EX_MEM,
             RD_MEM,

             RegWrite_MEM_WB,
             MemtoReg_MEM_WB,
             DATA_MEMORY_MEM,
             ALU_OUT_MEM_WB,
             RD_MEM_WB,
             PCSrc);   
    
    // MEM_WB_Reg out
    wire MemtoReg_WB;
    wire [31:0] DATA_MEMORY_WB, ALU_OUT_WB;

    MEM_WB_reg MEM_WB_reg1(clk, reset,
                           MemtoReg_MEM_WB,
                           RegWrite_MEM_WB,
                           ALU_OUT_MEM_WB,
                           DATA_MEMORY_MEM,
                           RD_MEM_WB,

                           MemtoReg_WB,
                           RegWrite_WB,
                           ALU_OUT_WB,
                           DATA_MEMORY_WB,
                           RD_WB);

    WB wb1(DATA_MEMORY_WB,
           ALU_OUT_WB,
           MemtoReg_WB,
           ALU_DATA_WB);
    
endmodule
