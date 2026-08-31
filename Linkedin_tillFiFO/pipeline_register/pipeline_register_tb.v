`timescale 1ns/1ps

module pipeline_register_tb;

    parameter DATA_WIDTH = 8;

    reg clk;
    reg reset;

    reg [DATA_WIDTH-1:0] data_in;
    wire [DATA_WIDTH-1:0] data_out;

    pipeline_register #(
        .DATA_WIDTH(DATA_WIDTH)
    ) dut (
        .clk(clk),
        .reset(reset),
        .data_in(data_in),
        .data_out(data_out)
    );

    always #5 clk = ~clk;

    initial begin

        $dumpfile("pipeline_register.vcd");
        $dumpvars(0, pipeline_register_tb);

        clk = 0;
        reset = 1;
        data_in = 0;

        #20;

        reset = 0;

        // Apply first data
        #10;
        data_in = 8'h11;

        // Apply second data
        #10;
        data_in = 8'h22;

        // Apply third data
        #10;
        data_in = 8'h33;

        // Apply fourth data
        #10;
        data_in = 8'h44;

        #20;

        $finish;

    end

    initial begin
        $monitor(
            "Time=%0t | data_in=%h | data_out=%h",
            $time,
            data_in,
            data_out
        );
    end

endmodule