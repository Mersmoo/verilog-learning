`timescale 1ns/1ps

module program_counter_jump_tb;

reg clk;
reg reset;
reg jump;

reg [31:0] jump_address;

wire [31:0] pc;

program_counter_jump uut (
    .clk          (clk),
    .reset        (reset),
    .jump         (jump),
    .jump_address (jump_address),
    .pc           (pc)
);

always #5 clk = ~clk;

initial begin
    $dumpfile("program_counter_jump.vcd");
    $dumpvars(0, program_counter_jump_tb);

    clk = 0;
    reset = 1;
    jump = 0;
    jump_address = 32'h00000000;

    #10;

    reset = 0;

    // Normal counting
    #30;

    // Jump to address 100
    jump_address = 32'd100;
    jump = 1;

    #10;

    // Continue normal counting
    jump = 0;

    #30;

    // Jump to address 200
    jump_address = 32'd200;
    jump = 1;

    #10;

    jump = 0;

    #20;

    $finish;
end

initial begin
    $monitor(
        "Time=%0t | Reset=%b | Jump=%b | JumpAddr=%0d | PC=%0d",
        $time,
        reset,
        jump,
        jump_address,
        pc
    );
end

endmodule