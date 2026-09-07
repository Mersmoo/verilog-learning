`timescale 1ns/1ps

module axis_tb;

    reg clk;
    reg rst;

    wire [31:0] data;
    wire        valid;
    wire        ready;

    axis_producer producer (
        .clk   (clk),
        .rst   (rst),
        .data  (data),
        .valid (valid),
        .ready (ready)
    );

    axis_consumer consumer (
        .clk   (clk),
        .rst   (rst),
        .data  (data),
        .valid (valid),
        .ready (ready)
    );

    always #5 clk = ~clk;

    initial begin

        $dumpfile("axis_wave.vcd");
        $dumpvars(0, axis_tb);

        clk = 1'b0;
        rst = 1'b1;

        #20;

        rst = 1'b0;

        #150;

        $display("----------------------------------------");
        $display("Simulation finished");
        $display("----------------------------------------");

        $finish;
    end

    initial begin
        $monitor(
            "TIME=%0t | VALID=%b | READY=%b | DATA=%0d",
            $time,
            valid,
            ready,
            data
        );
    end

endmodule