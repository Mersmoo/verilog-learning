`timescale 1ns/1ps

module ready_valid_interface_tb;

    parameter DATA_WIDTH = 8;

    reg clk;
    reg reset;

    reg [DATA_WIDTH-1:0] data_in;
    reg valid_in;
    wire ready_in;

    wire [DATA_WIDTH-1:0] data_out;
    wire valid_out;
    reg ready_out;

    wire handshake;

    assign handshake = valid_in && ready_out;

    ready_valid_interface #(
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

        $dumpfile("ready_valid_interface.vcd");
        $dumpvars(0, ready_valid_interface_tb);

        clk = 0;
        reset = 1;

        data_in = 8'h00;
        valid_in = 0;
        ready_out = 0;

        #20;

        reset = 0;

        // Transfer A1
        #10;
        data_in = 8'hA1;
        valid_in = 1;
        ready_out = 1;

        #10;

        // Hold B2 because consumer is not ready
        data_in = 8'hB2;
        ready_out = 0;

        #10;

        // Consumer becomes ready
        ready_out = 1;

        #10;

        // Transfer C3
        data_in = 8'hC3;

        #10;

        // Stop valid
        valid_in = 0;

        #20;

        $finish;

    end

    initial begin

        $monitor(
            "Time=%0t | data_in=%h | valid_in=%b | ready_in=%b | data_out=%h | valid_out=%b | ready_out=%b | handshake=%b",
            $time,
            data_in,
            valid_in,
            ready_in,
            data_out,
            valid_out,
            ready_out,
            handshake
        );

    end

endmodule