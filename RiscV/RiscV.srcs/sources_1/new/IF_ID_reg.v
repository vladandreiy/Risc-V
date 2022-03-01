`timescale 1ns / 1ps

////////////////////////////////////////PIPELINE_REG_MODULES///////////////////////////////////////////////////
module IF_ID_reg(input clk, reset, write,
                 input [31:0] pc_in, instruction_in,
                 output reg [31:0] pc_out,  instruction_out);
    always @(posedge clk) begin
        if (reset) begin
            instruction_out <= 0;
            pc_out <= 0;
        end
        else if (write) begin
            instruction_out <= instruction_in;
            pc_out <= pc_in;
        end
    end
endmodule
//////////////////////////////////////////////////////////////////////////////////////////////////////////////