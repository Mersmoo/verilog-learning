`timescale 1ns/1ps

module async_fifo #(
    parameter DATA_WIDTH = 8,
    parameter ADDR_WIDTH = 3
)(
    // WRITE DOMAIN
    input  wire                  wr_clk,
    input  wire                  wr_reset,
    input  wire                  wr_en,
    input  wire [DATA_WIDTH-1:0] wr_data,
    output reg                   full,

    // READ DOMAIN
    input  wire                  rd_clk,
    input  wire                  rd_reset,
    input  wire                  rd_en,
    output reg  [DATA_WIDTH-1:0] rd_data,
    output reg                   empty
);

    localparam PTR_WIDTH = ADDR_WIDTH + 1;
    localparam DEPTH = (1 << ADDR_WIDTH);

    // ------------------------------------------------
    // Memory
    // ------------------------------------------------

    reg [DATA_WIDTH-1:0] mem [0:DEPTH-1];


    // ------------------------------------------------
    // Binary pointers
    // ------------------------------------------------

    reg [PTR_WIDTH-1:0] wr_ptr_bin;
    reg [PTR_WIDTH-1:0] rd_ptr_bin;


    // ------------------------------------------------
    // Gray pointers
    // ------------------------------------------------

    reg [PTR_WIDTH-1:0] wr_ptr_gray;
    reg [PTR_WIDTH-1:0] rd_ptr_gray;


    // ------------------------------------------------
    // Synchronized Gray pointers
    // ------------------------------------------------

    reg [PTR_WIDTH-1:0] rd_gray_sync1;
    reg [PTR_WIDTH-1:0] rd_gray_sync2;

    reg [PTR_WIDTH-1:0] wr_gray_sync1;
    reg [PTR_WIDTH-1:0] wr_gray_sync2;


    // ------------------------------------------------
    // Next values
    // ------------------------------------------------

    wire [PTR_WIDTH-1:0] wr_ptr_bin_next;
    wire [PTR_WIDTH-1:0] wr_ptr_gray_next;

    wire [PTR_WIDTH-1:0] rd_ptr_bin_next;
    wire [PTR_WIDTH-1:0] rd_ptr_gray_next;


    // ------------------------------------------------
    // Next binary pointers
    // ------------------------------------------------

    assign wr_ptr_bin_next =
        wr_ptr_bin + ((wr_en && !full) ? 1'b1 : 1'b0);

    assign rd_ptr_bin_next =
        rd_ptr_bin + ((rd_en && !empty) ? 1'b1 : 1'b0);


    // ------------------------------------------------
    // Binary -> Gray
    // ------------------------------------------------

    assign wr_ptr_gray_next =
        (wr_ptr_bin_next >> 1) ^ wr_ptr_bin_next;

    assign rd_ptr_gray_next =
        (rd_ptr_bin_next >> 1) ^ rd_ptr_bin_next;


    // ------------------------------------------------
    // FULL comparison value
    // ------------------------------------------------

    wire [PTR_WIDTH-1:0] rd_gray_full;

    assign rd_gray_full = {
        ~rd_gray_sync2[PTR_WIDTH-1:PTR_WIDTH-2],
        rd_gray_sync2[PTR_WIDTH-3:0]
    };


    // ------------------------------------------------
    // WRITE DOMAIN
    // ------------------------------------------------

    always @(posedge wr_clk) begin

        if (wr_reset) begin

            wr_ptr_bin  <= 0;
            wr_ptr_gray <= 0;
            full        <= 1'b0;

        end
        else begin

            // Write memory
            if (wr_en && !full) begin

                mem[wr_ptr_bin[ADDR_WIDTH-1:0]] <= wr_data;

            end

            // Update pointers
            wr_ptr_bin  <= wr_ptr_bin_next;
            wr_ptr_gray <= wr_ptr_gray_next;

            // Update FULL flag
            full <= (wr_ptr_gray_next == rd_gray_full);

        end

    end


    // ------------------------------------------------
    // READ DOMAIN
    // ------------------------------------------------

    always @(posedge rd_clk) begin

        if (rd_reset) begin

            rd_ptr_bin  <= 0;
            rd_ptr_gray <= 0;
            rd_data     <= 0;
            empty       <= 1'b1;

        end
        else begin

            // Read memory
            if (rd_en && !empty) begin

                rd_data <= mem[rd_ptr_bin[ADDR_WIDTH-1:0]];

            end

            // Update pointers
            rd_ptr_bin  <= rd_ptr_bin_next;
            rd_ptr_gray <= rd_ptr_gray_next;

            // Update EMPTY flag
            empty <= (rd_ptr_gray_next == wr_gray_sync2);

        end

    end


    // ------------------------------------------------
    // READ POINTER -> WRITE DOMAIN
    // ------------------------------------------------

    always @(posedge wr_clk) begin

        if (wr_reset) begin

            rd_gray_sync1 <= 0;
            rd_gray_sync2 <= 0;

        end
        else begin

            rd_gray_sync1 <= rd_ptr_gray;
            rd_gray_sync2 <= rd_gray_sync1;

        end

    end


    // ------------------------------------------------
    // WRITE POINTER -> READ DOMAIN
    // ------------------------------------------------

    always @(posedge rd_clk) begin

        if (rd_reset) begin

            wr_gray_sync1 <= 0;
            wr_gray_sync2 <= 0;

        end
        else begin

            wr_gray_sync1 <= wr_ptr_gray;
            wr_gray_sync2 <= wr_gray_sync1;

        end

    end

endmodule