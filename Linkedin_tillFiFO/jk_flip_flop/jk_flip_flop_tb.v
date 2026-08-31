`timescale 1ns/1ps

module jk_flip_flop_tb;

    reg clk;
    reg reset;
    reg j;
    reg k;

    wire q;

    jk_flip_flop uut (
        .clk(clk),
        .reset(reset),
        .j(j),
        .k(k),
        .q(q)
    );

    always #5 clk = ~clk;

    initial begin
        $dumpfile("jk_flip_flop.vcd");
        $dumpvars(0, jk_flip_flop_tb);
    end

    initial begin

        clk = 0;
        reset = 1;
        j = 0;
        k = 0;

        #12;

        reset = 0;

        // Hold
        j = 0;
        k = 0;
        #10;

        // Set
        j = 1;
        k = 0;
        #10;

        // Hold
        j = 0;
        k = 0;
        #10;

        // Reset
        j = 0;
        k = 1;
        #10;

        // Toggle
        j = 1;
        k = 1;
        #10;

        // Toggle again
        j = 1;
        k = 1;
        #10;

        // Set
        j = 1;
        k = 0;
        #10;

        // Reset
        j = 0;
        k = 1;
        #10;

        $finish;

    end

    initial begin
        $monitor("Time=%0t | CLK=%b | RESET=%b | J=%b | K=%b | Q=%b",
                 $time, clk, reset, j, k, q);
    end

endmodule