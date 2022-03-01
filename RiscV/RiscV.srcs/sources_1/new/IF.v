`timescale 1ns / 1ps

//////////////////////////////////////////MUX_2_1_MODULE/////////////////////////////////////////////////////
module mux2_1(input [31:0] ina, inb,
              input sel, 
              output reg [31:0] out);
    always @(*)
        out = sel ? inb : ina;
endmodule
//////////////////////////////////////////////////////////////////////////////////////////////////////////////

//////////////////////////////////////////MUX_4_1_MODULE/////////////////////////////////////////////////////
module mux4_1(input [31:0] ina, inb, inc, ind,
              input [1:0]sel, 
              output reg [31:0] out);
    always @(*) begin
        case(sel)
            2'b00 : out = ina;
            2'b01 : out = inb;
            2'b10 : out = inc;
            2'b11 : out = ind;
        endcase
    end
endmodule
//////////////////////////////////////////////////////////////////////////////////////////////////////////////


/////////////////////////////////////////PC_MODULE///////////////////////////////////////////////////////////////
module PC(input clk, res, write, 
          input [31:0] in, 
          output reg [31:0] out);
   always@(posedge clk) begin
     if(res == 1)
        out = 0;
     else if (write == 1) 
        out = in;
   end
endmodule
//////////////////////////////////////////////////////////////////////////////////////////////////////////////

///////////////////////////////////////INSTRUCTION_MEMORY/////////////////////////////////////////////////////
module instruction_memory(input [9:0] address, 
                          output reg[31:0] instruction);
  reg [31:0] codeMemory [0:1023];
  initial $readmemh("code.mem", codeMemory);
  always @(*)
    instruction = codeMemory[address];
endmodule
//////////////////////////////////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////ADDER_MODULE//////////////////////////////////////////////////////
module adder(input [31:0] ina, inb, 
             output reg[31:0] out);
    always @(*)
        out = ina + inb;
endmodule
//////////////////////////////////////////////////////////////////////////////////////////////////////////////

//////////////////////////////////////////////IF//////////////////////////////////////////////////////////////
module IF (input clk, reset, PCSrc, PC_write, 
           input [31:0] PC_Branch, 
           output [31:0] PC_IF, INSTRUCTION_IF);
    wire [31:0]res_adder, res_mux;
    adder add(4, PC_IF, res_adder);
    mux2_1 mux(res_adder, PC_Branch, PCSrc, res_mux);
    PC pc(clk, reset, PC_write, res_mux, PC_IF);
    instruction_memory instr(PC_IF[11:2], INSTRUCTION_IF);
endmodule
//////////////////////////////////////////////////////////////////////////////////////////////////////////////