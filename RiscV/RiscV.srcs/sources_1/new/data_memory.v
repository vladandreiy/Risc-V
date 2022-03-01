`timescale 1ns / 1ps

module data_memory(
    input clk,
    input mem_read,
    input mem_write,
    input [9:0] address,
    input [31:0] write_data,
    output reg [31:0] read_data
    );
    reg [31:0] memory[0:1023];
    integer i;
    initial begin
        for(i = 0; i <= 1023; i = i + 1)
            memory[i] = 0;
    end
    always@(posedge clk) begin
        if(mem_write == 1)
            memory[address] = write_data;
    end
        
    always@(*) begin
        if(mem_read == 1)
            read_data = memory[address];
    end
endmodule
