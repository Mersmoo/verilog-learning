`timescale 1ns/1ps

module elastic_buffer_tb;

    parameter DATA_WIDTH = 8;

    reg clk;
    reg reset;

    reg [DATA_WIDTH-1:0] data_in;
    reg valid_in;
    wire ready_in;

    wire [DATA_WIDTH-1:0] data_out;
    wire valid_out;
    reg ready_out;

    elastic_buffer #(
        .DATA_WIDTH(DATA_WIDTH)
    ) dut (
        .clk(clk),
        .reset(reset),

        .data_in(data_in),
        .valid_in(valid_in),
        .ready_in(ready_in),

        .data_out(data_out),
        .valid_out(valid_out),
        .ready_out(ready_out)
    );

    always #5 clk = ~clk;

    initial begin

        $dumpfile("elastic_buffer.vcd");
        $dumpvars(0, elastic_buffer_tb);

        clk = 0;
        reset = 1;

        data_in = 0;
        valid_in = 0;
        ready_out = 0;

        #20;

        reset = 0;

        // Send first data while consumer is stalled
        #10;
        data_in = 8'hA1;
        valid_in = 1;

        #10;

        // Change input data
        data_in = 8'hB2;

        #10;

        // Consumer becomes ready
        ready_out = 1;

        #10;

        // Send another value
        data_in = 8'hC3;

        #10;

        valid_in = 0;

        #20;

        $finish;

    end

    initial begin

        $monitor(
            "Time=%0t | valid_in=%b | ready_in=%b | data_in=%h | valid_out=%b | ready_out=%b | data_out=%h",
            $time,
            valid_in,
            ready_in,
            data_in,
            valid_out,
            ready_out,
            data_out
        );

    end

endmodule