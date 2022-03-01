`timescale 1ns / 1ps

module EX(input [31:0] IMM_EX,              // adder, mux3
          input [31:0] REG_DATA1_EX,        // mux1
          input [31:0] REG_DATA2_EX,        // mux2
          input [31:0] PC_EX,               // adder
          // alu control
          input [2:0] FUNCT3_EX,
          input [6:0] FUNCT7_EX,
          
          // propagate
          input [4:0] RD_EX,
          input [4:0] RS1_EX,
          input [4:0] RS2_EX,
          input RegWrite_EX,
          input MemtoReg_EX,
          input MemRead_EX,
          input MemWrite_EX,
          
          input [1:0] ALUop_EX,             // alu control
          input ALUSrc_EX,                  // mux3
          input Branch_EX,
          input [1:0] forwardA,             // mux1
          input [1:0] forwardB,             // mux2
          
          input [31:0] ALU_DATA_WB,         // mux1
          input [31:0] ALU_OUT_MEM,         // mux2
          
          // alu
          output ZERO_EX,
          output [31:0] ALU_OUT_EX,
          
          output [31:0] PC_Branch_EX,       // adder
          output [31:0] REG_DATA2_EX_FINAL, // mux2
          // propagate
          output MemRead_EX_out,
          output MemtoReg_EX_out,
          output MemWrite_EX_out,
          output RegWrite_EX_out,
          output Branch_EX_out,
          output [4:0] RD_EX_out,
          output [4:0] RS1_out);
        
    wire [3:0]ALUInput;
    wire [31:0]out_mux1, out_mux2, out_mux3;
    wire [31:0]rez_addr;
        
    mux4_1 mux1(REG_DATA1_EX, ALU_DATA_WB, ALU_OUT_MEM, 32'b0, forwardA, out_mux1);

    mux4_1 mux2(REG_DATA2_EX, ALU_DATA_WB, ALU_OUT_MEM, 32'b0, forwardB, REG_DATA2_EX_FINAL);
        
    mux2_1 mux3(REG_DATA2_EX_FINAL, IMM_EX, ALUSrc_EX, out_mux3);
        
    adder adder1(PC_EX, IMM_EX, PC_Branch_EX);
        
    ALUcontrol alu_control(ALUop_EX, FUNCT7_EX, FUNCT3_EX, ALUInput);
    ALU alu(ALUInput, out_mux1, out_mux3, ZERO_EX, ALU_OUT_EX);
        
    // propagate
    assign MemRead_EX_out = MemRead_EX;
    assign MemtoReg_EX_out = MemtoReg_EX;
    assign MemWrite_EX_out = MemWrite_EX;
    assign RegWrite_EX_out = RegWrite_EX;
    assign Branch_EX_out = Branch_EX;
    assign RD_EX_out = RD_EX;
    assign RS1_out = RS1_EX;
    assign FUNCT3_out = FUNCT3_EX;
        
endmodule