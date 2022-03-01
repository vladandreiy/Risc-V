`timescale 1ns / 1ps

module MEM_WB_reg(
    input clk, reset,
    input MemtoReg,
    input RegWrite,
    input [31:0] ALU_OUT_MEM,
    input [31:0] REG_DATA2_MEM,
    input [4:0] RD_MEM,
 
    output reg MemtoReg_WB,
    output reg RegWrite_WB,
    output reg [31:0] ALU_OUT_WB,
    output reg [31:0] REG_DATA2_WB,
    output reg [4:0] RD_MEM_WB
    );
    
    always @(posedge clk) begin
        if (reset) begin
            MemtoReg_WB <= 0;
            RegWrite_WB<= 0;
            ALU_OUT_WB <= 0;
            REG_DATA2_WB <= 0;
            RD_MEM_WB <= 0;
        end
        else begin
                MemtoReg_WB <= MemtoReg;
                RegWrite_WB <= RegWrite;
                ALU_OUT_WB <= ALU_OUT_MEM;
                REG_DATA2_WB <= REG_DATA2_MEM;
                RD_MEM_WB <= RD_MEM;
        end
    end
    
endmodule
