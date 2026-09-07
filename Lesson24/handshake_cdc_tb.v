`timescale 1ns/1ps

module handshake_cdc_tb;

    parameter DATA_WIDTH = 32;

    reg src_clk;
    reg src_rst;

    reg src_valid;
    reg [DATA_WIDTH-1:0] src_data;
    wire src_ready;

    reg dst_clk;
    reg dst_rst;

    wire [DATA_WIDTH-1:0] dst_data;
    wire dst_valid;

    // Instantiate DUT
    handshake_cdc #(
        .DATA_WIDTH(DATA_WIDTH)
    ) dut (
        .src_clk(src_clk),
        .src_rst(src_rst),
        .src_valid(src_valid),
        .src_data(src_data),
        .src_ready(src_ready),

        .dst_clk(dst_clk),
        .dst_rst(dst_rst),
        .dst_data(dst_data),
        .dst_valid(dst_valid)
    );

    // Source clock: 10 ns period
    always #5 src_clk = ~src_clk;

    // Destination clock: 14 ns period
    always #7 dst_clk = ~dst_clk;

    // Send one data word
    task send_data;
        input [DATA_WIDTH-1:0] data;
        begin
            // Wait until the interface is ready
            @(posedge src_clk);

            while (!src_ready)
                @(posedge src_clk);

            src_data  <= data;
            src_valid <= 1'b1;

            @(posedge src_clk);

            src_valid <= 1'b0;

            // Wait for transfer completion
            while (!src_ready)
                @(posedge src_clk);

            $display(
                "[%0t] SOURCE: Data 0x%08h transferred",
                $time,
                data
            );
        end
    endtask

    // Monitor destination
    always @(posedge dst_clk) begin
        if (dst_valid) begin
            $display(
                "[%0t] DESTINATION: Data received = 0x%08h",
                $time,
                dst_data
            );
        end
    end

    initial begin

        // Initialize signals
        src_clk   = 1'b0;
        dst_clk   = 1'b0;

        src_rst   = 1'b1;
        dst_rst   = 1'b1;

        src_valid = 1'b0;
        src_data  = 32'h00000000;

        // VCD waveform
        $dumpfile("handshake_cdc.vcd");
        $dumpvars(0, handshake_cdc_tb);

        // Reset
        #30;

        src_rst = 1'b0;
        dst_rst = 1'b0;

        $display("----------------------------------------");
        $display("Starting Handshake CDC Test");
        $display("----------------------------------------");

        // Send first data
        send_data(32'h12345678);

        // Wait
        #30;

        // Send second data
        send_data(32'hA5A5A5A5);

        #30;

        // Send third data
        send_data(32'hDEADBEEF);

        #50;

        $display("----------------------------------------");
        $display("TEST PASSED");
        $display("----------------------------------------");

        $finish;
    end

endmodule