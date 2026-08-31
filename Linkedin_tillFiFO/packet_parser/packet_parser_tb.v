`timescale 1ns/1ps

module packet_parser_tb;

    parameter MAX_PAYLOAD = 16;

    reg clk;
    reg rst;

    reg data_valid;
    reg [7:0] data_in;

    wire packet_valid;
    wire error;

    wire [7:0] packet_type;
    wire [7:0] payload_length;

    wire [MAX_PAYLOAD*8-1:0] payload;


    packet_parser #(
        .MAX_PAYLOAD(MAX_PAYLOAD)
    ) dut (
        .clk(clk),
        .rst(rst),

        .data_valid(data_valid),
        .data_in(data_in),

        .packet_valid(packet_valid),
        .error(error),

        .packet_type(packet_type),
        .payload_length(payload_length),

        .payload(payload)
    );


    always #5 clk = ~clk;


    task send_byte;
        input [7:0] byte;
        begin

            @(negedge clk);

            data_in = byte;
            data_valid = 1'b1;

            @(negedge clk);

            data_valid = 1'b0;
            data_in = 8'h00;

        end
    endtask


    initial begin

        $dumpfile("packet_parser.vcd");
        $dumpvars(0, packet_parser_tb);

        clk = 1'b0;
        rst = 1'b1;

        data_valid = 1'b0;
        data_in = 8'h00;

        #20;

        rst = 1'b0;


        // =========================================================
        // TEST 1: Valid packet
        // =========================================================

        $display("");
        $display("======================================");
        $display("TEST 1: VALID PACKET");
        $display("======================================");

        send_byte(8'hAA);
        send_byte(8'h03);
        send_byte(8'h01);

        send_byte(8'h11);
        send_byte(8'h22);
        send_byte(8'h33);

        send_byte(8'h01);

        #10;


        // =========================================================
        // TEST 2: Invalid CRC
        // =========================================================

        $display("");
        $display("======================================");
        $display("TEST 2: INVALID CRC");
        $display("======================================");

        send_byte(8'hAA);
        send_byte(8'h03);
        send_byte(8'h02);

        send_byte(8'hAA);
        send_byte(8'hBB);
        send_byte(8'hCC);

        // Wrong CRC
        send_byte(8'hFF);

        #10;


        // =========================================================
        // TEST 3: Invalid payload length
        // =========================================================

        $display("");
        $display("======================================");
        $display("TEST 3: INVALID LENGTH");
        $display("======================================");

        send_byte(8'hAA);

        // MAX_PAYLOAD = 16
        // 20 is invalid
        send_byte(8'h14);

        #20;


        $display("");
        $display("======================================");
        $display("SIMULATION FINISHED");
        $display("======================================");

        $finish;

    end


    always @(posedge clk) begin

        if (packet_valid) begin

            $display("");
            $display("PACKET VALID");
            $display("TYPE   = %h", packet_type);
            $display("LENGTH = %d", payload_length);

            $display(
                "PAYLOAD[0] = %h",
                payload[7:0]
            );

            $display(
                "PAYLOAD[1] = %h",
                payload[15:8]
            );

            $display(
                "PAYLOAD[2] = %h",
                payload[23:16]
            );

        end


        if (error) begin

            $display("");
            $display("PACKET ERROR");

        end

    end

endmodule