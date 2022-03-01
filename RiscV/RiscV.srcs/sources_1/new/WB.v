`timescale 1ns / 1ps

module WB(
    input [31:0] DATA_MEMORY_WB,
    input [31:0] ALU_OUT_WB,
    input MemtoReg_WB,
    output [31:0] ALU_DATA_WB
    );
    mux2_1 mux(DATA_MEMORY_WB, ALU_OUT_WB, MemtoReg_WB, ALU_DATA_WB);
endmodule
