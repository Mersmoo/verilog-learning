module uart_rx #(
    parameter integer CLK_FREQ  = 50_000_000,
    parameter integer BAUD_RATE = 9600
)(
    input  wire       clk,
    input  wire       reset,

    input  wire       rx,

    output reg [7:0] rx_data,
    output reg       rx_data_valid
);

    localparam integer CLKS_PER_BIT = CLK_FREQ / BAUD_RATE;
    localparam integer HALF_BIT     = CLKS_PER_BIT / 2;

    localparam [1:0]
        IDLE  = 2'd0,
        START = 2'd1,
        DATA  = 2'd2,
        STOP  = 2'd3;

    reg [1:0] state;

    reg [31:0] clk_count;
    reg [2:0]  bit_count;

    reg [7:0] data_reg;

    reg rx_sync1;
    reg rx_sync2;

    always @(posedge clk or posedge reset) begin

        if (reset) begin
            rx_sync1 <= 1'b1;
            rx_sync2 <= 1'b1;
        end

        else begin
            rx_sync1 <= rx;
            rx_sync2 <= rx_sync1;
        end

    end


    always @(posedge clk or posedge reset) begin

        if (reset) begin
            state          <= IDLE;
            clk_count      <= 0;
            bit_count      <= 0;
            data_reg       <= 0;
            rx_data        <= 0;
            rx_data_valid  <= 1'b0;
        end

        else begin

            rx_data_valid <= 1'b0;

            case (state)

                IDLE: begin
                    clk_count <= 0;
                    bit_count <= 0;

                    if (rx_sync2 == 1'b0) begin
                        state <= START;
                    end
                end


                START: begin

                    if (clk_count == HALF_BIT - 1) begin

                        clk_count <= 0;

                        if (rx_sync2 == 1'b0) begin
                            state <= DATA;
                        end
                        else begin
                            state <= IDLE;
                        end

                    end
                    else begin
                        clk_count <= clk_count + 1;
                    end

                end


                DATA: begin

                    if (clk_count == CLKS_PER_BIT - 1) begin

                        clk_count <= 0;

                        data_reg[bit_count] <= rx_sync2;

                        if (bit_count == 3'd7) begin
                            bit_count <= 0;
                            state     <= STOP;
                        end
                        else begin
                            bit_count <= bit_count + 1;
                        end

                    end
                    else begin
                        clk_count <= clk_count + 1;
                    end

                end


                STOP: begin

                    if (clk_count == CLKS_PER_BIT - 1) begin

                        clk_count <= 0;

                        if (rx_sync2 == 1'b1) begin
                            rx_data       <= data_reg;
                            rx_data_valid <= 1'b1;
                        end

                        state <= IDLE;

                    end
                    else begin
                        clk_count <= clk_count + 1;
                    end

                end


                default: begin
                    state <= IDLE;
                end

            endcase
        end

    end

endmodule