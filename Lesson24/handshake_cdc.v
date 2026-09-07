`timescale 1ns/1ps

module handshake_cdc #(
    parameter DATA_WIDTH = 32
)(
    input  wire                  src_clk,
    input  wire                  src_rst,

    input  wire                  src_valid,
    input  wire [DATA_WIDTH-1:0] src_data,
    output wire                  src_ready,

    input  wire                  dst_clk,
    input  wire                  dst_rst,

    output reg  [DATA_WIDTH-1:0] dst_data,
    output reg                   dst_valid
);

    // Data register in source clock domain
    reg [DATA_WIDTH-1:0] data_reg;

    // Request signal generated in source domain
    reg req;

    // Acknowledge signal generated in destination domain
    reg ack;

    // Synchronizers for request
    reg req_sync1;
    reg req_sync2;

    // Synchronizers for acknowledge
    reg ack_sync1;
    reg ack_sync2;

    // Source is ready when previous transfer is complete
    assign src_ready = (req == ack_sync2);

    // Source clock domain
    always @(posedge src_clk or posedge src_rst) begin
        if (src_rst) begin
            data_reg <= {DATA_WIDTH{1'b0}};
            req      <= 1'b0;
        end
        else begin
            // Start a new transfer only when the interface is ready
            if (src_valid && src_ready) begin
                data_reg <= src_data;
                req      <= ~req;
            end
        end
    end

    // Synchronize acknowledge into source clock domain
    always @(posedge src_clk or posedge src_rst) begin
        if (src_rst) begin
            ack_sync1 <= 1'b0;
            ack_sync2 <= 1'b0;
        end
        else begin
            ack_sync1 <= ack;
            ack_sync2 <= ack_sync1;
        end
    end

    // Synchronize request into destination clock domain
    always @(posedge dst_clk or posedge dst_rst) begin
        if (dst_rst) begin
            req_sync1 <= 1'b0;
            req_sync2 <= 1'b0;
        end
        else begin
            req_sync1 <= req;
            req_sync2 <= req_sync1;
        end
    end

    // Destination clock domain
    always @(posedge dst_clk or posedge dst_rst) begin
        if (dst_rst) begin
            dst_data  <= {DATA_WIDTH{1'b0}};
            dst_valid <= 1'b0;
            ack       <= 1'b0;
        end
        else begin
            dst_valid <= 1'b0;

            // Detect a new request
            if (req_sync2 != ack) begin
                dst_data  <= data_reg;
                dst_valid <= 1'b1;

                // Acknowledge the received data
                ack <= req_sync2;
            end
        end
    end

endmodule