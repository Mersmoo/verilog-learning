`timescale 1ns/1ps

module debouncer_tb;

    reg clk;
    reg rst;
    reg button;

    wire button_clean;


    // Debouncer instance

    debouncer #(
        .COUNTER_WIDTH(4)
    ) uut (

        .clk(clk),
        .rst(rst),
        .button(button),

        .button_clean(button_clean)
    );


    // 100 MHz clock

    initial begin
        clk = 1'b0;

        forever #5 clk = ~clk;
    end


    initial begin

        rst = 1'b1;
        button = 1'b0;

        #20;

        rst = 1'b0;

        #30;


        // Button press with bouncing

        button = 1'b1;
        #10;

        button = 1'b0;
        #10;

        button = 1'b1;
        #10;

        button = 1'b0;
        #10;

        button = 1'b1;


        // Keep button stable

        #200;


        // Button release with bouncing

        button = 1'b0;
        #10;

        button = 1'b1;
        #10;

        button = 1'b0;
        #10;

        button = 1'b1;
        #10;

        button = 1'b0;


        // Keep button stable

        #200;


        $finish;

    end


    // VCD waveform

    initial begin

        $dumpfile("debouncer.vcd");
        $dumpvars(0, debouncer_tb);

    end

endmodule