`timescale 1ns/1ps

module universal_shift_register_tb;

    reg clk;
    reg reset;

    reg [1:0] mode;

    reg serial_in_left;
    reg serial_in_right;

    reg [3:0] parallel_in;

    wire [3:0] q;


    universal_shift_register uut (
        .clk(clk),
        .reset(reset),
        .mode(mode),
        .serial_in_left(serial_in_left),
        .serial_in_right(serial_in_right),
        .parallel_in(parallel_in),
        .q(q)
    );


    // Clock generation
    always #5 clk = ~clk;


    initial begin
    $dumpfile("universal_shift_register.vcd");
    $dumpvars(0, universal_shift_register_tb);
        $monitor("Time=%0t | reset=%b | mode=%b | parallel=%b | Q=%b",
                 $time, reset, mode, parallel_in, q);


        clk = 0;
        reset = 1;

        mode = 2'b00;

        serial_in_left = 0;
        serial_in_right = 0;

        parallel_in = 4'b0000;


        // Reset
        #10;
        reset = 0;


        // Parallel Load
        mode = 2'b11;
        parallel_in = 4'b1011;

        #10;


        // Hold
        mode = 2'b00;

        #10;


        // Shift Right
        mode = 2'b01;
        serial_in_left = 0;

        #10;


        // Shift Right again
        serial_in_left = 1;

        #10;


        // Shift Left
        mode = 2'b10;
        serial_in_right = 0;

        #10;


        // Shift Left again
        serial_in_right = 1;

        #10;


        $finish;

    end

endmodule