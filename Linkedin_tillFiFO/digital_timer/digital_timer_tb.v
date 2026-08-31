`timescale 1ns/1ps

module digital_timer_tb;

    reg clk;
    reg rst;

    reg start;
    reg stop;

    wire [5:0] seconds;
    wire [5:0] minutes;

    wire running;


    // Digital Timer instance

    digital_timer #(
        .CLK_FREQ(10)
    ) uut (

        .clk(clk),
        .rst(rst),

        .start(start),
        .stop(stop),

        .seconds(seconds),
        .minutes(minutes),

        .running(running)
    );


    // Clock generation

    initial begin

        clk = 1'b0;

        forever #5 clk = ~clk;

    end


    // Test sequence

    initial begin

        rst = 1'b1;
        start = 1'b0;
        stop = 1'b0;


        #20;

        rst = 1'b0;


        // Start timer

        #10;

        start = 1'b1;

        #10;

        start = 1'b0;


        // Run timer

        #650;


        // Stop timer

        stop = 1'b1;

        #10;

        stop = 1'b0;


        #50;


        $finish;

    end


    // VCD waveform

    initial begin

        $dumpfile("digital_timer.vcd");
        $dumpvars(0, digital_timer_tb);
    end


endmodule