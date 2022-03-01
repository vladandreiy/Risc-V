`timescale 1ns / 1ps

module ALUcontrol(
    input [1:0]ALUop,
    input[6:0]funct7,
    input[2:0]funct3,
    output reg [3:0] ALUinput
);   
    always@(*) begin
        if(ALUop == 2'b00) //ld, sd
            ALUinput = 4'b0010;
        else if(ALUop == 2'b10) begin // R sau I
            if(funct3 == 3'b000) begin
                if(funct7 == 7'b0000000) // add
                    ALUinput = 4'b0010;
                else if(funct7 == 7'b0100000) //sub
                    ALUinput = 4'b0110;                  
            end
            else if(funct3 == 3'b111 && funct7 == 7'b00000000) //and
                ALUinput = 4'b0000;
            else if(funct3 == 3'b110 && funct7 == 7'b00000000 ) //or
                ALUinput = 4'b0001;
            else if(funct3 == 3'b100 && funct7 == 7'b00000000) //xor
                ALUinput = 4'b0011;
                        else if(funct7 == 7'b0000000 && funct3 == 3'b101)
                ALUinput = 4'b0101;
            else if(funct7 == 7'b0000000 && funct3 == 3'b001) // sll slli
                ALUinput = 4'b0100;
            else if(funct7 == 7'b0100000 && funct3 == 3'b101) // sra srai
                ALUinput = 4'b1001;
            else if(funct7 == 7'b0000000 && funct3 == 3'b011) // sltu
                ALUinput = 4'b0111;
            else if(funct7 == 7'b0000000 && funct3 == 3'b010) // slt
                ALUinput = 4'b1000;
        end
        else if(ALUop == 2'b01) begin // branch
            if(funct3 == 3'b000 || funct3 == 3'b001) // beq bne
                ALUinput = 4'b0110;
            else if(funct3 == 3'b100 || funct3 ==3'b101) // blt bge
                ALUinput = 4'b1000;
            else if(funct3 == 3'b110 || funct3 ==3'b111) // bltu bgeu
                ALUinput = 4'b0111;
        end
    end
endmodule
