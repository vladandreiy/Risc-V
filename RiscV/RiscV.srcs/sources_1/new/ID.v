`timescale 1ns / 1ps

///////////////////////////////////REGISTER_FILE_MODULE///////////////////////////////////////////////////////
module registers(input clk, reg_write,
                 input [4:0] read_reg1, read_reg2, write_reg,
                 input [31:0] write_data,
                 output [31:0] read_data1, read_data2);
    integer i;
    reg [31:0] registers[31:0];
    reg [31:0] reg_read_data1, reg_read_data2;
   
    initial begin    
        for(i = 0; i < 32; i = i + 1) 
            registers[i] = i;
    end
    
    always@(posedge clk) begin
        if(reg_write)
            registers[write_reg] = write_data;
    end
    always@(read_reg1 or read_reg2) begin
        reg_read_data1 = registers[read_reg1];
        reg_read_data2 = registers[read_reg2];
    end
    
    assign read_data1 = reg_read_data1;
    assign read_data2 = reg_read_data2;
endmodule
//////////////////////////////////////////////////////////////////////////////////////////////////////////////



//////////////////////////////////////////IMM_GEN_MODULE/////////////////////////////////////////////////////
module imm_gen(input [31:0] in,
               output reg [31:0] out);
    integer i;
    always@(*) begin
        // lw = 0000011
        if (in[6:0] == 7'b0000011) begin
            // I-immediate
            out[31:11] = {20{in[31]}};   
            out[10:5] = in[30:25];
            out[4:1] = in[24:21];
            out[0] = in[20];
        end
        // addi andi ori xori slti sltiu srli srai slli = 0010011
        else if(in[6:0] == 7'b0010011) begin
            // I-immediate
            out[31:11] = {20{in[31]}};
            out[10:5] = in[30:25];
            out[4:1] = in[24:21];
            out[0] = in[20];       
        end
        // sw = 0100011
        else if (in[6:0] == 7'b0100011) begin
            // S-immediate
            out[31:11] = {20{in[31]}};   
            out[10:5] = in[30:25];
            out[4:1] = in[11:8];
            out[0] = in[7];
        end
        // beq bne blt bge bltu bgeu = 1100011
        else if(in[6:0] == 7'b1100011) begin
            // B-immediate
            out[31:12] = {19{in[31]}};   
            out[10:5] = in[30:25];
            out[4:1] = in[11:8];
            out[11] = in[7];
            out[0] = 0;
        end
        // add sub and ... = 0110011
        else if(in[6:0] == 7'b0110011)
            out = 0;
        else
            out = in;
     end
endmodule
//////////////////////////////////////////////////////////////////////////////////////////////////////////////

//////////////////////////////////////////ID_MODULE//////////////////////////////////////////////////////////
module ID(input clk,
          input [31:0] PC_ID, INSTRUCTION_ID,
          input RegWrite_WB,
          input [31:0] ALU_DATA_WB,
          input [4:0] RD_WB,
          output [31:0] IMM_ID,
          output [31:0] REG_DATA1_ID, REG_DATA2_ID,
          output [2:0] FUNCT3_ID,
          output [6:0] FUNCT7_ID,
          output [6:0] OPCODE_ID,
          output [4:0] RD_ID,
          output [4:0] RS1_ID,
          output [4:0] RS2_ID);
    registers registers1(clk, RegWrite_WB, 
                   INSTRUCTION_ID[19:15], 
                   INSTRUCTION_ID[24:20],
                   RD_WB, ALU_DATA_WB, 
                   REG_DATA1_ID, REG_DATA2_ID);
    imm_gen imm_gen1(INSTRUCTION_ID, IMM_ID);
    assign OPCODE_ID = INSTRUCTION_ID[6:0];
    assign RD_ID = INSTRUCTION_ID[11:7];
    assign FUNCT3_ID = INSTRUCTION_ID[14:12];
    assign RS1_ID = INSTRUCTION_ID[19:15];
    assign RS2_ID = INSTRUCTION_ID[24:20];
    assign FUNCT7_ID = INSTRUCTION_ID[31:25];  
endmodule
//////////////////////////////////////////////////////////////////////////////////////////////////////////////