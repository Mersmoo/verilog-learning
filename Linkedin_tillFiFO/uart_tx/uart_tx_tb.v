`timescale 1ns/1ps

module uart_tx_tb;

    reg clk;
    reg reset;

    reg       tx_start;
    reg [7:0] tx_data;

    wire tx;
    wire tx_busy;


    uart_tx #(
        .CLK_FREQ(50_000_000),
        .BAUD_RATE(9600)
    ) uut (
        .clk(clk),
        .reset(reset),
        .tx_start(tx_start),
        .tx_data(tx_data),
        .tx(tx),
        .tx_busy(tx_busy)
    );


    always #10 clk = ~clk;


    initial begin

        $dumpfile("uart_tx.vcd");
        $dumpvars(0, uart_tx_tb);

        clk      = 1'b0;
        reset    = 1'b1;
        tx_start = 1'b0;
        tx_data  = 8'h00;

        #100;

        reset = 1'b0;

        #100;


        // Send character 'A'
        tx_data  = 8'h41;
        tx_start = 1'b1;

        #20;

        tx_start = 1'b0;


        wait(tx_busy == 1'b0);

        #1000;


        // Send character 'U'
        tx_data  = 8'h55;
        tx_start = 1'b1;

        #20;

        tx_start = 1'b0;


        wait(tx_busy == 1'b0);

        #1000;


        $finish;

    end


    always @(posedge clk) begin

        $display(
            "Time=%0t | TX=%b | Busy=%b",
            $time,
            tx,
            tx_busy
        );

    end

endmodule