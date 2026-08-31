module shift_register (
    input clk,
    input reset,
    input din,
    output reg [3:0] q
);

always @(posedge clk) begin
    if (reset)
        q <= 4'b0000;
    else
        q <= {q[2:0], din};
end

endmodule