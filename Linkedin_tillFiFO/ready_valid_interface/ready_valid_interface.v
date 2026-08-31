module ready_valid_interface #(
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

    assign ready_in = ready_out;

    assign valid_out = valid_in;

    assign data_out = data_in;

endmodule