`timescale 1ns / 1ps

module MEM(
    input clk,
    input MemRead,
    input MemtoReg,
    input MemWrite,
    input RegWrite,
    input Branch,
    input zero_flag,
    input [31:0] PC,
    input [31:0] ALU_out,
    input [31:0] REG_DATA2,
    input [4:0] RD,
    output RegWrite_out,
    output MemtoReg_out,
    output [31:0] DATA_MEMORY_out,
    output [31:0] ALU_out_WB,
    output [4:0] RD_out,
    output PC_Src
    );
    data_memory data_memory1(clk, MemRead, MemWrite, REG_DATA2[11:2], ALU_out, DATA_MEMORY_out);
    Branch branch1(Branch, zero_flag, PC_Src);
    
    assign RegWrite_out = RegWrite;
    assign MemtoReg_out = MemtoReg;
    assign ALU_out_WB = ALU_out;
    assign RD_out = RD;
endmodule
