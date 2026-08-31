module spi_master #(
    parameter CLK_DIV = 4
)(
    input  wire       clk,
    input  wire       rst,

    input  wire       start,
    input  wire [7:0] tx_data,

    input  wire       miso,

    output reg  [7:0] rx_data,
    output reg        busy,
    output reg        done,

    output reg        sclk,
    output reg        mosi,
    output reg        cs
);

    reg [7:0] tx_shift;
    reg [7:0] rx_shift;

    reg [2:0] bit_count;
    reg [15:0] clk_count;

    always @(posedge clk or posedge rst) begin

        if (rst) begin
            tx_shift <= 8'b0;
            rx_shift <= 8'b0;
            rx_data  <= 8'b0;

            bit_count <= 3'b0;
            clk_count <= 16'b0;

            busy <= 1'b0;
            done <= 1'b0;

            sclk <= 1'b0;
            mosi <= 1'b0;
            cs   <= 1'b1;
        end

        else begin

            done <= 1'b0;

            if (!busy) begin

                if (start) begin

                    busy <= 1'b1;
                    cs   <= 1'b0;

                    sclk <= 1'b0;

                    tx_shift <= tx_data;
                    rx_shift <= 8'b0;

                    bit_count <= 3'd0;
                    clk_count <= 16'd0;

                    mosi <= tx_data[7];
                end
            end

            else begin

                if (clk_count == CLK_DIV - 1) begin

                    clk_count <= 16'd0;

                    if (sclk == 1'b0) begin

                        // Rising edge: sample MISO
                        sclk <= 1'b1;

                        rx_shift <= {rx_shift[6:0], miso};

                    end

                    else begin

                        // Falling edge: prepare next MOSI bit
                        sclk <= 1'b0;

                        if (bit_count == 3'd7) begin

                            busy <= 1'b0;
                            done <= 1'b1;

                            cs <= 1'b1;

                            rx_data <= rx_shift;

                            mosi <= 1'b0;
                        end

                        else begin

                            bit_count <= bit_count + 1'b1;

                            tx_shift <= {tx_shift[6:0], 1'b0};

                            mosi <= tx_shift[6];
                        end
                    end
                end

                else begin
                    clk_count <= clk_count + 1'b1;
                end
            end
        end
    end

endmodule