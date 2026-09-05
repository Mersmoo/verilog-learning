`timescale 1ns/1ps

module instruction_memory (
    input  wire [31:0] address,
    output wire [31:0] instruction
);

    reg [31:0] memory [0:255];

    initial begin

        // LDI R1, 10
        memory[0] = 32'h0000520A;

        // LDI R2, 20
        memory[1] = 32'h00005414;

        // ADD R3, R1, R2
        memory[2] = 32'h00001650;

        // STORE R3, 5
        memory[3] = 32'h00007605;

        // LOAD R4, 5
        memory[4] = 32'h00006805;

        // NOP
        memory[5] = 32'h00000000;

    end

    assign instruction = memory[address[9:2]];

endmodule