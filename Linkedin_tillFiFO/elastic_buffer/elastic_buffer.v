module elastic_buffer #(
    parameter DATA_WIDTH = 8
)(
    input  wire                  clk,
    input  wire                  reset,

    input  wire [DATA_WIDTH-1:0] data_in,
    input  wire                  valid_in,
    output wire                  ready_in,

    output wire [DATA_WIDTH-1:0] data_out,
    output wire                  valid_out,
    input  wire                  ready_out
);

    reg [DATA_WIDTH-1:0] buffer_data;
    reg                  buffer_valid;

    assign ready_in = !buffer_valid || ready_out;

    assign valid_out = buffer_valid;

    assign data_out = buffer_data;

    always @(posedge clk) begin

        if (reset) begin
            buffer_data  <= 0;
            buffer_valid <= 1'b0;
        end

        else begin

            if (ready_in) begin

                buffer_valid <= valid_in;

                if (valid_in) begin
                    buffer_data <= data_in;
                end

            end

        end

    end

endmodule