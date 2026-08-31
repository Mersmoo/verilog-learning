`timescale 1ns/1ps

module pipo_register_tb;

    reg        clk;
    reg  [3:0] d;

    wire [3:0] q;

    pipo_register uut (
        .clk(clk),
        .d(d),
        .q(q)
    );

    always #5 clk = ~clk;

    initial begin
        $dumpfile("pipo_register.vcd");
        $dumpvars(0, pipo_register_tb);
    end

    initial begin

        clk = 0;
        d = 4'b0000;

        #10;

        d = 4'b1010;
        #10;

        d = 4'b1101;
        #10;

        d = 4'b0111;
        #10;

        d = 4'b1111;
        #10;

        d = 4'b0011;
        #10;

        $finish;

    end

    initial begin
        $monitor("Time=%0t | CLK=%b | D=%b | Q=%b",
                 $time, clk, d, q);
    end

endmodule