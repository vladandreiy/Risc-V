`timescale 1ns / 1ps

module Branch(
    input branch_flag,
    input zero_flag,
    output reg PCSrc
    );
    always @(*) begin
        if (branch_flag)
            PCSrc = zero_flag;     // if zero_flag is set -> PC_Src = 1
        else
            PCSrc = 0;
    end
endmodule
