module fifo_almost_empty #(
    parameter DATA_WIDTH = 8,
    parameter FIFO_DEPTH = 8,
    parameter ALMOST_EMPTY_THRESHOLD = 2
)(
    input wire                  clk,
    input wire                  reset,

    input wire [DATA_WIDTH-1:0] write_data,
    input wire                  write_en,
    input wire                  read_en,

    output reg [DATA_WIDTH-1:0] read_data,

    output wire                 empty,
    output wire                 full,
    output wire                 almost_empty
);

    reg [DATA_WIDTH-1:0] memory [0:FIFO_DEPTH-1];

    reg [$clog2(FIFO_DEPTH)-1:0] write_ptr;
    reg [$clog2(FIFO_DEPTH)-1:0] read_ptr;

    reg [$clog2(FIFO_DEPTH+1)-1:0] count;

    assign empty = (count == 0);

    assign full = (count == FIFO_DEPTH);

    assign almost_empty =
        (count <= ALMOST_EMPTY_THRESHOLD);

    always @(posedge clk) begin
        if (reset) begin
            write_ptr <= 0;
            read_ptr  <= 0;
            count     <= 0;
            read_data <= 0;
        end
        else begin

            if (write_en && !full) begin
                memory[write_ptr] <= write_data;
                write_ptr <= write_ptr + 1'b1;
            end

            if (read_en && !empty) begin
                read_data <= memory[read_ptr];
                read_ptr <= read_ptr + 1'b1;
            end

            case ({write_en && !full, read_en && !empty})

                2'b10:
                    count <= count + 1'b1;

                2'b01:
                    count <= count - 1'b1;

                default:
                    count <= count;

            endcase
        end
    end

endmodule