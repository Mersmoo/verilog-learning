`timescale 1ns/1ps

module spi_master_tb;

    reg clk;
    reg rst;

    reg start;
    reg [7:0] tx_data;

    wire miso;

    wire [7:0] rx_data;
    wire busy;
    wire done;

    wire sclk;
    wire mosi;
    wire cs;


    // Loopback connection
    assign miso = mosi;


    // SPI Master instance

    spi_master #(
        .CLK_DIV(4)
    ) uut (
        .clk(clk),
        .rst(rst),

        .start(start),
        .tx_data(tx_data),

        .miso(miso),

        .rx_data(rx_data),
        .busy(busy),
        .done(done),

        .sclk(sclk),
        .mosi(mosi),
        .cs(cs)
    );


    // 100 MHz system clock

    initial begin
        clk = 1'b0;

        forever #5 clk = ~clk;
    end


    // Test sequence

    initial begin

        rst = 1'b1;
        start = 1'b0;
        tx_data = 8'b0;

        #20;

        rst = 1'b0;

        #20;

        // Send 0xB2

        tx_data = 8'b10110010;

        start = 1'b1;

        #10;

        start = 1'b0;


        // Wait until transaction is complete

        wait(done);

        #20;

        $display("--------------------------------");
        $display("SPI Loopback Test");
        $display("TX Data = %h", tx_data);
        $display("RX Data = %h", rx_data);
        $display("--------------------------------");


        #20;

        $finish;

    end


    // VCD waveform

    initial begin

        $dumpfile("spi_master.vcd");
        $dumpvars(0, spi_master_tb);
    end

endmodule