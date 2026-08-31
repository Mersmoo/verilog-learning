`timescale 1ns/1ps

module clock_divider_tb;

    reg clk;
    reg reset;

    wire clk_out;

    clock_divider uut (
        .clk(clk),
        .reset(reset),
        .clk_out(clk_out)
    );

    always #5 clk = ~clk;

    initial begin
        $dumpfile("clock_divider.vcd");
        $dumpvars(0, clock_divider_tb);
    end

    initial begin

        clk = 0;
        reset = 1;

        #12;

        reset = 0;

        #100;

        $finish;

    end

    initial begin
        $monitor("Time=%0t | CLK=%b | RESET=%b | CLK_OUT=%b",
                 $time, clk, reset, clk_out);
    end

endmodule