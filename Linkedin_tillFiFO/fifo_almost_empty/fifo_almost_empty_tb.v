`timescale 1ns/1ps

module fifo_almost_empty_tb;

    parameter DATA_WIDTH = 8;
    parameter FIFO_DEPTH = 8;
    parameter ALMOST_EMPTY_THRESHOLD = 2;

    reg clk;
    reg reset;

    reg [DATA_WIDTH-1:0] write_data;
    reg write_en;
    reg read_en;

    wire [DATA_WIDTH-1:0] read_data;

    wire empty;
    wire full;
    wire almost_empty;

    fifo_almost_empty #(
        .DATA_WIDTH(DATA_WIDTH),
        .FIFO_DEPTH(FIFO_DEPTH),
        .ALMOST_EMPTY_THRESHOLD(ALMOST_EMPTY_THRESHOLD)
    ) dut (
        .clk(clk),
        .reset(reset),

        .write_data(write_data),
        .write_en(write_en),
        .read_en(read_en),

        .read_data(read_data),

        .empty(empty),
        .full(full),
        .almost_empty(almost_empty)
    );

    always #5 clk = ~clk;

    initial begin

        $dumpfile("fifo_almost_empty.vcd");
        $dumpvars(0, fifo_almost_empty_tb);

        clk = 0;
        reset = 1;

        write_data = 0;
        write_en = 0;
        read_en = 0;

        #20;

        reset = 0;

        // Write four values
        #10;
        write_data = 8'hA1;
        write_en = 1;

        #10;
        write_data = 8'hB2;

        #10;
        write_data = 8'hC3;

        #10;
        write_data = 8'hD4;

        #10;
        write_en = 0;

        // Read two values
        #10;
        read_en = 1;

        #10;
        read_en = 1;

        #10;
        read_en = 0;

        // Read one more value
        #10;
        read_en = 1;

        #10;
        read_en = 0;

        // Read final value
        #10;
        read_en = 1;

        #10;
        read_en = 0;

        #20;

        $finish;

    end

    initial begin
        $monitor(
            "Time=%0t | write_en=%b | read_en=%b | data_in=%h | data_out=%h | count=%0d | empty=%b | almost_empty=%b | full=%b",
            $time,
            write_en,
            read_en,
            write_data,
            read_data,
            dut.count,
            empty,
            almost_empty,
            full
        );
    end

endmodule