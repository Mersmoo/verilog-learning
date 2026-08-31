`timescale 1ns/1ps

module shift_register_tb;

reg clk;
reg reset;
reg din;

wire [3:0] q;

shift_register uut (
    .clk(clk),
    .reset(reset),
    .din(din),
    .q(q)
);

// Clock
always #5 clk = ~clk;

initial begin
    $dumpfile("shift.vcd");
    $dumpvars(0, shift_register_tb);
    clk = 0;
    reset = 1;
    din = 0;

    #10;

    reset = 0;

    // Send 1
    din = 1;
    #10;

    // Send 0
    din = 0;
    #10;

    // Send 1
    din = 1;
    #10;

    // Send 1
    din = 1;
    #10;

    $finish;

end

initial begin
    $monitor("time=%0t reset=%b din=%b q=%b",
             $time, reset, din, q);
end

endmodule