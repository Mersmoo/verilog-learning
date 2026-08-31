`timescale 1ns/1ps

module crossbar_4x4_tb;

    parameter DATA_WIDTH = 8;

    reg [DATA_WIDTH-1:0] in0;
    reg [DATA_WIDTH-1:0] in1;
    reg [DATA_WIDTH-1:0] in2;
    reg [DATA_WIDTH-1:0] in3;

    reg [1:0] sel0;
    reg [1:0] sel1;
    reg [1:0] sel2;
    reg [1:0] sel3;

    wire [DATA_WIDTH-1:0] out0;
    wire [DATA_WIDTH-1:0] out1;
    wire [DATA_WIDTH-1:0] out2;
    wire [DATA_WIDTH-1:0] out3;

    crossbar_4x4 #(
        .DATA_WIDTH(DATA_WIDTH)
    ) dut (
        .in0(in0),
        .in1(in1),
        .in2(in2),
        .in3(in3),

        .sel0(sel0),
        .sel1(sel1),
        .sel2(sel2),
        .sel3(sel3),

        .out0(out0),
        .out1(out1),
        .out2(out2),
        .out3(out3)
    );

    initial begin

        $dumpfile("crossbar_4x4.vcd");
        $dumpvars(0, crossbar_4x4_tb);

        // Assign different values to each input
        in0 = 8'hA0;
        in1 = 8'hB1;
        in2 = 8'hC2;
        in3 = 8'hD3;

        // Initial routing
        sel0 = 2'b00;
        sel1 = 2'b01;
        sel2 = 2'b10;
        sel3 = 2'b11;

        #10;

        $display("Test 1");
        $display("OUT0 = %h", out0);
        $display("OUT1 = %h", out1);
        $display("OUT2 = %h", out2);
        $display("OUT3 = %h", out3);

        // Change routing
        sel0 = 2'b11;
        sel1 = 2'b10;
        sel2 = 2'b01;
        sel3 = 2'b00;

        #10;

        $display("Test 2");
        $display("OUT0 = %h", out0);
        $display("OUT1 = %h", out1);
        $display("OUT2 = %h", out2);
        $display("OUT3 = %h", out3);

        // All outputs select input 2
        sel0 = 2'b10;
        sel1 = 2'b10;
        sel2 = 2'b10;
        sel3 = 2'b10;

        #10;

        $display("Test 3");
        $display("OUT0 = %h", out0);
        $display("OUT1 = %h", out1);
        $display("OUT2 = %h", out2);
        $display("OUT3 = %h", out3);

        #10;

        $finish;

    end

    initial begin
        $monitor(
            "Time=%0t | IN=%h %h %h %h | SEL=%b %b %b %b | OUT=%h %h %h %h",
            $time,
            in0, in1, in2, in3,
            sel0, sel1, sel2, sel3,
            out0, out1, out2, out3
        );
    end

endmodule