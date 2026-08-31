`timescale 1ns/1ps

module dff_enable_tb;

    reg clk;
    reg enable;
    reg d;

    wire q;

    dff_enable uut (
        .clk(clk),
        .enable(enable),
        .d(d),
        .q(q)
    );

    // Clock
    always #5 clk = ~clk;

    initial begin
        $dumpfile("dff_enable.vcd");
        $dumpvars(0, dff_enable_tb);
        clk = 0;
        enable = 0;
        d = 0;

        #10;

        // Enable = 1
        enable = 1;
        d = 1;

        #10;

        // Change D while enabled
        d = 0;

        #10;

        // Disable
        enable = 0;
        d = 1;

        #10;

        // Enable again
        enable = 1;

        #10;

        $finish;

    end

    initial begin

        $monitor("Time=%0t | CLK=%b | EN=%b | D=%b | Q=%b",
                 $time, clk, enable, d, q);

    end

endmodule