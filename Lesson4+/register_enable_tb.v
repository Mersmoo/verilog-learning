`timescale 1ns/1ps

module register_enable_tb;

reg clk;
reg reset;
reg enable;
reg [7:0] d;

wire [7:0] q;

register_enable uut (
    .clk(clk),
    .reset(reset),
    .enable(enable),
    .d(d),
    .q(q)
);

// Clock
always #5 clk = ~clk;

initial begin
    $dumpfile("register_enable.vcd");
    $dumpvars(0, register_enable_tb);
    // Initial values
    clk = 0;
    reset = 1;
    enable = 0;
    d = 8'h00;

    // Reset
    #10;

    // Disable reset
    reset = 0;

    // Enable = 1
    enable = 1;
    d = 8'hAA;

    #10;

    // Change D
    d = 8'hF0;

    #10;

    // Disable register
    enable = 0;
    d = 8'h55;

    #10;

    // Enable again
    enable = 1;

    #10;

    // Reset again
    reset = 1;

    #10;

    $finish;

end

endmodule