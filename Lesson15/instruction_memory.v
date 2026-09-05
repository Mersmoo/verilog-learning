`timescale 1ns/1ps

module instruction_memory (
    input  [31:0] address,
    output [31:0] instruction
);

    reg [31:0] memory [0:255];

    initial begin
        memory[0] = 32'h012A4020;
        memory[1] = 32'h014B4822;
        memory[2] = 32'h016C5024;
        memory[3] = 32'h018D5825;
    end

    assign instruction = memory[address[9:2]];

endmodule