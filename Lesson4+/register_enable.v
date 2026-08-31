`timescale 1ns/1ps

module register_enable (
    input clk,
    input reset,
    input enable,
    input [7:0] d,
    output reg [7:0] q
);

always @(posedge clk) begin

    if (reset)
        q <= 8'b0;

    else if (enable)
        q <= d;

    else
        q <= q;

end

endmodule