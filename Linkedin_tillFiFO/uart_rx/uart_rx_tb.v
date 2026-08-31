`timescale 1ns/1ps

module uart_rx_tb;

    reg clk;
    reg reset;
    reg rx;

    wire [7:0] rx_data;
    wire       rx_data_valid;


    uart_rx #(
        .CLK_FREQ(50_000_000),
        .BAUD_RATE(9600)
    ) uut (
        .clk(clk),
        .reset(reset),
        .rx(rx),
        .rx_data(rx_data),
        .rx_data_valid(rx_data_valid)
    );


    // 50 MHz clock
    always #10 clk = ~clk;


    // 9600 baud
    // One bit = approximately 104.166 us
    task send_uart_byte;

        input [7:0] data;
        integer i;

        begin

            // Start bit
            rx = 1'b0;
            #104167;

            // Data bits, LSB first
            for (i = 0; i < 8; i = i + 1) begin
                rx = data[i];
                #104167;
            end

            // Stop bit
            rx = 1'b1;
            #104167;

        end

    endtask


    initial begin

        $dumpfile("uart_rx.vcd");
        $dumpvars(0, uart_rx_tb);

        clk   = 1'b0;
        reset = 1'b1;
        rx    = 1'b1;

        #100;

        reset = 1'b0;

        #100;


        // Send character 'A'
        send_uart_byte(8'h41);

        #500;


        // Send character 'U'
        send_uart_byte(8'h55);

        #500;


        // Send character 'Z'
        send_uart_byte(8'h5A);

        #500;

        $finish;

    end


    always @(posedge rx_data_valid) begin

        $display(
            "Time=%0t | RX DATA = 0x%02h | Character = %c",
            $time,
            rx_data,
            rx_data
        );

    end

endmodule