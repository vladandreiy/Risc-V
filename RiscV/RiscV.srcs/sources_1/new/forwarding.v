`timescale 1ns / 1ps

module forwarding(input [4:0] rs1,
                  input [4:0] rs2,
                  input [4:0] ex_mem_rd,
                  input [4:0] mem_wb_rd,
                  input ex_mem_regwrite,
                  input mem_wb_regwrite,
                  output reg [1:0] forwardA,forwardB);
    always @(*) begin
        // EX hazard
        if ((ex_mem_regwrite) && (ex_mem_rd != 0) && (ex_mem_rd == rs1))
            forwardA = 2'b10;
        if ((ex_mem_regwrite) && (ex_mem_rd != 0) && (ex_mem_rd == rs2))
            forwardB = 2'b10;
        // MEM hazard
        if (mem_wb_regwrite && 
            (mem_wb_rd != 0) && 
            !(ex_mem_regwrite && (ex_mem_rd != 0)) 
            && (ex_mem_rd == rs1) &&
            mem_wb_rd == rs1)
            forwardA = 2'b01;
        if (mem_wb_regwrite &&
           (mem_wb_rd != 0) && 
           !(ex_mem_regwrite && (ex_mem_rd != 0) && 
           (ex_mem_rd == rs2)) &&
           (mem_wb_rd == rs2))
           forwardB = 2'b01;
    end
endmodule
