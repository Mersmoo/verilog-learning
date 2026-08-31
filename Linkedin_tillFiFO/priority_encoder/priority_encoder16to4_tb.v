`timescale 1ns/1ps

module priority_encoder16to4_tb;

    reg  [15:0] in;
    wire [3:0] out;

    priority_encoder16to4 uut (
        .in(in),
        .out(out)
    );

    initial begin
        $dumpfile("priority_encoder16to4.vcd");
        $dumpvars(0, priority_encoder16to4_tb);
        $monitor("Time=%0t | IN=%b | OUT=%b",
                 $time, in, out);

        // فقط I0
        in = 16'b0000_0000_0000_0001;
        #10;

        // فقط I3
        in = 16'b0000_0000_0000_1000;
        #10;

        // فقط I7
        in = 16'b0000_0000_1000_0000;
        #10;

        // فقط I10
        in = 16'b0000_0100_0000_0000;
        #10;

        // چند ورودی همزمان
        in = 16'b0000_0100_1000_0100;
        #10;

        // I15 و چند ورودی دیگر
        in = 16'b1000_0100_1000_0100;
        #10;

        // هیچ ورودی فعال نیست
        in = 16'b0000_0000_0000_0000;
        #10;

        $finish;

    end

endmodule