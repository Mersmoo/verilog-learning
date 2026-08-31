module fifo #(
    parameter DATA_WIDTH = 8,
    parameter DEPTH = 8
)(
    input  wire                  clk,
    input  wire                  reset,

    input  wire                  write_en,
    input  wire                  read_en,

    input  wire [DATA_WIDTH-1:0] write_data,
    output reg  [DATA_WIDTH-1:0] read_data,

    output wire                  full,
    output wire                  empty
);

    reg [DATA_WIDTH-1:0] memory [0:DEPTH-1];

    reg [3:0] write_ptr;
    reg [3:0] read_ptr;
    reg [3:0] count;

    assign empty = (count == 0);
    assign full  = (count == DEPTH);

    always @(posedge clk) begin

        if (reset) begin

            write_ptr <= 0;
            read_ptr  <= 0;
            count     <= 0;
            read_data <= 0;

        end else begin

            if (write_en && !full) begin

                memory[write_ptr] <= write_data;
                write_ptr <= write_ptr + 1;

            end

            if (read_en && !empty) begin

                read_data <= memory[read_ptr];
                read_ptr <= read_ptr + 1;

            end

            case ({write_en && !full, read_en && !empty})

                2'b10:
                    count <= count + 1;

                2'b01:
                    count <= count - 1;

                default:
                    count <= count;

            endcase

        end
    end

endmodule