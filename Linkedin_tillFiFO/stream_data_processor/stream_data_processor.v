module stream_data_processor #(
    parameter DATA_WIDTH = 8
)(
    input clk,
    input rst,

    input [DATA_WIDTH-1:0] data_in,
    input                  valid_in,

    output reg [DATA_WIDTH-1:0] data_out,
    output reg                  valid_out
);

    always @(posedge clk or posedge rst) begin

        if (rst) begin

            data_out  <= {DATA_WIDTH{1'b0}};
            valid_out <= 1'b0;

        end

        else begin

            valid_out <= valid_in;

            if (valid_in) begin
                data_out <= data_in + 1'b1;
            end

        end

    end

endmodule