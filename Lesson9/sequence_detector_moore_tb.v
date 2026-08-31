`timescale 1ns/1ps

module sequence_detector_tb;

    reg clk;
    reg reset;
    reg data;

    wire detected;

    // Instantiate DUT
    sequence_detector uut (
        .clk(clk),
        .reset(reset),
        .data(data),
        .detected(detected)
    );

    // Clock: 10 ns period
    always #5 clk = ~clk;

    initial begin
    $dumpfile("sequece_detector.vcd");
    $dumpvars(0, sequence_detector_tb);
        // Monitor signals
        $monitor(
            "Time=%0t | reset=%b | data=%b | state=%b | detected=%b",
            $time,
            reset,
            data,
            uut.state,
            detected
        );

        // Initial values
        clk   = 0;
        reset = 1;
        data  = 0;

        // Reset
        #10;
        reset = 0;

        // -------------------------
        // Test 1: 101
        // -------------------------

        data = 1;
        #10;

        data = 0;
        #10;

        data = 1;
        #10;

        // -------------------------
        // Test 2: 1101
        // -------------------------

        data = 1;
        #10;

        data = 1;
        #10;

        data = 0;
        #10;

        data = 1;
        #10;

        // -------------------------
        // Test 3: 000
        // -------------------------

        data = 0;
        #10;

        data = 0;
        #10;

        data = 0;
        #10;

        // Finish simulation
        $finish;

    end

endmodule