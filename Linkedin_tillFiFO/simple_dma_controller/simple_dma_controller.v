module simple_dma_controller #(
    parameter ADDR_WIDTH = 8,
    parameter DATA_WIDTH = 8
)(
    input clk,
    input rst,

    input start,
    input [ADDR_WIDTH-1:0] src_addr,
    input [ADDR_WIDTH-1:0] length,

    output reg [ADDR_WIDTH-1:0] mem_addr,
    input      [DATA_WIDTH-1:0] mem_data,

    output reg [DATA_WIDTH-1:0] data_out,
    output reg                  data_valid,

    output reg busy,
    output reg done
);

    localparam IDLE = 2'd0;
    localparam READ = 2'd1;
    localparam DONE = 2'd2;

    reg [1:0] state;

    reg [ADDR_WIDTH-1:0] current_addr;
    reg [ADDR_WIDTH-1:0] remaining;


    always @(posedge clk or posedge rst) begin

        if (rst) begin

            state         <= IDLE;
            mem_addr      <= {ADDR_WIDTH{1'b0}};
            current_addr  <= {ADDR_WIDTH{1'b0}};
            remaining     <= {ADDR_WIDTH{1'b0}};

            data_out      <= {DATA_WIDTH{1'b0}};
            data_valid    <= 1'b0;

            busy          <= 1'b0;
            done          <= 1'b0;

        end

        else begin

            data_valid <= 1'b0;
            done       <= 1'b0;

            case (state)

                IDLE: begin

                    busy <= 1'b0;

                    if (start && (length != 0)) begin

                        current_addr <= src_addr;
                        mem_addr     <= src_addr;
                        remaining    <= length;

                        busy  <= 1'b1;
                        state <= READ;

                    end

                end


                READ: begin

                    busy       <= 1'b1;

                    data_out   <= mem_data;
                    data_valid <= 1'b1;

                    if (remaining == 1) begin

                        remaining <= 0;

                        state <= DONE;

                    end

                    else begin

                        current_addr <= current_addr + 1'b1;
                        mem_addr     <= current_addr + 1'b1;
                        remaining    <= remaining - 1'b1;

                    end

                end


                DONE: begin

                    busy <= 1'b0;
                    done <= 1'b1;

                    state <= IDLE;

                end


                default: begin

                    state <= IDLE;
                    busy  <= 1'b0;

                end

            endcase

        end

    end

endmodule
