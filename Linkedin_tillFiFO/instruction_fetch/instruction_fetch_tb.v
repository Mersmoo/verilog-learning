`timescale 1ns/1ps

module instruction_fetch_tb;

    reg clk;
    reg reset;

    wire [31:0] pc;
    wire [31:0] instruction;

    instruction_fetch uut (
        .clk(clk),
        .reset(reset),
        .pc(pc),
        .instruction(instruction)
    );

    always #5 clk = ~clk;

    initial begin

        $dumpfile("instruction_fetch.vcd");
        $dumpvars(0, instruction_fetch_tb);

        clk = 0;
        reset = 1;

        uut.instruction_memory[0] = 32'h002081B3;
        uut.instruction_memory[1] = 32'h40520333;
        uut.instruction_memory[2] = 32'h0083F4B3;
        uut.instruction_memory[3] = 32'h00B56463;

        #10;
        reset = 0;

        #10;
        $display("PC = %0d, Instruction = %h", pc, instruction);

        #10;
        $display("PC = %0d, Instruction = %h", pc, instruction);

        #10;
        $display("PC = %0d, Instruction = %h", pc, instruction);

        #10;
        $display("PC = %0d, Instruction = %h", pc, instruction);

        #10;
        $finish;

    end

endmodule