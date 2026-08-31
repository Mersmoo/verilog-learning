`timescale 1ns/1ps

module register_tb;

reg clk;
reg reset;
reg [7:0] d;
wire [7:0] q;

register uut (
    .clk(clk),
    .reset(reset),
    .d(d),
    .q(q)
);

// Clock generation
always #5 clk = ~clk;

initial begin
    $dumpfile("register.vcd");
    $dumpvars(0, register_tb);
    clk = 0;
    reset = 1;
    d = 8'b00000000;

    #10;

    reset = 0;
    d = 8'b10101010;

    #10;

    d = 8'b11110000;

    #10;

    d = 8'b01010101;

    #10;

    reset = 1;

    #10;

    $finish;
end

endmodule