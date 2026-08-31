`timescale 1ns/1ps

module fifo_tb;

    reg clk;
    reg reset;

    reg write_en;
    reg read_en;

    reg [7:0] write_data;
    wire [7:0] read_data;

    wire full;
    wire empty;

    fifo #(
        .DATA_WIDTH(8),
        .DEPTH(8)
    ) uut (

        .clk(clk),
        .reset(reset),

        .write_en(write_en),
        .read_en(read_en),

        .write_data(write_data),
        .read_data(read_data),

        .full(full),
        .empty(empty)
    );

    always #5 clk = ~clk;

    initial begin

        $dumpfile("fifo.vcd");
        $dumpvars(0, fifo_tb);

        clk = 0;
        reset = 1;

        write_en = 0;
        read_en = 0;
        write_data = 0;

        #10;

        reset = 0;

        // Write 10
        @(negedge clk);
        write_en = 1;
        write_data = 8'd10;

        // Write 20
        @(negedge clk);
        write_data = 8'd20;

        // Write 30
        @(negedge clk);
        write_data = 8'd30;

        // Stop writing
        @(negedge clk);
        write_en = 0;

        // Start reading
        read_en = 1;

        @(negedge clk);
        @(negedge clk);
        @(negedge clk);

        read_en = 0;

        #20;

        $finish;

    end

    always @(posedge clk) begin

        $display(
            "TIME=%0t | write_en=%b write_data=%d | read_en=%b read_data=%d | count=%d | full=%b empty=%b",
            $time,
            write_en,
            write_data,
            read_en,
            read_data,
            uut.count,
            full,
            empty
        );

    end

endmodule