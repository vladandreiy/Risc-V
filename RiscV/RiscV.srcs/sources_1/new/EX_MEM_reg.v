`timescale 1ns / 1ps

module EX_MEM_reg(
    input clk, reset,
    input MemRead,
    input MemtoReg,
    input MemWrite,
    input RegWrite,
    input Branch,
    input ZERO_EX,
    input [31:0] ALU_EX,
    input [31:0] PC_Branch_EX,
    input [31:0] REG_DATA2_EX,
    input [4:0] RD_EX,
 
    output reg MemRead_MEM,
    output reg MemtoReg_MEM,
    output reg MemWrite_MEM,
    output reg RegWrite_MEM,
    output reg Branch_MEM,
    output reg ZERO_MEM,
    output reg [31:0] ALU_OUT_MEM,
    output reg [31:0] PC_Branch_MEM,
    output reg [31:0] REG_DATA2_MEM,
    output reg [4:0] RD_EX_MEM
    );
    
    always @(posedge clk)
        if (reset) begin
                MemRead_MEM <= 0;
                MemtoReg_MEM <= 0;
                MemWrite_MEM <= 0;
                RegWrite_MEM <= 0;
                Branch_MEM <= 0;
                ZERO_MEM <= 0;
                ALU_OUT_MEM <= 0;
                PC_Branch_MEM <= 0;
                REG_DATA2_MEM <= 0;
                RD_EX_MEM <= 0;
            end
       else begin
                MemRead_MEM <= MemRead;
                MemtoReg_MEM <= MemtoReg;
                MemWrite_MEM <= MemWrite;
                RegWrite_MEM <= RegWrite;
                Branch_MEM <= Branch;
                ZERO_MEM <= ZERO_EX;
                ALU_OUT_MEM <= ALU_EX;
                PC_Branch_MEM <= PC_Branch_EX;
                REG_DATA2_MEM <= REG_DATA2_EX;
                RD_EX_MEM <= RD_EX;
        end
endmodule
