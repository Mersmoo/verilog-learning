`timescale 1ns/1ps

module t_flip_flop_tb;

    reg clk;
    reg reset;
    reg t;

    wire q;

    t_flip_flop uut (
        .clk(clk),
        .reset(reset),
        .t(t),
        .q(q)
    );

    always #5 clk = ~clk;

    initial begin
        $dumpfile("t_flip_flop.vcd");
        $dumpvars(0, t_flip_flop_tb);
    end

    initial begin

        clk = 0;
        reset = 1;
        t = 0;

        #12;

        reset = 0;
        t = 1;

        #40;

        t = 0;

        #20;

        t = 1;

        #30;

        $finish;

    end

    initial begin
        $monitor("Time=%0t | CLK=%b | RESET=%b | T=%b | Q=%b",
                 $time, clk, reset, t, q);
    end

endmodule