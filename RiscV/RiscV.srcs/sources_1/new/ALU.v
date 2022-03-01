`timescale 1ns / 1ps

module ALU(
    input[3:0] ALUop,
    input [31:0] ina, inb,
    output reg zero,
    output reg [31:0] out
    );
    always@(*) begin 
        if(ALUop == 4'b0010) //ld, sd, add, addi
            out = ina + inb;
        else if(ALUop == 4'b0110) //sub
            out = ina - inb;
        else if(ALUop == 4'b0000) //and
            out = ina & inb;
        else if(ALUop == 4'b0001) //or
            out = ina | inb;
        else if(ALUop == 4'b0011) //xor
            out = ina ^ inb;
        else if(ALUop == 4'b0101) //srl, srli
            out = ina >> inb;
        else if(ALUop == 4'b0100) //sll, slli
            out = ina << inb;
        else if(ALUop == 4'b1001) //sra, srai
            out = ina >>> inb;
        else if(ALUop == 4'b0111) begin //sltu
            if(ina < inb) 
                out = 1;
            else
                out = 0;
        end
        else if(ALUop == 4'b1000) begin //slt
            if(ina[31] == 1 && inb[31] == 1 ||
               ina[31] == 0 && inb[31] == 0) begin // acelasi semn
                if(ina > inb)
                    out = 1;
                else
                    out = 0;
            end
            if(ina[31] == 1 && inb[31] == 0) // ina - negativ
                out = 0;
            
            if(ina[31] == 0 && inb[31] == 1) // inb - negativ
                out = 1;
        end 
        if(out == 0)
            zero = 1;
        else
            zero = 0;
    end
endmodule
