module packet_parser #(
    parameter MAX_PAYLOAD = 16
)(
    input clk,
    input rst,

    input data_valid,
    input [7:0] data_in,

    output reg packet_valid,
    output reg error,

    output reg [7:0] packet_type,
    output reg [7:0] payload_length,

    output reg [MAX_PAYLOAD*8-1:0] payload
);

    localparam HEADER = 8'hAA;

    localparam IDLE    = 3'd0;
    localparam LENGTH  = 3'd1;
    localparam TYPE    = 3'd2;
    localparam PAYLOAD = 3'd3;
    localparam CRC     = 3'd4;

    reg [2:0] state;

    reg [7:0] payload_count;
    reg [7:0] crc_calc;

    integer i;

    always @(posedge clk or posedge rst) begin

        if (rst) begin

            state          <= IDLE;
            packet_valid   <= 1'b0;
            error          <= 1'b0;
            packet_type    <= 8'h00;
            payload_length <= 8'h00;
            payload_count  <= 8'h00;
            crc_calc       <= 8'h00;
            payload        <= {(MAX_PAYLOAD*8){1'b0}};

        end

        else begin

            packet_valid <= 1'b0;
            error        <= 1'b0;

            if (data_valid) begin

                case (state)

                    IDLE: begin

                        if (data_in == HEADER) begin
                            state <= LENGTH;
                        end

                    end


                    LENGTH: begin

                        if ((data_in > 0) && (data_in <= MAX_PAYLOAD)) begin

                            payload_length <= data_in;
                            payload_count  <= 8'd0;

                            crc_calc <= data_in;

                            state <= TYPE;

                        end

                        else begin

                            error <= 1'b1;
                            state <= IDLE;
                        end

                    end


                    TYPE: begin

                        packet_type <= data_in;

                        crc_calc <= crc_calc ^ data_in;

                        state <= PAYLOAD;

                    end


                    PAYLOAD: begin

                        payload[payload_count*8 +: 8] <= data_in;

                        crc_calc <= crc_calc ^ data_in;

                        if (payload_count == payload_length - 1) begin

                            state <= CRC;

                        end

                        else begin

                            payload_count <= payload_count + 1'b1;

                        end

                    end


                    CRC: begin

                        if (data_in == crc_calc) begin

                            packet_valid <= 1'b1;

                        end

                        else begin

                            error <= 1'b1;

                        end

                        state <= IDLE;

                    end


                    default: begin

                        state <= IDLE;

                    end

                endcase

            end

        end

    end

endmodule